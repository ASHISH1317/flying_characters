import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flying_characters/src/flying_characters_mode.dart';
import 'package:flying_characters/src/text_utils.dart';
import 'glyph_anim.dart';
import 'token_model.dart';

/// A widget that animates text with "flying" effects.
///
/// Each token (word or character, based on [mode]) can move from a random
/// offset toward its final position, optionally looping or using random directions.
/// You can configure timing, curves, text style, per-token delays, and more.
///
/// Example:
/// ```dart
/// FlyingCharacters(
///   text: "Hello Flutter!",
///   mode: FlyingCharactersMode.character,
///   style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
///   duration: Duration(milliseconds: 700),
///   perItemDelay: Duration(milliseconds: 40),
///   randomDirections: true,
///   maxStartOffset: 32,
///   loop: false,
/// )
/// ```
class FlyingCharacters extends StatefulWidget {
  /// Creates a [FlyingCharacters] widget.
  const FlyingCharacters({
    required this.text,
    super.key,
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
  });

  /// The text to animate.
  final String text;

  /// Animation granularity: word-level or character-level.
  final FlyingCharactersMode mode;

  /// Optional [TextStyle] for the text.
  final TextStyle? style;

  /// Duration for each token animation.
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

  /// Text alignment for the RichText.
  final TextAlign textAlign;

  /// Optional text direction.
  final TextDirection? textDirection;

  /// Optional text scale factor.
  final double? textScaleFactor;

  /// Maximum number of lines for the text.
  final int? maxLines;

  /// Overflow behavior for the text.
  final TextOverflow overflow;

  /// Random seed for deterministic randomization.
  final int randomSeed;

  @override
  State<FlyingCharacters> createState() => _FlyingCharactersState();
}

class _FlyingCharactersState extends State<FlyingCharacters>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Token> _tokens;
  late List<GlyphAnimation> _items;

  @override
  void initState() {
    super.initState();

    _tokens = _tokenizeText(widget.text, widget.mode);
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

  /// Tokenizes text based on [mode].
  List<Token> _tokenizeText(String text, FlyingCharactersMode mode) {
    switch (mode) {
      case FlyingCharactersMode.character:
        // Every character is animated
        return text.characters
            .map((c) => Token(text: c, animate: c.trim().isNotEmpty))
            .toList();
      case FlyingCharactersMode.word:
        return TextTokenizer.tokenize(text);
    }
  }

  Duration _totalStagger(int count) =>
      count == 0 ? Duration.zero : widget.perItemDelay * (count - 1);

  int _animatedCount() => _tokens.where((t) => t.animate).length;

  void _start() => _controller.forward(from: 0);

  List<GlyphAnimation> _buildAnimations() {
    final random = Random(widget.randomSeed);
    final animatedIndices = List<int>.generate(
      _tokens.length,
      (i) => i,
    ).where((i) => _tokens[i].animate).toList();

    final total = animatedIndices.length;
    final fullMs =
        widget.duration.inMilliseconds +
        widget.perItemDelay.inMilliseconds * (total - 1);

    return List.generate(total, (index) {
      final startMs = index * widget.perItemDelay.inMilliseconds;
      final begin = startMs / fullMs;
      final end = (startMs + widget.duration.inMilliseconds) / fullMs;

      final anim = CurvedAnimation(
        parent: _controller,
        curve: Interval(begin, end, curve: widget.curve),
      );

      final angle = random.nextDouble() * 2 * pi;
      final radius = random.nextDouble() * widget.maxStartOffset;

      return GlyphAnimation(
        text: _tokens[animatedIndices[index]].text,
        tokenIndex: animatedIndices[index],
        animation: anim,
        initialOffset: widget.randomDirections
            ? Offset(cos(angle) * radius, sin(angle) * radius)
            : Offset(radius, radius),
      );
    });
  }

  @override
  void didUpdateWidget(covariant FlyingCharacters oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool needRebuild =
        oldWidget.text != widget.text ||
        oldWidget.duration != widget.duration ||
        oldWidget.randomSeed != widget.randomSeed ||
        oldWidget.maxStartOffset != widget.maxStartOffset ||
        oldWidget.mode != widget.mode;

    if (needRebuild) {
      _tokens = _tokenizeText(widget.text, widget.mode);
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
    final style = DefaultTextStyle.of(context).style.merge(widget.style);
    final animMap = {for (var a in _items) a.tokenIndex: a};

    return RichText(
      maxLines: widget.maxLines,
      textAlign: widget.textAlign,
      overflow: widget.overflow,
      text: TextSpan(
        style: style.copyWith(fontSize: style.fontSize ?? 18),
        children: _tokens.map((token) {
          final anim = animMap[_tokens.indexOf(token)];
          if (!token.animate || anim == null) {
            return TextSpan(text: token.text);
          }

          return WidgetSpan(
            baseline: TextBaseline.alphabetic,
            alignment: PlaceholderAlignment.baseline,
            child: AnimatedBuilder(
              animation: anim.animation,
              builder: (_, __) {
                final t = anim.animation.value;
                final offset = Offset.lerp(anim.initialOffset, Offset.zero, t)!;

                return Opacity(
                  opacity: t,
                  child: Transform.translate(
                    offset: offset,
                    child: Text(
                      anim.text,
                      style: style,
                      textScaler: TextScaler.linear(
                        widget.textScaleFactor ?? 1,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
