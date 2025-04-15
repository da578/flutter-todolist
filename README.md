# 📋 **Flutter To Do List**

A simple yet powerful to-do list app built with Flutter, designed to help users manage tasks efficiently with features like notifications, task prioritization, and a clean, modern UI.

![Built with Flutter](https://img.shields.io/badge/Built%20in-Flutter-%23369FE7) ![GitHub License](https://img.shields.io/badge/license-Apache%202.0-blue.svg) ![Platform - Android/](https://img.shields.io/badge/platform-Android-green)

## 🌟 **Key Features**
1. **Task Management:**
   - Create, edit, and delete tasks effortlessly.
   - Mark tasks as complete or incomplete.
   - Set task priorities and deadlines.

2. **Notifications & Reminders:**
   - Timely notifications for upcoming task deadlines.
   - Customizable reminders for each task.

3. **Modern Interface:**
   - Responsive design with dynamic themes using **FlexColorScheme**.
   - Smooth animations powered by **Flutter Animate** and **Lottie**.

4. **Local Storage:**
   - Tasks are stored locally using the **Isar** database.
   - Import/export data in CSV and YAML formats.

5. **Intuitive Navigation:**
   - Use **Google Nav Bar** for seamless navigation between main pages.
   - **Liquid Pull to Refresh** feature to refresh the task list.

6. **File Integration & Permissions:**
   - Import task files from your device using **File Picker**.
   - Request file access permissions with **Permission Handler**.

7. **Time Management:**
   - Global timezone support with **Timezone** and **Flutter Timezone**.

8. **Custom App Icons:**
   - Custom launcher icons created with **Flutter Launcher Icons**.

## 📸 **Screenshots**

Here are some screenshots of the ToDoList app:

| Home Screen | Task Detail | Settings |
|-------------|-------------|----------|
| ![Home Screen](https://via.placeholder.com/300x600?text=Home+Screen) | ![Task Detail](https://via.placeholder.com/300x600?text=Task+Detail) | ![Settings](https://via.placeholder.com/300x600?text=Settings) |

*(Replace the placeholders above with actual screenshots of your app.)*

## 🚀 **Installation**

### Prerequisites
- Ensure you have installed [Flutter SDK](https://flutter.dev/docs/get-started/install).
- Install the required dependencies by running:
  ```bash
  flutter pub get
  ```

### Steps
1. **Clone the Repository:**
   ```bash
   git clone https://github.com/dzulkifli578/flutter-todolist.git
   cd todo-list
   ```

2. **Run the App:**
   ```bash
   flutter run
   ```

3. **Build APK:**
   To build an APK for Android:
   ```bash
   flutter build apk
   ```

4. **Build App Bundle:**
   To build an App Bundle for Google Play distribution:
   ```bash
   flutter build appbundle
   ```

## 🔑 **Permissions**

This app requires the following permissions to function properly:
- **Notifications:** For sending task reminders and alerts.
- **Storage Access:** For importing/exporting task files (e.g., CSV or YAML).
- **Exact Alarms:** To schedule precise task reminders.
- **Device Boot Completion:** To restore reminders after device restarts.
- **Vibration:** For tactile feedback when notifications are triggered.

Make sure these permissions are enabled on your device for the best experience.

## 🫱🏼‍🫲🏼 **Contribute**

We welcome contributions from the community! Here's how you can help:
1. Fork the repository.
2. Create a new branch for your feature or bug fix:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "feat: add your feature description"
   ```
4. Push your branch:
   ```bash
   git push origin feature/your-feature-name
   ```
5. Open a pull request (PR) on GitHub.

## 💰 **Donate**

If you find this project useful and would like to support its development, consider donating:

- **Saweria:** [Donate via Saweria](https://saweria.co/da578)
- **Buy Me a Coffee:** [Support on Buy Me a Coffee](https://buymeacoffee.com/da578)

Your support is greatly appreciated and help me maintain and improve the app!

## 🌐 **Social**

Stay connected with me on social media:
- **GitHub:** [@da578](https://github.com/da578)
- **Telegram:** [@da578](https://t.me/dzul578)
- **LinkedIn:** [Dzulkifli Anwar](www.linkedin.com/in/dzulkifli-anwar)

## 📜 **License**

This project is licensed under the **Apache License 2.0**. See the [LICENSE](LICENSE) file for more details.

## 🌟 **Special Thanks**

A big thank you to everyone who has contributed directly or indirectly to the development of this app:
- **Flutter Team:** For the amazing framework.
- **Open Source Community:** For libraries and tools like **Isar**, **Flutter Animate**, and **Lottie**.
- **Users & Testers:** For feedback and suggestions that helped improve the app.