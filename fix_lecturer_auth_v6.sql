-- First, make sure we have the UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Drop existing trigger and function
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP FUNCTION IF EXISTS handle_lecturer_signup();

-- Create the function with proper error handling
CREATE OR REPLACE FUNCTION handle_lecturer_signup()
RETURNS TRIGGER AS $$
DECLARE
  v_department_id UUID;
BEGIN
  -- Get department ID from name
  SELECT id INTO v_department_id
  FROM departments
  WHERE name = COALESCE(NEW.raw_user_meta_data->>'department', 'Education');
  
  -- If department doesn't exist, create it
  IF v_department_id IS NULL THEN
    INSERT INTO departments (name)
    VALUES (COALESCE(NEW.raw_user_meta_data->>'department', 'Education'))
    RETURNING id INTO v_department_id;
  END IF;

  -- Create lecturer record
  INSERT INTO lecturers (
    user_id,
    name,
    email,
    department,
    occupation,
    employment_type,
    gender,
    profile_image_path,
    lecture_number
  ) VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'name', NEW.email),
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'department', 'Education'),
    COALESCE(NEW.raw_user_meta_data->>'occupation', 'Lecturer'),
    COALESCE(NEW.raw_user_meta_data->>'employment_type', 'Full Time'),
    COALESCE(NEW.raw_user_meta_data->>'gender', 'Not Specified'),
    null,
    'LC' || SUBSTRING(MD5(NEW.id::text) FROM 1 FOR 6)
  );

  -- Create default preferences
  INSERT INTO user_preferences (
    user_id,
    dark_mode_enabled,
    has_completed_onboarding,
    language
  ) VALUES (
    NEW.id,
    false,
    false,
    'en'
  );

  RETURN NEW;
EXCEPTION
  WHEN others THEN
    RAISE LOG 'Error in handle_lecturer_signup: %', SQLERRM;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Recreate the trigger
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  WHEN (NEW.raw_user_meta_data->>'user_type' = 'lecturer')
  EXECUTE FUNCTION handle_lecturer_signup();

-- Make sure RLS is enabled but with proper policies
ALTER TABLE lecturers ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE departments ENABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "Allow lecturer read access" ON lecturers;
DROP POLICY IF EXISTS "Allow lecturer update" ON lecturers;
DROP POLICY IF EXISTS "Allow lecturer insert" ON lecturers;
DROP POLICY IF EXISTS "Allow lecturer preferences read" ON user_preferences;
DROP POLICY IF EXISTS "Allow lecturer preferences update" ON user_preferences;
DROP POLICY IF EXISTS "Allow lecturer preferences insert" ON user_preferences;
DROP POLICY IF EXISTS "Anyone can view departments" ON departments;
DROP POLICY IF EXISTS "Anyone can insert departments" ON departments;

-- Create policies for lecturers table
CREATE POLICY "Allow lecturer read access"
ON lecturers FOR SELECT
USING (true);

CREATE POLICY "Allow lecturer update"
ON lecturers FOR UPDATE
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Allow lecturer insert"
ON lecturers FOR INSERT
WITH CHECK (true);

-- Create policies for user_preferences table
CREATE POLICY "Allow lecturer preferences read"
ON user_preferences FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Allow lecturer preferences update"
ON user_preferences FOR UPDATE
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Allow lecturer preferences insert"
ON user_preferences FOR INSERT
WITH CHECK (true);

-- Create policies for departments table
CREATE POLICY "Anyone can view departments"
ON departments FOR SELECT
USING (true);

CREATE POLICY "Anyone can insert departments"
ON departments FOR INSERT
WITH CHECK (true); 