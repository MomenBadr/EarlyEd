# EarlyEd – Smart School Management System

> 🎓 A Flutter & Firebase-based smart school management mobile application developed as a Computer Science graduation project.

**Project Status:** Archived / Graduation Project  
**Platform:** Mobile Application  
**Language:** English  
**Frontend:** Flutter & Dart  
**Backend:** Firebase  
**State Management:** Provider  

---

## 📱 Overview

EarlyEd is a smart school management mobile application designed to provide a centralized platform for communication and academic management between students, parents, teachers, and school administrators.

The application provides role-based access, allowing each user type to access dedicated features and information based on their permissions.

The system was designed to simplify school management processes, improve communication between users, and provide students and parents with easy access to important academic information.

---

## 👥 User Roles

EarlyEd supports multiple user roles with different permissions and functionalities:

- 👨‍🎓 Students
- 👨‍👩‍👧 Parents
- 👨‍🏫 Teachers
- 👨‍💼 Administrators

Each user role has a dedicated profile and access to features relevant to their responsibilities within the school system.

---

## ✨ Features

### 🔐 Authentication & Role-Based Access

- User authentication using Firebase Authentication.
- Role-based access control.
- Different permissions and features for each user type.
- Dedicated user profiles and experiences.

---

### 📅 Attendance Management

- Teachers and administrators can record student attendance.
- Students can view their attendance records.
- Parents can monitor their children's attendance.
- Attendance data is managed and stored using Firebase.

---

### 📊 Grades Management

- Teachers and administrators can enter and manage students' grades.
- Students can view their academic results.
- Parents can monitor their children's academic performance and grades.

---

### 📢 Announcements

- Administrators can publish school announcements.
- Announcements are available to relevant users through the application.
- Users can receive notifications when new announcements are published.

---

### 🔔 Push Notifications

- Integrated Firebase Cloud Messaging (FCM).
- Push notifications for important school announcements.
- Notifications help keep students, parents, and teachers informed about important updates.

---

### 💬 Real-Time Chat

- Real-time communication between application users.
- Support for individual conversations.
- Support for group chats.
- Users can communicate with other members of the school community.
- Real-time messages are managed using Firebase services.

---

### 👤 User Profiles

Dedicated profile pages and user experiences are available for:

- Students
- Parents
- Teachers
- Administrators

Each profile provides access to information and features according to the user's role and permissions.

---

## 🛠️ Tech Stack

### Frontend

- Flutter
- Dart
- Provider – State Management

### Backend & Cloud Services

- Firebase Authentication
- Cloud Firestore
- Firebase Realtime Database
- Firebase Storage
- Firebase Cloud Messaging (FCM)
- Push Notifications

---

## 🏗️ Architecture & State Management

The application was developed using Flutter and Dart, with **Provider** used for state management.

Firebase was used as the primary backend infrastructure for authentication, data storage, real-time communication, file storage, and push notifications.

The application follows a role-based access approach to provide different features and permissions for students, parents, teachers, and administrators.

---

## 📸 Screenshots

The following screenshots provide examples of the application's user interface and some of its implemented functionality.

> **Note:** The displayed UI represents an initial/prototype design created during the development phase. The application's core functionality and business logic were implemented and functional, while the UI/UX was considered an early version and was not intended to represent the final production design.

### Login

![Login Screen](screenshots/login.png)

### Users

![Users Screen](screenshots/users.png)

### Individual & Group Chat

![Chat Screen](screenshots/chat.png)

---

## 🎓 Graduation Project

EarlyEd was developed as a **Computer Science Graduation Project** as part of a team project.

Although the project was completed as a team, I was responsible for the complete technical implementation of the mobile application and its core functionality.

### My Responsibilities

- Developed the Flutter mobile application.
- Implemented the application's user interfaces.
- Implemented role-based access and user flows.
- Integrated Firebase services.
- Implemented authentication and user management.
- Implemented attendance management.
- Implemented grades management.
- Implemented announcements.
- Integrated push notifications using Firebase Cloud Messaging.
- Implemented real-time individual and group chat.
- Managed the application's database integration.
- Prepared the project documentation and graduation project discussion book.
- Prepared the project presentation.

---

## 🔥 Firebase Integration

Firebase was used as the main backend infrastructure for the application.

The project integrated Firebase services for:

- User authentication.
- Cloud data storage.
- Real-time database operations.
- File and media storage.
- Real-time communication.
- Push notifications.

---

## 🚀 Getting Started

### Prerequisites

Before running the project, make sure you have:

- Flutter SDK installed.
- Dart SDK installed.
- Android Studio or Visual Studio Code.
- An Android emulator or a physical Android device.
- A configured Firebase project.

### Installation

Clone the repository:

```bash
git clone https://github.com/MomenBadr/EarlyEd.git
