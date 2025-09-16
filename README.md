# Users Hub

Users Hub is a Flutter mobile application designed to manage users, display profiles, and provide app functionalities with offline support and push notifications.

---

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Firebase Setup](#firebase-setup)
- [Connectivity Handling](#connectivity-handling)
- [Push Notifications](#push-notifications)
- [Bottom Navigation](#bottom-navigation)
- [App Customization](#app-customization)
- [Localization](#localization)
- [Build & Run](#build--run)

---

## Features

- User Management and Profiles
- Offline handling with `NoNetworkScreen`
- Bottom Navigation for main app screens
- Push notifications using Firebase Cloud Messaging (FCM)
- Responsive UI
- Localization (English + Hindi)
- App customization: launcher icon and app name

---

## Installation

1. Clone the repository:


git clone https://github.com/arunjoshuaa/users_hub.git

2. Navigate to the project directory:

cd users_hub

3. Install dependencies:

flutter pub get

### Firebase Setup

1. Go to Firebase Console

2. Create a new project.

3. Add an Android app with your package name (com.example.users_hub).

4. Download google-services.json and place it in android/app/.

5. Add Firebase SDK dependencies in app/build.gradle.kts:

    implementation(platform("com.google.firebase:firebase-bom:34.0.0"))
    implementation("com.google.firebase:firebase-messaging")
    implementation("com.google.firebase:firebase-analytics")

6. Apply the Google Services plugin:

plugins {
    id("com.google.gms.google-services")
}

### Connectivity Handling

The app uses GlobalConnectivityService to monitor internet connectivity.

Pages inside the Bottom Navigation Bar show the NoNetworkScreen in the body when offline.

Pages outside Bottom Navigation automatically push NoNetworkScreen when offline.

Coming online automatically pops the NoNetworkScreen.


### Push Notifications

FCM is integrated.

Notifications are received even when the app is in the background.

Tapping a notification can navigate to a specific screen.

### Build & Run

Run the app on a real device:

flutter run


For release mode:

flutter build apk --release

### Notes

Make sure to grant Internet Permission in AndroidManifest.xml for release builds:

  <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    <uses-permission android:name="android.permission.WAKE_LOCK"/>
    <uses-permission android:name="com.google.android.c2dm.permission.RECEIVE"/>

    <!-- Optional (for showing notifications in background) -->
    <uses-permission
        android:name="android.permission.POST_NOTIFICATIONS"
        tools:targetApi="33" />