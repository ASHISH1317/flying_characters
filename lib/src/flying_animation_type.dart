/// Defines the visual transition style applied to each glyph (word/character)
/// during animation in [FlyingCharacters].
///
/// Each type produces a different entry effect when text appears.
enum FlyingAnimationType {
  /// Characters enter from random positions and "fly" into place.
  /// Dynamic, energetic motion.
  fly,

  /// Characters fade in softly with a subtle blur effect.
  /// Smooth and elegant.
  fadeBlur,

  /// Text elements flip along 3D axes before settling.
  /// Adds depth and perspective.
  flip3d,

  /// Characters swirl/float in a wavy motion before landing.
  /// Whimsical and playful.
  swirlFloat,
}
