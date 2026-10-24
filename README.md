# LingoLearn – Language Learning App

Flutter + Firebase language learning app built for the **CodeAlpha App Development Internship (Task 4)**.

## Features
- Email/password authentication (Firebase Auth)
- Learn Spanish, French or German (app UI in English)
- Categories: Vocabulary, Phrases, Grammar
- Daily "Lesson of the day"
- Flip flashcards with translation, pronunciation guide and example sentences
- Text-to-speech audio pronunciation
- Multiple-choice quizzes with scoring and XP
- Streaks, levels, daily goal and 7-day activity chart
- Realtime cloud sync with Cloud Firestore (offline cache enabled)

## Tech stack
Flutter · Dart · Provider · Firebase Auth · Cloud Firestore · flutter_tts · google_fonts

## Project structure
```
lib/
├── core/        theme, constants, validators, date utils
├── data/        learning content
├── models/      Language, Lesson, StudyItem, QuizQuestion, UserProfile
├── providers/   AuthProvider, ProgressProvider
├── screens/     all app screens
├── services/    auth, firestore, tts, quiz generator
└── widgets/     reusable UI components
```

## Run locally
```bash
git clone https://github.com/YOUR_USERNAME/CodeAlpha_LanguageLearningApp.git
cd CodeAlpha_LanguageLearningApp
flutter pub get
flutter run
```
To use your own Firebase project: `flutterfire configure`, enable Email/Password
auth, create Firestore and publish `firestore.rules`.

## Tests
```bash
flutter test
```

## Firestore data model
```
users/{uid}                  name, email, languageCode, xp, streak, lastStudyDate, completedLessons[]
users/{uid}/activity/{day}   date, xp
users/{uid}/quizResults/{id} lessonId, score, total, createdAt
```