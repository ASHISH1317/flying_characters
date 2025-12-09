import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flying_characters/src/animated_token_word.dart';
import 'package:flying_characters/src/flying_animation_type.dart';
import 'package:flying_characters/src/flying_characters_mode.dart';
import 'package:flying_characters/src/text_utils.dart';
import 'glyph_anim.dart';
import 'token_model.dart';

/// A widget that animates text with "flying" effects while preserving
/// normal word wrapping.
///
/// Key behavior:
/// - Layout is always word-based: each word is a single inline unit,
///   so Flutter will never break inside a word when wrapping.
/// - Animation can be at word level or character level:
///   - [FlyingCharactersMode.word]: whole words fly in as units.
///   - [FlyingCharactersMode.character]: each character inside a word
///     has its own animation, but the *word* stays unbroken.
///
/// Example:
/// ```
/// FlyingCharacters(
///   text: "Hello Flutter Animations!",
///   mode: FlyingCharactersMode.character,
///   style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
///   duration: const Duration(milliseconds: 700),
///   perItemDelay: const Duration(milliseconds: 40),
///   randomDirections: true,
///   maxStartOffset: 32,
///   loop: false,
/// )
/// ```
class FlyingCharacters extends StatefulWidget {
  /// Creates a [FlyingCharacters] widget.
  const FlyingCharacters({
    super.key,
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 700),
    this.perItemDelay = const Duration(milliseconds: 40),
    this.curve = Curves.easeOutCubic,
    this.randomDirections = true,
    this.maxStartOffset = 32,
    this.loop = false,
    this.startDelay,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.textScaleFactor,
    this.maxLines,
    this.overflow = TextOverflow.visible,
    this.randomSeed = 7,
    this.mode = FlyingCharactersMode.word,
    this.animationType = FlyingAnimationType.fly,
  });

  /// The text to animate.
  final String text;

  /// Animation granularity:
  /// - [FlyingCharactersMode.word]: one animation per word.
  /// - [FlyingCharactersMode.character]: one animation per character.
  final FlyingCharactersMode mode;

  /// Optional [TextStyle] for the text.
  final TextStyle? style;

  /// Duration for each token (word/character) animation.
  final Duration duration;

  /// Delay between each token's animation start.
  final Duration perItemDelay;

  /// Animation curve for each token's movement.
  final Curve curve;

  /// Whether each token should move in random directions.
  final bool randomDirections;

  /// Maximum starting offset for each token.
  final double maxStartOffset;

  /// If true, the animation will loop back and forth continuously.
  final bool loop;

  /// Optional delay before starting the animation.
  final Duration? startDelay;

  /// Text alignment for the underlying [RichText].
  final TextAlign textAlign;

  /// Optional explicit text direction.
  final TextDirection? textDirection;

  /// Optional text scale factor.
  final double? textScaleFactor;

  /// Maximum number of lines for the text.
  final int? maxLines;

  /// Overflow behavior for the text.
  final TextOverflow overflow;

  /// Random seed for deterministic randomization.
  final int randomSeed;

  /// Visual style for each glyph's animation.
  final FlyingAnimationType animationType;

  @override
  State<FlyingCharacters> createState() => _FlyingCharactersState();
}

