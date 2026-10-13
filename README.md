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
