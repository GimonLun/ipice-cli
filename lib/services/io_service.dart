import 'dart:io';

class IoService {
  String? askInput(String? label, {bool withNewLine = false}) {
    if (label != null) {
      print(label, withNewLine: withNewLine);
    }
    return stdin.readLineSync();
  }

  void print(String text, {bool withNewLine = true}) {
    if (withNewLine) {
      stdout.writeln(text);

      return;
    }

    stdout.write(text);
  }

  void error(String text, {bool withNewLine = true}) {
    if (withNewLine) {
      stderr.writeln(text);

      return;
    }

    stderr.write(text);
  }
}
