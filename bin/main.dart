import 'dart:io';

import 'package:iprice/iprice.dart';
import 'package:iprice/services/io_service.dart';

Future<void> main(List<String> arguments) async {
  final _iPrice = IPrice(ioService: IoService());

  _iPrice.startConsole();
}

String transformInputByChar(String input) {
  stdout.writeln('Transformation');

  var _output = '';

  final _inputList = input.split('');

  int _index = 0;
  while (_index < _inputList.length) {
    final _char = _inputList.elementAt(_index);

    if (_char.trim().isEmpty) {
      _output += _char;
      _index++;
      continue;
    }

    stdout.write('Current char: $_char (enter u for uppercase, l for lowercase)');
    final _input = stdin.readLineSync();

    if (_input == null || _input.isEmpty) {
      continue;
    }

    final _lowercaseInput = _input.toLowerCase();
    if (_lowercaseInput != 'u' && _lowercaseInput != 'l') {
      stdout.writeln('Invalid input!');
      continue;
    }

    if (_lowercaseInput == 'u') {
      _output += _char.toUpperCase();
    } else if (_lowercaseInput == 'l') {
      _output += _char.toLowerCase();
    }

    _index++;
  }

  return _output;
}
