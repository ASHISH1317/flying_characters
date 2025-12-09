/// Represents a single piece of text (a token) for animation purposes.
///
/// A token can either be a "word" (which will animate) or a non-word sequence
/// such as spaces, punctuation, or symbols (which will not animate).
class Token {
  /// Creates a [Token] instance.
  ///
  /// [text] is the string content of the token.
  /// [animate] indicates whether this token should be animated
  /// in [FlyingCharacters].
  Token({
    required this.text,
    required this.animate,
  });

  /// The string content of this token.
  final String text;

  /// Whether this token should be animated.
  ///
  /// Typically, word-like tokens are animated (`true`) while
  /// spaces and punctuation are not (`false`).
  final bool animate;
}
