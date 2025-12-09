/// Defines the visual transition style applied to each character/token
/// during animation in `FlyingCharacters`.
///
/// Each type produces a different entry effect when text appears.
enum FlyingAnimationType {

  /// Characters enter from random positions and "fly" into place.
  /// A dynamic motion-based animation — energetic & playful.
  fly,

  /// Characters fade in softly with a subtle blur effect.
  /// Smooth, elegant — great for gentle UI/hero text reveals.
  fadeBlur,

  /// Text elements flip along the 3D axis before settling.
  /// Adds depth and perspective — visually attention-grabbing.
  flip3d,

  /// Characters swirl/float in a wavy motion before landing.
  /// Whimsical, light feeling — good for creative or fun themes.
  swirlFloat,
}
