import 'package:flutter/material.dart';
import 'token_model.dart';

class TextTokenizer {
  static List<Token> tokenize(String input) {
    final List<Token> result = <Token>[];
    final characters = input.characters; // grapheme safe

    String buffer = '';
    bool insideWord = false;

    for (final char in characters) {
      final isWord = RegExp(r'[A-Za-z0-9\u00C0-\u017F]').hasMatch(char);

      if (isWord) {
        if (!insideWord && buffer.isNotEmpty) {
          result.add(Token(text: buffer, animate: false));
          buffer = '';
        }
        insideWord = true;
        buffer += char;
      } else {
        if (insideWord) {
          result.add(Token(text: buffer, animate: true));
          buffer = '';
        }
        insideWord = false;
        buffer += char;
      }
    }

    if (buffer.isNotEmpty) {
      result.add(Token(text: buffer, animate: insideWord));
    }

    return result;
  }
}
