# Flutter Attendance System

A Flutter-based attendance system with session management and location verification.  
Supports **Android**, **iOS**, and **Web** platforms.

> **Note:** This is a public script I used.  
> **Full source code is coming soon — currently private.**

---

## Core Features

- QR Code generation and scanning  
- Student authentication  
- Backup key system  
- Session time limits  
- Unit registration check  

## Location Verification (In Progress)

- Lecturer sets location and radius  
- Student's GPS checked at scan  
- Validates proximity using Haversine formula  

## Security

- Session data encryption  
- GPS spoof detection (planned)  
- Time and location-based validation checks  

## Database Tables

- `attendance_sessions`: Stores session details and location info  
- `attendance_records`: Logs student scans and coordinates  

## Tech Stack

- Flutter (frontend)  
- PostgreSQL (backend)  
- REST API (planned)  

## Next Steps

- Add location spoofing detection  
- Enable real-time session updates  
- Improve offline support  

## Full Details and Source Code

GitHub Repository: [Flutter Attendance System](https://github.com/Briankiboi/Flutter-Attendance-System)
