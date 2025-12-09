/// Defines the animation granularity for [FlyingCharacters].
///
/// Use this to control whether the animation should apply to whole words
/// or to individual characters inside each word.
enum FlyingCharactersMode {
  /// Animate entire words at a time.
  ///
  /// Each tokenized word (letters/numbers) will "fly" as a unit.
  word,

  /// Animate every character inside each word individually.
  ///
  /// Layout still wraps by word; each character has its own animation
  /// but the containing word will not break across lines.
  character,
}
