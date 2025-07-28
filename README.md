# Firestore Service API

## Why This Package?

While there are official Firebase SDKs for Dart (like `cloud_firestore`), they are primarily designed for Flutter applications and often come with platform-specific dependencies (Android/iOS). This `firestore_service_api` package offers a lightweight, platform-independent solution for interacting with Firestore, making it ideal for:

*   **Dart Backend Applications:** When you need to access Firestore from a server-side Dart application (e.g., using Dart Frog, Shelf, or custom server setups) where Flutter dependencies are unnecessary or problematic.
*   **Command-Line Tools:** For building CLI tools in Dart that need to read from or write to Firestore.
*   **Cross-Platform Dart Projects (Non-Flutter):** If you're building a pure Dart library or application that needs Firestore access without tying into the Flutter ecosystem.
*   **Learning and Experimentation:** Provides a straightforward way to understand and interact with the Firestore REST API directly.
*   **Situations with Restricted Environments:** In environments where using the full Firebase SDK might be complex or restricted, a direct REST API client can be simpler to integrate.

**Key Advantages:**

*   **No Flutter Dependency:** Runs in pure Dart environments.
*   **Direct REST API Access:** Offers fine-grained control and understanding of the underlying API calls.
*   **Lightweight:** Fewer dependencies compared to the full Firebase SDK.
*   **Simpler for Basic CRUD:** If your needs are primarily basic document manipulation, this package can be less complex to set up and use than the full SDK.

This package acts as a Dart wrapper around the [Firestore REST API](https://firebase.google.com/docs/firestore/reference/rest), providing convenient methods for common operations.

A Dart package for interacting with Google Cloud Firestore using the REST API. This package provides a convenient way to perform CRUD (Create, Read, Update, Delete) operations on Firestore documents.

## Features

*   Initialize Firestore service with your project ID.
*   Add documents with various data types (string, boolean, integer, double, array, bytes, geoPoint, map, null, reference, timestamp).
*   Retrieve documents using both high-level repository methods and low-level Firestore API calls.
*   Delete documents.
*   Helper function to convert Firestore document data to JSON.

## Getting started

1.  **Add dependency:**

Add `firestore_service_api` to your `pubspec.yaml` file:

2. **Use provided example as a starting point:**

[Example](example/lib/example.dart)
