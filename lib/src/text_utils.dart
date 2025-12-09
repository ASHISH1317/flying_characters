import 'package:flutter/material.dart';
import 'flying_characters_mode.dart';
import 'token_model.dart';

/// A utility class to tokenize a string into a list of [Token]s.
///
/// This class separates input text into individual "tokens" (words or non-word
/// sequences) for use in [FlyingCharacters]. Alphabetic and numeric characters
/// are considered part of words and will be animated. Punctuation, spaces, and
/// other characters are treated as non-animated tokens.[web:36]
class TextTokenizer {
  /// Tokenizes the [input] string into a list of [Token] objects.
  ///
  /// Each word-like sequence (letters, digits, accented letters) becomes
  /// an animated token. Non-word sequences (spaces, punctuation) become
  /// non-animated tokens.
  ///
  /// This implementation is used by [FlyingCharacters] to ensure that
  /// wrapping only happens between tokens (at word boundaries).
  static List<Token> tokenize(
    String input, {
    FlyingCharactersMode mode = FlyingCharactersMode.word,
  }) {
    // For this use case, mode is always word, but the parameter is kept
    // for API compatibility/future extension.
    switch (mode) {
      case FlyingCharactersMode.character:
        // Not used by FlyingCharacters anymore; kept for completeness.
        return input.characters
            .map((c) => Token(text: c, animate: c.trim().isNotEmpty))
            .toList();

      case FlyingCharactersMode.word:
        final List<Token> result = <Token>[];
        final characters = input.characters;

        String buffer = '';
        bool insideWord = false;

        for (final char in characters) {
          // Matches word characters (letters, digits, accented letters).
          final isWord = !RegExp(r'\s').hasMatch(char);

          if (isWord) {
            if (!insideWord && buffer.isNotEmpty) {
              // Flush previous non-word buffer as non-animated token.
              result.add(Token(text: buffer, animate: false));
              buffer = '';
            }
            insideWord = true;
            buffer += char;
          } else {
            if (insideWord) {
              // Flush previous word buffer as animated token.
              result.add(Token(text: buffer, animate: true));
              buffer = '';
            }
            insideWord = false;
            buffer += char;
          }
        }

        // Add last buffered token.
        if (buffer.isNotEmpty) {
          result.add(Token(text: buffer, animate: insideWord));
        }

        return result;
    }
  }
}
