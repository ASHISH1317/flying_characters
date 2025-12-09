/// A Flutter package to animate individual characters of a string with
/// "flying" effects, customizable directions, offsets, delays, and looping.
///
/// Example usage:
/// ```dart
/// import 'package:flying_characters/flying_characters.dart';
///
/// FlyingCharacters(
///   text: "Hello World!",
///   style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
///   duration: Duration(milliseconds: 800),
///   perItemDelay: Duration(milliseconds: 50),
///   randomDirections: true,
///   maxStartOffset: 40,
///   loop: false,
/// )
/// ```
library;

/// Exposes the main [FlyingCharacters] widget for animating text.
export 'src/flying_characters_widget.dart';
