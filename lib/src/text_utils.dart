import 'package:flutter/material.dart';
import 'token_model.dart';

/// A utility class to tokenize a string into a list of [Token]s.
///
/// This class separates input text into individual "tokens" (words or non-word sequences)
/// for use in [FlyingCharacters]. Alphabetic and numeric characters are considered
/// part of words and will be animated. Punctuation, spaces, and other characters
/// are treated as non-animated tokens.
class TextTokenizer {
  /// Tokenizes the [input] string into a list of [Token] objects.
  ///
  /// Each word-like sequence (letters, digits, accented letters) becomes an animated token.
  /// Non-word sequences (spaces, punctuation) become non-animated tokens.
  static List<Token> tokenize(String input) {
    final List<Token> result = <Token>[];

    // Use grapheme-safe iteration for proper Unicode handling.
    final characters = input.characters;

    String buffer = '';
    bool insideWord = false;

    for (final char in characters) {
      // Matches word characters (letters, digits, accented letters)
      final isWord = RegExp(r'[A-Za-z0-9\u00C0-\u017F]').hasMatch(char);

      if (isWord) {
        if (!insideWord && buffer.isNotEmpty) {
          // Previous buffer was non-word, add as non-animated token
          result.add(Token(text: buffer, animate: false));
          buffer = '';
        }
        insideWord = true;
        buffer += char;
      } else {
        if (insideWord) {
          // Previous buffer was a word, add as animated token
          result.add(Token(text: buffer, animate: true));
          buffer = '';
        }
        insideWord = false;
        buffer += char;
      }
    }

    // Add the last buffered token if any
    if (buffer.isNotEmpty) {
      result.add(Token(text: buffer, animate: insideWord));
    }

    return result;
  }
}
