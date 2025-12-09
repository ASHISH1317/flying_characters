/// Defines the animation granularity for [FlyingCharacters].
///
/// Use this to control whether the animation should apply to whole words
/// or to individual characters.
enum FlyingCharactersMode {
  /// Animate entire words at a time.
  ///
  /// This is the default mode. Each tokenized word (letters/numbers)
  /// will "fly" as a unit.
  word,

  /// Animate every character individually.
  ///
  /// Each character, including punctuation and spaces, will be animated
  /// separately, allowing for more granular "flying" effects.
  character,
}
