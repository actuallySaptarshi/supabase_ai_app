# Supabase AI Chat Part 1 (Frontend)

<p align="center">
<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
<img src="https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white" alt="Supabase" />
<img src="https://img.shields.io/badge/dart-blue?style=for-the-badge&logo=dart&logoSize=auto" alt="Dart" />
</p>

A Gemini-like AI chat application built with Flutter for the frontend and Supabase for backend-as-a-service (Authentication & Storage). This application communicates with a custom Python backend (Flask/FastAPI) powered by LangChain to handle AI processing and response generation.

Note: This repository contains Part 1 (Frontend) of the project.
The backend server (Part 2) handling the backend logic wll be uploaded soon.

## 🌟 Features

✅ **Authentication:** Secure Email/Password and Social Login via Supabase Auth.

✅ **Real-time Chat UI:** Smooth, responsive chat interface similar to Google Gemini.

✅ **Chat History:** Persist chat sessions and messages using Supabase Database.

✅ **Markdown Support:** Renders AI responses including code blocks and formatted text.

✅ **Cross-Platform:** Runs on Android, iOS, Web, and Desktop.

## 📸 Screenshots

<p align="center">
<img width="150" height="321" alt="login" src="https://github.com/user-attachments/assets/19829db4-7791-4d8a-973e-2ada6fae9ebb" />
<img width="150" height="321" alt="chat_history" src="https://github.com/user-attachments/assets/27fd3015-699a-4a0b-8b37-6123ae568bf1" />
<img width="150" height="321" alt="account_settings" src="https://github.com/user-attachments/assets/d2d0fa78-5254-4b16-8b8d-e0d75a06888e" />
<img width="150" height="321" alt="Screenshot 2025-11-24 120203" src="https://github.com/user-attachments/assets/487cedf4-6632-449b-8f26-37b58ae031f7" />
</p>

## 🏗️ Architecture

### This project follows a split-stack architecture:

- Frontend (This Repo): Built with Flutter.

- Handles UI, User Input, and Display.

- Directly communicates with Supabase for Auth and History retrieval.

- Sends prompts to the Python Backend.

- Backend (Supabase)

- Auth: Manages users.

- Database: Stores chats and messages.

- AI Backend (Part 2):

- Python (Flask/FastAPI).

- LangChain for LLM orchestration.

## 🛠️ Tech Stack

- **Framework:** Flutter

- **Language:** Dart

- **Backend:** Supabase + Python Middleware

- **AI Integration:** Supabase Webhooks to connect to Flask/Fastapi Middleware

## 🚀 Getting Started

### Prerequisites

Flutter SDK installed.

1. **Clone the Repository**

        git clone https://github.com/actuallySaptarshi/supabase_ai_app

        cd supabase_ai_app


2. **Install Dependencies**

        flutter pub get

3. **Environment Configuration**

    Change these vars to your supabase url and anonkey in `lib/main.dart`:

        await Supabase.initialize(
            url: 'https://YOUR_SUPABASE_URL',
            anonKey:
                'YOUR_SUPABASE_ANON_KEY',
        );

4. **Supabase Setup**

    Supabase, along with middleware Setup will be shared in the **Part-2** of this project.

5. **Run the App**

    For debug mode
            
        flutter run

### 🤝 Contributing

Contributions are welcome!

Fork the Project

Create your Feature Branch (git checkout -b feature/AmazingFeature)

Commit your Changes (git commit -m 'Add some AmazingFeature')

Push to the Branch (git push origin feature/AmazingFeature)

Open a Pull Request

### 📄 License

Distributed under the MIT License. See LICENSE for more information.

<p align="center">
Follow me @ <a href="https://www.google.com/search?q=https://github.com/actuallySaptarshi">actuallySaptarshi</a>
</p>
