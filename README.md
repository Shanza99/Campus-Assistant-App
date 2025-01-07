# Campus Assistant App

This is a Flutter app integrated with Firebase authentication. It allows users to sign up, log in, and access a dashboard with different features like viewing class schedules, event notifications, assignments, feedback systems, and more.

## Features Implemented

1. **Firebase Authentication**:
   - Users can sign up with an email and password.
   - Users can log in with their credentials.
   - Authentication state is managed using Firebase Auth.
   
2. **Dashboard**:
   - After logging in, the user is redirected to the Dashboard screen, which shows multiple options such as:
     - Events
     - Assignments
     - Class Schedule
     - Feedback
     - Study Group
     - Settings
   - Each option navigates to a different screen, providing a distinct functionality.

3. **Image Slider**:
   - A carousel slider is included in the dashboard with auto-play functionality and a white background. The images automatically transition every 3 seconds.
   - You can replace the placeholder images with actual images.

4. **Logout**:
   - Users can sign out from the app, which will redirect them back to the login screen.

## Screens in the App

1. **Authentication Screen**:
   - Users can enter their email and password to sign up or log in.

2. **Dashboard Screen**:
   - The main screen users see after logging in, showing options like events, assignments, etc.
   - Includes an image carousel slider with auto-play.
   
3. **Various Feature Screens**:
   - Screens like Event Notifications, Assignment Tracker, Class Schedule, Feedback System, and Study Group.
     
## UI
<div style="display: flex; flex-wrap: wrap; justify-content: space-around;">
  <img src="https://github.com/user-attachments/assets/ca376e80-3ed3-4624-94e2-f483a7bdb1c5" alt="Image 1" style="width: 300px; height: 500px; object-fit: cover; margin: 10px;">
  <img src="https://github.com/user-attachments/assets/4a488630-2faf-4920-bab9-22e4035aab41" alt="Image 2" style="width: 300px; height: 500px; object-fit: cover; margin: 10px;">
  <img src="https://github.com/user-attachments/assets/97cf3d36-c7a9-4bba-89c8-635c7ec75a12" alt="Image 3" style="width: 300px; height: 500px; object-fit: cover; margin: 10px;">
  <img src="https://github.com/user-attachments/assets/57f9b75e-66f3-4bc2-855e-b1df9f0b67a8" alt="Image 4" style="width: 300px; height: 500px; object-fit: cover; margin: 10px;">
  <img src="https://github.com/user-attachments/assets/37f6a268-d995-4cb3-abd6-940c5c3ab987" alt="Image 5" style="width: 300px; height: 500px; object-fit: cover; margin: 10px;">
  <img src="https://github.com/user-attachments/assets/94ae229b-0b0d-4bae-a18b-54dbf5855552" alt="Image 6" style="width: 300px; height: 500px; object-fit: cover; margin: 10px;">
  <img src="https://github.com/user-attachments/assets/04168650-876b-4c29-958e-44b3c88f580a" alt="Image 7" style="width: 300px; height: 500px; object-fit: cover; margin: 10px;">
  <img src="https://github.com/user-attachments/assets/2f4c934a-0673-4887-bd07-ad0d46847e44" alt="Image 8" style="width: 300px; height: 500px; object-fit: cover; margin: 10px;">
  <img src="https://github.com/user-attachments/assets/3fa96df7-29f7-4c09-aa38-b63d82725c8f" alt="Image 9" style="width: 300px; height: 500px; object-fit: cover; margin: 10px;">
  <img src="https://github.com/user-attachments/assets/e6484c47-d178-4a50-b74d-0793498c1929" alt="Image 10" style="width: 300px; height: 500px; object-fit: cover; margin: 10px;">
</div>








## How to Use the App


https://github.com/user-attachments/assets/6f395558-1135-4dfa-b3be-28c74fcfb77c

## How to Use the Project

### Prerequisites

Before running the app, ensure you have the following:

- **Flutter SDK** installed on your machine. If you don't have it, follow the installation instructions from [Flutter's official website](https://flutter.dev/docs/get-started/install).
- **Firebase Account**:
  - Create a Firebase project in the Firebase Console.
  - Add Firebase Authentication to your project (email/password authentication).
  - Set up Firebase for your Flutter app using the `firebase_core` and `firebase_auth` packages.
  - Make sure to configure your `google-services.json` for Android and `GoogleService-Info.plist` for iOS.
 Here's the remaining `README.md` section for you to copy:

```markdown
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Set up Firebase:
   - Follow Firebase documentation to set up Firebase with Flutter.
   - Update your `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS).

4. Run the app:
   ```bash
   flutter run
   ```

### Usage

1. **Sign Up**:
   - Open the app and go to the sign-up screen.
   - Enter a valid email and password and tap "Sign Up".
   - If successful, you'll be redirected to the dashboard.

2. **Login**:
   - On the login screen, enter your email and password.
   - If the credentials are correct, you will be logged in and redirected to the dashboard.

3. **Dashboard**:
   - After logging in, you'll see various sections on the dashboard:
     - **Events**: Navigate to event notifications.
     - **Assignments**: Track assignments.
     - **Class Schedule**: View the class schedule.
     - **Feedback**: Give feedback.
     - **Study Group**: Join a study group.
     - **Settings**: Access settings (currently empty).
   
4. **Logout**:
   - Tap on the logout icon in the top-right corner of the dashboard to sign out.

## Dependencies

The app uses the following dependencies:

- `firebase_core`: To initialize Firebase in the app.
- `firebase_auth`: To handle Firebase authentication (sign up, log in, etc.).
- `carousel_slider`: For the auto-play image carousel.

You can add these dependencies to your `pubspec.yaml` file like this:

```yaml
dependencies:
  firebase_core: ^2.4.0
  firebase_auth: ^4.3.0
  carousel_slider: ^4.0.0
```

## Folder Structure

- `lib/`: Contains all the Dart files for the app.
  - `main.dart`: Entry point of the app.
  - `auth_screen.dart`: Screen for signing up and logging in.
  - `dashboard_screen.dart`: The dashboard after login.
  - `event.dart`, `assignment.dart`, `feedback.dart`, etc.: Additional feature screens.
- `firebase_options.dart`: Firebase configuration options.

## Future Improvements

- Add a feature to allow users to update their profile information.
- Implement push notifications for event reminders.
- Add a database to store and manage user data like events and assignments.
- Improve UI/UX for better user experience.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Special Thanks

This project was developed with the assistance of ChatGPT from OpenAI. For more information and help with app development, visit [OpenAI's website](https://openai.com).
```

This is included to give a "Special Thanks" for the help provided by ChatGPT.
