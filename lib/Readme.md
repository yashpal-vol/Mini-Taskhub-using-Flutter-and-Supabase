# Mini TaskHub

A simple task management app built with Flutter and Supabase.

## What is Mini TaskHub?
Mini TaskHub helps you manage your tasks. You can add, edit, delete, and search tasks. It uses Supabase for storing tasks and Flutter for the app interface.

## Concepts Covered
- **UI/UX from Figma**: Designed login and dashboard layouts with a modern look.
- **Login & Dashboard Layout**: Created user-friendly screens for login and task management.
- **Auth (Supabase)**: Handles user login and signup using Supabase authentication.
- **Login/Signup**: Allows users to log in or sign up.
- **State Management**: Uses Provider to manage task list and auth state.
- **Task List, Auth State**: Displays tasks and tracks user login status.
- **DB (Supabase)**: Stores and fetches tasks using Supabase database.
- **Navigation**: Moves between login, signup, and dashboard with authenticated routes.
- **Async Programming**: Handles Supabase calls asynchronously.
- **OOP & Functional**: Implements task model and service classes.
- **Responsive Design**: Ensures dashboard layout works on different screens.
- **Animations**: Adds subtle fade and slide transitions.
- **Extensions/Generics**: Optional (e.g., could use validators if expanded).
- **Tests**: Includes one test for Task model serialization (to be added).
- **Custom Widgets/Themes**: Uses reusable TaskTile widget with custom colors (teal theme).
- **Hot Reload vs Restart**: Explained below.
- **REST & JSON**: Uses Supabase client SDK for RESTful API and JSON data.

## Hot Reload vs Restart
- **Hot Reload**: It updates the app quickly with your changes (e.g., new task names) without losing data like your task list.[ Press `r` in the terminal while the app runs.]
- **Hot Restart**: It rebuilds the app from scratch, reloading all data (e.g., tasks from Supabase), which takes a bit longer but ensures a fresh start.[Press `R` in the terminal. ]

## How to Set Up
1. **Get the Code**:
   - Copy this repo: `git clone https://github.com/yashpal-vol/Mini-Taskhub-using-Flutter-and-Supabase/tree/main/lib`
   - Go to the project folder: `mini-taskhub`

2. **Install Tools**:
   - Install Flutter: Follow [Flutter setup](https://flutter.dev/docs/get-started/install).
   - Install an editor like Visual Studio Code.

3. **Get Packages**:
   - Run `flutter pub get` in the terminal to install needed files.

4. **Set Up Supabase**:
   - Make a Supabase account at https://supabase.com.
   - Get your Supabase URL and anon key from your project settings.
   - In `main.dart`, add your URL and key like this:
    
     await Supabase.initialize(
       url: 'YOUR_SUPABASE_URL',
       anonKey: 'YOUR_ANON_KEY',
     );