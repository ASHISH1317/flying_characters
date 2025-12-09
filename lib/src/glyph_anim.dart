import 'package:flutter/material.dart';

/// Represents the animation data for a single glyph (word or character)
/// in [FlyingCharacters].
///
/// - [text] is the visible glyph (word or character).
/// - [animation] drives the transition from initial offset/opacity to final.
/// - [initialOffset] is the starting offset from the final position.
/// - [tokenIndex] is the index of the parent token (word) in the token list.
/// - [charIndex] is the index inside the word, used for character mode.
class GlyphAnimation {
  GlyphAnimation({
    required this.text,
    required this.animation,
    required this.initialOffset,
    required this.tokenIndex,
    required this.charIndex,
  });

  /// The glyph text (word or character).
  final String text;

  /// Animation controlling the movement and opacity.
  final Animation<double> animation;

  /// Starting offset from the final position.
  final Offset initialOffset;

  /// Index of the parent token (word) in the token list.
  final int tokenIndex;

  /// Index of this glyph inside the word.
  final int charIndex;
}
