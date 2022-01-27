import 'dart:io';

class IoService {
  String? askInput() => stdin.readLineSync();

  void print(String text, {bool withNewLine = false}) {
    if (withNewLine) {
      stdout.writeln(text);

      return;
    }

    stdout.write(text);
  }

  void error(String text, {bool withNewLine = false}) {
    if (withNewLine) {
      stderr.writeln(text);

      return;
    }

    stderr.write(text);
  }
}
