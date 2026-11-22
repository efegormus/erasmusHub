# ErasmusHub 🌍

### CS310 – Mobile Application Development
**Group 25 | Fall 2026**

## 📱 About the Project

ErasmusHub is a Flutter-based mobile application designed to connect university students who are planning to participate in Erasmus+ or bilateral exchange programs with students who have already completed an exchange experience.

The application provides a centralized platform where students can share experiences, explore universities and cities, review courses, discover useful places, and connect with former exchange students.

## 🎯 Problem & Solution

Students preparing for an exchange program often struggle to find reliable, first-hand information about their destination universities, accommodation, living expenses, and academic life.

Due to data privacy regulations, universities cannot freely share the contact information of previous exchange students. As a result, students often rely on scattered social media groups and personal connections.

**ErasmusHub aims to solve this problem** by providing a searchable, student-driven platform where exchange experiences, university ratings, and practical advice can be shared in one place without requiring personal data from universities.

## ✨ Core Features

- **User Authentication:** Registration, login, and email verification.
- **Student Profiles:** Home university, host university, department, exchange term, exchange status, and optional contact links.
- **University & City Search:** Browse universities and cities by country, city, or university name. Users can add a university that is missing from the list.
- **Experience Sharing:** Publish exchange experiences, course information, tips, and recommendations.
- **Ratings & Reviews:** Rate cost of living, course difficulty, professors, housing, safety, and social life on a 1–5 star scale.
- **Comments:** Discuss experiences and ask questions under student posts.
- **Places & City Ratings:** Discover, add, and rate useful places in exchange destinations.
- **Student Matching:** Find returned exchange students from the same host university and department.

## 🚀 Optional Features

The following features may be implemented if time permits:

- Interactive map of rated places
- Moderated WhatsApp group links
- Photo uploads
- Course equivalence tables
- Bookmarks
- Push notifications
- In-app messaging
- University email domain verification

## 🛠️ Technology Stack

| Technology | Purpose |
|------------|---------|
| Flutter | Cross-platform mobile application development |
| Dart | Application programming language |
| Firebase Authentication | User authentication and email verification |
| Cloud Firestore | Cloud-based data storage |
| Git & GitHub | Version control and team collaboration |

## Run locally

Verified on **Flutter 3.47.6 stable** with **Dart 3.13.5**. The pubspec requires
Dart `^3.13.5`. Use the same Flutter version for reproducible team checks and keep
`pubspec.lock` committed.

```sh
flutter --version
flutter pub get
flutter devices
flutter run -d <device-id>
```

Start an Android emulator or connect a phone first. Android needs the Android SDK
and accepted SDK licenses (`flutter doctor --android-licenses`). For iOS on macOS,
install full Xcode, select its developer tools and start an iOS simulator.
`flutter doctor -v` reports missing platform prerequisites. Only Android and iOS
platform folders are included; Chrome/macOS desktop are not configured targets.
If exactly one supported device is connected, `flutter run` is enough.

```sh
flutter analyze
flutter test
flutter build apk --debug  # requires the Android toolchain
```

This is an **in-memory UI prototype**. Login validates the form and opens Home;
Firebase authentication, email delivery and Firestore persistence are not wired.
Sample data and edits reset on restart. All 16 feature routes are connected,
including Home, university forms, Places, Matches and auth recovery. See
[the route contract](docs/navigation.md) for screen behavior and integration checks.

## 🗃️ Data Management

The application is planned to use Firebase Authentication and Cloud Firestore.

The database will store:

- Countries, cities, and universities
- Student profiles and exchange information
- Experience posts and comments
- University and city ratings
- Places, categories, and reviews

The initial country, city, and university lists will be prepared by the development team. Users will be able to add new universities that are missing from the list.

No external API is required for the core functionality. An external maps API may be integrated if the optional map feature is implemented.

## 🔒 Privacy & Security

ErasmusHub is designed with data privacy in mind.

- Only necessary user information will be collected.
- Email verification will be required.
- Contact information will be optional.
- Contact links will only be visible to authenticated users.
- Users will be informed about data collection during registration.
- Users will be able to delete their accounts and associated data.

The project aims to follow applicable data protection requirements, including KVKK.

## 👥 Development Team

**Sabancı University – CS310 – Group 25**

| Team Member | Student ID | Responsibility |
|-------------|------------|----------------|
| Onur Utku Batmaz | 34507 | Authentication, profiles, contact links |
| Mehmet Eren Adıyaman | 33953 | Browsing and search |
| İbrahim Halil Aydın | 35714 | Posts, comments, ratings |
| Rümeysa Şahin | 34069 | Places, city ratings, matching |
| Efe Görmüş | 34417 | Database, Firestore rules, navigation, UI |

**Step 1 Coordinator:** Onur Utku Batmaz

## 📌 Project Status

**Current Phase: Step 2.2 – Flutter UI Implementation**

All approved screens are implemented in Flutter with working navigation, placeholder data, a shared theme and reusable widgets, and a bundled Poppins font. Login and sign-up are UI-only in this step, and Firebase is not connected yet. See [development setup](docs/README.md) for run commands and project structure.

**Implemented screens:** Login, Forgot password, Sign up (two steps), Verify email, Home, University detail, Post detail, New post, Places, Add place, Matches, Profile, Edit profile, Add exchange, Add university and My posts.

The development scope and planned features are described in the project proposal.

## 📚 Course Information

- **Course:** CS310 – Mobile Application Development
- **University:** Sabancı University
- **Semester:** Fall 2026
- **Project:** ErasmusHub
- **Group:** 25
