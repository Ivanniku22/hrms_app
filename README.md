# HRMS App – Flutter Practical Assignment

A mobile HRMS application built with Flutter and Firebase as part of a practical assignment.

## Features

### Employee

* Firebase email/password authentication
* Employee profile
* Attendance check-in/check-out
* Selfie verification with single-face detection
* Location verification against assigned site radius
* Offline attendance storage using SQLite
* Automatic attendance synchronization when internet connectivity is restored
* Attendance history with monthly filtering
* Leave application
* View submitted leave requests and their current status

### Approver

* Firebase email/password authentication
* View pending leave requests
* Approve or reject leave requests
* Real-time update of leave request status

## Tech Stack

* **Flutter**
* **Dart**
* **GetX** – State management and dependency injection
* **Firebase Authentication**
* **Cloud Firestore**
* **Firebase Storage**
* **SQLite (`sqflite`)**
* **Camera**
* **Google ML Kit Face Detection**
* **Geolocator**
* **Connectivity Plus**

## Architecture

The application follows a modular architecture with separation between:

* Views
* Controllers
* Bindings
* Repositories
* Models
* Core Services

GetX is used for state management and dependency injection.

### Project Structure

```text
lib/
├── app/
│   ├── bindings/
│   └── routes/
│
├── core/
│   ├── constants/
│   └── services/
│
├── data/
│   ├── models/
│   ├── local/
│   └── repositories/
│
├── modules/
│   ├── auth/
│   ├── employee/
│   │   ├── dashboard/
│   │   ├── attendance/
│   │   ├── profile/
│   │   └── leave/
│   │
│   └── approver/
│       ├── dashboard/
│       └── leave_approval/
│
├── widgets/
│
├── firebase_options.dart
└── main.dart
```

## Prerequisites

Make sure the following are installed:

* Flutter SDK
* Dart SDK
* Android Studio / Android SDK
* A connected Android device or emulator
* Firebase project

Verify the Flutter installation:

```bash
flutter doctor
```

## Setup

### 1. Clone the repository

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
```

Navigate to the project directory:

```bash
cd hrms_app
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Firebase Configuration

The application uses Firebase Authentication and Cloud Firestore.

Configure Firebase for the required Android/iOS platforms.

Enable:

* Firebase Authentication → Email/Password
* Cloud Firestore

The application uses the following Firestore structure:

```text
users/
└── {userId}/
    └── attendance/
        └── {attendanceId}
```

Leave requests are stored as:

```text
leave_requests/
└── {leaveId}
```

Employee profiles are stored as:

```text
users/
└── {userId}
```

### 4. Run the application

```bash
flutter run
```

## Authentication

The application supports two user roles:

### Employee

Employees are routed to the Employee Dashboard after successful authentication.

### Approver

Approvers are routed to the Approver Dashboard after successful authentication.

The user's role is retrieved from their Firestore profile.

Example user document:

```json
{
  "email": "employee@example.com",
  "name": "John Doe",
  "role": "employee",
  "siteId": "site_001",
  "designation": "Software Engineer",
  "department": "Engineering",
  "manager": "Manager Name",
  "contact": "9876543210",
  "site": "Chennai Office"
}
```

## Attendance

The attendance module provides:

1. Location verification
2. Selfie capture
3. Single-face verification
4. Check-in
5. Check-out
6. Attendance history

### Location Verification

The employee's current location is checked against the assigned site's latitude, longitude and allowed radius.

Attendance can only be checked in when the employee is within the configured site radius.

### Selfie Verification

The employee must capture a selfie before checking in.

Google ML Kit Face Detection is used to verify that:

* At least one face is present
* More than one face is not present

Only selfies containing exactly one detected face are accepted.

### One Attendance Per Day

The application prevents multiple check-ins on the same day.

It also prevents multiple check-outs for the same attendance record.

## Offline Attendance

Attendance is first stored locally using SQLite.

This allows attendance data to be saved even when the device temporarily has no internet connection.

Each local attendance record contains a synchronization status.

When internet connectivity is restored, the synchronization service uploads unsynchronized attendance records to Firestore automatically.

```text
Offline
   ↓
Save attendance locally
   ↓
SQLite
   ↓
Internet restored
   ↓
Sync Service
   ↓
Cloud Firestore
```

## Attendance History

Employees can view their attendance history from the application.

The history displays:

* Date
* Check-in time
* Check-out time
* Attendance status
* Assigned site

A basic month filter is also available.

## Employee Profile

The employee profile displays read-only information retrieved from Firestore:

* Employee ID
* Name
* Designation
* Department
* Manager
* Contact
* Site

Missing information is displayed as `N/A`.

## Leave Management

Employees can submit leave requests by providing:

* Leave type
* Start date
* End date
* Reason

Submitted requests are displayed with their current status.

Possible statuses:

```text
pending
approved
rejected
```

## Leave Approval

Approvers can view pending leave requests.

For each request, the approver can:

* Approve
* Reject

Once an action is taken, the request is removed from the pending list and its status is updated in Firestore.

## Permissions

The application requires the following permissions:

* Camera
* Fine location
* Coarse location

Camera permission is required for selfie verification.

Location permission is required for attendance site verification.

## Firestore Security

Firestore security rules restrict access based on authentication and user roles.

Employees can access their own profile and attendance records.

Approvers can access pending leave requests and update their status.

## Build Release APK

To generate a release APK:

```bash
flutter build apk --release
```

The generated APK will be located at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Code Quality

The project was checked using:

```bash
flutter analyze
```

The project currently passes analysis with no issues.

## Notes

* The application is designed for mobile use.
* Employee profile information is read-only.
* Attendance supports offline storage and later synchronization.
* Only one check-in and one check-out are allowed per day.
* Selfie verification requires exactly one detected face.
* Leave requests require all mandatory fields.
* Approvers can approve or reject pending leave requests.
