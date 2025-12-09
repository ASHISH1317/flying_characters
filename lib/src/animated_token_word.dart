import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_characters/flying_characters.dart';
import 'glyph_anim.dart';

/// A widget responsible for rendering a **single token (word)** with animated
/// characters or word-level animations.
///
/// Used internally by [FlyingCharacters].
///
/// Key behavior:
/// - The whole word renders as one layout unit (inside a single WidgetSpan),
///   which keeps wrapping at word boundaries only.
/// - In **character mode**, each character is animated independently
///   via its own [GlyphAnimation].
/// - In **word mode**, the entire word is animated as one block, driven by
///   a single [GlyphAnimation].
class AnimatedTokenWord extends StatelessWidget {
  /// Creates an [AnimatedTokenWord].
  const AnimatedTokenWord({
    super.key,
    required this.tokenText,
    required this.glyphs,
    required this.style,
    required this.animationType,
    required this.mode,
  });

  /// Text of the token (word) from the main string.
  final String tokenText;

  /// Animation definitions for glyphs.
  ///
  /// - Word mode → list typically contains a single [GlyphAnimation].
  /// - Character mode → list contains one per character in [tokenText].
  final List<GlyphAnimation> glyphs;

  /// Styling applied to each rendered character.
  final TextStyle style;

  /// Animation type used to animate this token.
  final FlyingAnimationType animationType;

  /// Whether animation is applied per character or per word.
  final FlyingCharactersMode mode;

  @override
  Widget build(BuildContext context) {
    final chars = tokenText.characters.toList();

    // ------------------------------------------
    // WORD MODE → One animation for entire word
    // ------------------------------------------
    if (mode == FlyingCharactersMode.word) {
      // Use first glyph's animation as the word-level driver.
      final wordAnim =
          glyphs.isNotEmpty ? glyphs.first.animation : kAlwaysCompleteAnimation;

      return AnimatedBuilder(
        animation: wordAnim,
        builder: (_, __) {
          final t = wordAnim.value;

          // Base child: whole word as one Row of characters.
          Widget child = Row(
            mainAxisSize: MainAxisSize.min,
            children: chars.map((c) => Text(c, style: style)).toList(),
          );

          switch (animationType) {
            case FlyingAnimationType.fadeBlur:
              final blur = (1 - t) * 6;
              child = Opacity(
                opacity: t,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: blur,
                    sigmaY: blur,
                  ),
                  child: Transform.translate(
                    offset: Offset(0, (1 - t) * 10),
                    child: child,
                  ),
                ),
              );
              break;

            case FlyingAnimationType.flip3d:
              child = Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY((1 - t) * 1.5)
                  ..rotateX((1 - t) * 0.3),
                alignment: Alignment.center,
                child: Opacity(
                  opacity: t,
                  child: child,
                ),
              );
              break;

            case FlyingAnimationType.swirlFloat:
              final swirl = sin(t * pi) * 10;
              child = Transform.translate(
                offset: Offset(swirl, (1 - t) * -30),
                child: Transform.rotate(
                  angle: (1 - t) * pi / 2,
                  child: Opacity(
                    opacity: t,
                    child: child,
                  ),
                ),
              );
              break;

            case FlyingAnimationType.fly:
              final ga = glyphs.isNotEmpty ? glyphs.first : null;
              final offset = ga != null
                  ? Offset.lerp(ga.initialOffset, Offset.zero, t)!
                  : Offset.zero;
              child = Opacity(
                opacity: t,
                child: Transform.translate(
                  offset: offset,
                  child: child,
                ),
              );
          }

          return child;
        },
      );
    }

    // ------------------------------------------
    // CHARACTER MODE → Animate each character independently
    // ------------------------------------------
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(chars.length, (i) {
        final ga = glyphs.firstWhere(
          (g) => g.charIndex == i,
          orElse: () => GlyphAnimation(
            text: chars[i],
            tokenIndex: -1,
            charIndex: i,
            animation: kAlwaysCompleteAnimation,
            initialOffset: Offset.zero,
          ),
        );

        return AnimatedBuilder(
          animation: ga.animation,
          builder: (_, __) {
            final t = ga.animation.value;
            Widget child = Text(chars[i], style: style);

            switch (animationType) {
              case FlyingAnimationType.fadeBlur:
                final blur = (1 - t) * 6;
                child = Opacity(
                  opacity: t,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: blur,
                      sigmaY: blur,
                    ),
                    child: Transform.translate(
                      offset: Offset(0, (1 - t) * 10),
                      child: child,
                    ),
                  ),
                );
                break;

              case FlyingAnimationType.flip3d:
                child = Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY((1 - t) * 1.5)
                    ..rotateX((1 - t) * 0.3),
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: t,
                    child: child,
                  ),
                );
                break;

              case FlyingAnimationType.swirlFloat:
                final swirl = sin(t * pi) * 10;
                child = Transform.translate(
                  offset: Offset(swirl, (1 - t) * -30),
                  child: Transform.rotate(
                    angle: (1 - t) * pi / 2,
                    child: Opacity(
                      opacity: t,
                      child: child,
                    ),
                  ),
                );
                break;

              case FlyingAnimationType.fly:
                final offset = Offset.lerp(ga.initialOffset, Offset.zero, t)!;
                child = Opacity(
                  opacity: t,
                  child: Transform.translate(
                    offset: offset,
                    child: child,
                  ),
                );
            }

            return child;
          },
        );
      }),
    );
  }
}
