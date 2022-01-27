import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:iprice/iprice.dart';
import 'package:iprice/services/io_service.dart';

Future<void> main(List<String> arguments) async {
  GetIt.instance.registerLazySingleton(() => IoService());

  final _iPrice = IPrice();

  await _iPrice.startConsole();

  // String? _input;

  // while (_input == null || _input.isEmpty) {
  //   stdout.write('Type something or enter x to exits: ');

  //   _input = stdin.readLineSync();

  //   if (_input == null || _input.isEmpty) {
  //     stdout.writeln('Invalid input!');
  //     continue;
  //   }

  //   if (_input.toLowerCase() == 'x') {
  //     break;
  //   }

  //   stdout.writeln('Uppercase: ${_input.toUpperCase()}\n');
  //   stdout.writeln('-------------------------------------------------------');
  //   stdout.writeln('Transform Case: ${transformInputByChar(_input)}\n');
  //   stdout.writeln('-------------------------------------------------------');
  // }
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