class _FlyingCharactersState extends State<FlyingCharacters>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  /// Word + separator tokens used for layout.
  ///
  /// These are always word tokens, even in character mode, so that
  /// wrapping decisions are made only between words, not inside them.
  late List<Token> _tokens;

  /// All glyph-level animations (word or character).
  ///
  /// In word mode: one entry per animated word.
  /// In character mode: one entry per animated character inside each word.
  late List<GlyphAnimation> _items;

  @override
  void initState() {
    super.initState();

    // Always tokenize as words for layout.
    _tokens = TextTokenizer.tokenize(
      widget.text,
      mode: FlyingCharactersMode.word,
    );

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration + _totalStagger(_animatedCount()),
    );

    _items = _buildAnimations();

    if (widget.startDelay != null) {
      Future.delayed(widget.startDelay!, _start);
    } else {
      _start();
    }

    if (widget.loop) {
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) _controller.reverse();
        if (status == AnimationStatus.dismissed) _controller.forward();
      });
    }
  }

  /// Total stagger delay for [count] animated units.
  Duration _totalStagger(int count) =>
      count == 0 ? Duration.zero : widget.perItemDelay * (count - 1);

  /// Number of word tokens that are marked as animatable.
  int _animatedCount() => _tokens.where((t) => t.animate).length;

  void _start() => _controller.forward(from: 0);

  /// Builds all glyph animations, depending on [widget.mode].
  ///
  /// - In word mode: one [GlyphAnimation] per word.
  /// - In character mode: one [GlyphAnimation] per character in each word.
  List<GlyphAnimation> _buildAnimations() {
    final random = Random(widget.randomSeed);
    final List<GlyphAnimation> result = [];

    // Build logical "units" to animate.
    // Word mode: units = words.
    // Character mode: units = characters inside words.
    final List<({int tokenIndex, int charIndex, String text})> units = [];

    for (int ti = 0; ti < _tokens.length; ti++) {
      final token = _tokens[ti];
      if (!token.animate) continue;

      if (widget.mode == FlyingCharactersMode.word) {
        units.add((tokenIndex: ti, charIndex: 0, text: token.text));
      } else {
        final chars = token.text.characters.toList();
        for (int ci = 0; ci < chars.length; ci++) {
          units.add((tokenIndex: ti, charIndex: ci, text: chars[ci]));
        }
      }
    }

    final total = units.length;
    if (total == 0) return result;

    final fullMs = widget.duration.inMilliseconds +
        widget.perItemDelay.inMilliseconds * (total - 1);

    for (int index = 0; index < total; index++) {
      final unit = units[index];
      final startMs = index * widget.perItemDelay.inMilliseconds;
      final begin = startMs / fullMs;
      final end = (startMs + widget.duration.inMilliseconds) / fullMs;

      final anim = CurvedAnimation(
        parent: _controller,
        curve: Interval(begin, end, curve: widget.curve),
      );

      final angle = random.nextDouble() * 2 * pi;
      final radius = random.nextDouble() * widget.maxStartOffset;

      final initialOffset = widget.randomDirections
          ? Offset(cos(angle) * radius, sin(angle) * radius)
          : Offset(radius, radius);

      result.add(
        GlyphAnimation(
          text: unit.text,
          tokenIndex: unit.tokenIndex,
          charIndex: unit.charIndex,
          animation: anim,
          initialOffset: initialOffset,
        ),
      );
    }

    return result;
  }

  @override
  void didUpdateWidget(covariant FlyingCharacters oldWidget) {
    super.didUpdateWidget(oldWidget);

    final bool needRebuild = oldWidget.text != widget.text ||
        oldWidget.duration != widget.duration ||
        oldWidget.randomSeed != widget.randomSeed ||
        oldWidget.maxStartOffset != widget.maxStartOffset ||
        oldWidget.mode != widget.mode;

    if (needRebuild) {
      _tokens = TextTokenizer.tokenize(
        widget.text,
        mode: FlyingCharactersMode.word,
      );
      _controller.duration = widget.duration + _totalStagger(_animatedCount());
      _items = _buildAnimations();
      _start();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context).style;
    final style = defaultStyle.merge(widget.style);

    // Group glyph animations by token index (word index).
    final Map<int, List<GlyphAnimation>> byToken = {};
    for (final ga in _items) {
      byToken.putIfAbsent(ga.tokenIndex, () => []).add(ga);
    }

    // Ensure glyphs for each token are ordered by character index.
    for (final list in byToken.values) {
      list.sort((a, b) => a.charIndex.compareTo(b.charIndex));
    }

    return RichText(
      maxLines: widget.maxLines,
      textAlign: widget.textAlign,
      overflow: widget.overflow,
      textScaler: widget.textScaleFactor != null
          ? TextScaler.linear(widget.textScaleFactor!)
          : MediaQuery.textScalerOf(context),
      text: TextSpan(
        style: style.copyWith(fontSize: style.fontSize ?? 18),
        children: List.generate(
          _tokens.length,
          (tokenIndex) {
            final token = _tokens[tokenIndex];
            final glyphs = byToken[tokenIndex];

            // Non-animated tokens (spaces, punctuation, etc.) are plain spans.
            if (!token.animate || glyphs == null || glyphs.isEmpty) {
              return TextSpan(text: token.text);
            }

            // Animated token: wrap in a single WidgetSpan so the whole word is
            // treated as one unbreakable layout unit by RichText.[web:13][web:38]
            return WidgetSpan(
              baseline: TextBaseline.alphabetic,
              alignment: PlaceholderAlignment.baseline,
              child: AnimatedTokenWord(
                tokenText: token.text,
                glyphs: glyphs,
                style: style,
                animationType: widget.animationType,
                mode: widget.mode,
              ),
            );
          },
        ),
      ),
    );
  }
}
