# Tharaka University College QR Code Attendance System

## Overview
A secure and efficient QR code-based attendance system with location validation and device security features. The system provides both QR code scanning and backup key methods for marking attendance while ensuring the authenticity of student attendance through multiple security layers.

## Features

### 1. Dual Attendance Methods
- **QR Code Scanning**
  - Dynamic QR codes for each session
  - Time-bound validity
  - Location-encoded data
  
- **Backup Key System**
  - Unique session keys
  - Time-limited validity
  - For fallback when QR scanning fails

### 2. Location-Based Security
- **Geofencing**
  - 50-meter default radius from class location
  - Precise GPS coordinate validation
  - Location accuracy monitoring
  
- **Anti-Spoofing Measures**
  - Mock location detection
  - GPS accuracy verification
  - Real-time location validation

### 3. Device Security
- **Device Authentication**
  - Unique device identification
  - Platform and OS verification
  - Network information tracking
  
- **Anti-Fraud Measures**
  - Mock location detection
  - Device fingerprinting
  - Network validation

### 4. Session Management
- **Class Sessions**
  - Time-bound validity
  - Location-specific QR codes
  - Automatic session expiry
  
- **Attendance Tracking**
  - Real-time status updates
  - Present/Late marking
  - Detailed attendance logs

### 5. Database Structure

#### Attendance Sessions Table
```sql
attendance_sessions
├── id (UUID)
├── class_latitude (DECIMAL)
├── class_longitude (DECIMAL)
├── qr_code (TEXT)
├── backup_key (TEXT)
├── start_time (TIMESTAMP)
├── end_time (TIMESTAMP)
└── status (TEXT)
```

#### Attendance Table
```sql
attendance
├── id (UUID)
├── session_id (UUID)
├── student_id (UUID)
├── marked_at (TIMESTAMP)
├── mark_method (TEXT)
├── status (TEXT)
├── student_latitude (DECIMAL)
├── student_longitude (DECIMAL)
├── distance_from_class (DOUBLE)
├── is_within_radius (BOOLEAN)
├── location_accuracy (DOUBLE)
├── device_id (TEXT)
├── is_mock_location (BOOLEAN)
├── network_info (JSONB)
├── verification_status (TEXT)
└── verified_at (TIMESTAMP)
```

### 6. Security Validations

#### Location Verification
- Haversine formula for distance calculation
- Real-time location tracking
- Accuracy threshold checking
- Mock location detection

#### Device Verification
- Device fingerprinting
- Network status monitoring
- Platform-specific security checks
- Anti-spoofing measures

#### Session Verification
- Time-bound validation
- Location-based authentication
- One attendance per student per session
- Real-time status updates

### 7. Technical Implementation

#### Flutter App Features
```dart
DeviceSecurityService
├── getDeviceSecurityInfo()
│   ├── Location data
│   ├── Device information
│   └── Network status
└── validateLocation()
    ├── Distance calculation
    └── Radius verification
```

#### Database Functions
```sql
Functions
├── calculate_distance()
├── verify_attendance_location()
└── verify_device_authenticity()
```

### 8. Error Handling
- Clear error messages
- Fallback mechanisms
- Graceful degradation
- User-friendly notifications

### 9. Performance Optimization
- Indexed queries
- Efficient distance calculations
- Optimized data storage
- Quick validation checks

## Setup Requirements

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  geolocator: ^10.0.0
  device_info_plus: ^9.0.0
  network_info_plus: ^4.0.0
```

### Database Setup
- PostgreSQL with PostGIS extension
- Supabase for real-time features
- Proper indexing for performance

### Environment Setup
1. Clone repository
2. Install dependencies
3. Configure database
4. Set up environment variables

## Security Considerations
- All location data is validated server-side
- Device information is securely stored
- Network validation prevents proxy usage
- Time synchronization checks
- Anti-tampering measures

## Future Enhancements
- [ ] Bluetooth proximity validation
- [ ] Face recognition backup
- [ ] AI-based fraud detection
- [ ] Attendance analytics dashboard
- [ ] Multi-campus support

## Contributing
Contributions are welcome! Please read our contributing guidelines before submitting pull requests.

## License
This project is licensed under the MIT License - see the LICENSE file for details. 