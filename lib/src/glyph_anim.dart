import 'package:flutter/material.dart';

class GlyphAnimation {
  GlyphAnimation({
    required this.text,
    required this.animation,
    required this.initialOffset,
    required this.tokenIndex,
  });

  final String text;
  final Animation<double> animation;
  final Offset initialOffset;
  final int tokenIndex;
}
