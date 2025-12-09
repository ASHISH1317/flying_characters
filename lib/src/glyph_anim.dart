import 'package:flutter/material.dart';

/// Represents the animation data for a single character ("glyph") in [FlyingCharacters].
///
/// Each glyph has its text, an animation controlling its motion and opacity,
/// an initial offset from which it will "fly in", and its index in the token list.
class GlyphAnimation {
  /// Creates a [GlyphAnimation] instance.
  ///
  /// [text] is the character to animate.
  /// [animation] is the [Animation<double>] controlling its movement and opacity.
  /// [initialOffset] is the starting offset from the final position.
  /// [tokenIndex] is the index of this character in the text token list.
  GlyphAnimation({
    required this.text,
    required this.animation,
    required this.initialOffset,
    required this.tokenIndex,
  });

  /// The character text for this glyph.
  final String text;

  /// Animation controlling the movement and opacity of the glyph.
  final Animation<double> animation;

  /// Starting offset from the final position.
  final Offset initialOffset;

  /// Index of this character in the token list of [FlyingCharacters].
  final int tokenIndex;
}
