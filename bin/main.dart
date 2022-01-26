import 'dart:io';

const textInput = 'text';

void main(List<String> arguments) {
  stdout.writeln('Type something: ');
  final input = stdin.readLineSync();

  if (input != null) {
    stdout.writeln('Output: \n${input.toUpperCase()}');
  }
}
