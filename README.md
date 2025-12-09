---

## 🚀 Flying Characters

A lightweight Flutter package to create beautiful **flying character animations** (letters, emojis, particles, icons, etc.) floating across the screen.
Perfect for celebratory effects, message animations, reactions, and playful UI moments.

---

## 🎬 GIF Previews

| Fly                                                                                        | FadeBlur                                                                                         | Flip3D                                                                                         | SwirlFloat                                                                                                |
| ------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| ![Fly](https://raw.githubusercontent.com/ASHISH1317/flying_characters/main/assets/fly.gif) | ![FadeBlur](https://raw.githubusercontent.com/ASHISH1317/flying_characters/main/assets/blur.gif) | ![Flip3D](https://raw.githubusercontent.com/ASHISH1317/flying_characters/main/assets/flip.gif) | ![SwirlFloat](https://raw.githubusercontent.com/ASHISH1317/flying_characters/main/assets/swirl_float.gif) |

---

## ✨ Features

* Animate **characters, emojis, icons, or custom widgets**
* Randomized movement for **natural flying effect**
* Configurable **speed, size, duration & spread**
* Multiple animation types: `fly`, `fadeBlur`, `flip3d`, `swirlFloat`
* Works on **any widget** using overlay or inside layout
* Lightweight & easy to integrate

---

## 📦 Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  flying_characters: ^1.0.0
```

Then run:

```bash
flutter pub get
```

---

## 📝 Example Usage

### Basic Flying Text

```dart
import 'package:flutter/material.dart';
import 'package:flying_characters/flying_characters.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Flying Characters Demo")),
        body: Center(
          child: FlyingCharacters(
            text: "🎉 Celebrate Flutter!",
            mode: FlyingCharactersMode.word,
            duration: const Duration(seconds: 2),
            animationType: FlyingAnimationType.fly,
            perItemDelay: const Duration(milliseconds: 50),
            maxStartOffset: 30,
            randomDirections: true,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
```
---

## ⚙️ License

This package is licensed under the **MIT License**.
See [LICENSE](https://github.com/ASHISH1317/flying_characters/blob/main/LICENSE) for details.

---