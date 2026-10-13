# Unburden

Unburden is a Flutter app that helps children and teens deal with bullying. It offers a safe place to talk, write, learn and calm down, and it alerts a guardian when a message suggests the child may be at risk.

## Features

- **Ray, the support chatbot**: a supportive companion built on Groq (Llama 3.1). It suggests in-app tools when they fit.
- **Safety alerts**: chat messages and journal entries are checked for signs of self-harm, harm to others or violence. A guardian is emailed when something is flagged.
- **Journal**: private entries stored locally with Hive, with mood tracking and voice input.
- **Information module**: articles on what bullying is, its types, signs, why people bully, and how to help a friend.
- **Questionnaire**: a short check-in that gives a result on whether things are okay, bullying or serious.
- **Daily challenge and journey**: a slot-machine style daily challenge with progress tracking.
- **Calm-down tools**: guided meditation audio, a memory flip game, a jigsaw puzzle and a coloring book.
- **SOS**: quick access to helplines.
- **Authentication**: email, Google and Apple sign-in with Firebase.

## Tech stack

Flutter (Dart), Firebase (Auth, Firestore), Hive, Groq, `mailer`, `just_audio`, `speech_to_text`.

## Getting started

1. Install [Flutter](https://docs.flutter.dev/get-started/install) (Dart SDK `^3.5.4`).
2. Clone the repository and fetch dependencies:

   ```bash
   flutter pub get
   ```

3. Create your secrets file. It is gitignored and must never be committed:

   ```bash
   cp lib/secrets.example.dart lib/secrets.dart
   ```

   Then fill in `lib/secrets.dart`:

   | Field | Description |
   | --- | --- |
   | `groqApiKey` | API key from [Groq](https://console.groq.com) |
   | `smtpUsername` | Gmail address used to send guardian emails |
   | `smtpPassword` | Gmail [app password](https://support.google.com/accounts/answer/185833) for that account |

4. Add your own Firebase configuration (`android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`, `lib/firebase_options.dart`), for example with `flutterfire configure`.
5. Run the app:

   ```bash
   flutter run
   ```

## Project structure

```
lib/
  Authentication/    sign in, register, personal details
  ChatBot/           Ray chatbot
  Home/              home, daily challenge, games, meditation, questionnaire, SOS
  Information Module/ educational articles
  Journal/           journal list, entry, reading
  Profile/           profile, about, contact
  utils/             safety checks and alert dialogs
  secrets.dart       local API keys (gitignored)
```

## Disclaimer

Unburden is a support tool, not a substitute for professional help. If someone is in danger, contact local emergency services or a trusted adult.
