import 'dart:io';

import 'package:csv/csv.dart';
import 'package:iprice/constants/msg_constants.dart';
import 'package:iprice/data/enums/action_type.dart';
import 'package:iprice/services/io_service.dart';
import 'package:path/path.dart' as p;

class IPrice {
  final IoService ioService;

  IPrice({required this.ioService});

  Future<void> startConsole({Function()? mockAskForAction}) async {
    ioService.print('\n*******************************************************************************');
    ioService.print('*****                    Welcome to text converter cli                    *****');
    ioService.print('*****                        Supported operations                         *****');
    ioService.print('*****                                                                     *****');
    ioService.print('***** 1. Convert to uppercase                                             *****');
    ioService.print('***** 2. Convert to lowercase                                             *****');
    ioService.print('***** 3. Convert string by character                                      *****');
    ioService.print('***** 4. Output simple csv                                                *****');
    ioService.print('***** 5. Exit                                                             *****');
    ioService.print('*******************************************************************************');
    ioService.print('');

    if (mockAskForAction != null) {
      mockAskForAction();
    } else {
      await askForAction();
    }
  }

  Future<void> askForAction({Function(int)? mockAskTextForTransform}) async {
    String? _input;
    while (_input == null || _input.isEmpty) {
      _input = ioService.askInput(selectActionMsg);

      final _action = int.tryParse(_input ?? '');
      _input = null;

      if (_action == null || _action < supportedActionMin || _action > supportedActionMax) {
        ioService.error('$invalidActionMsg\n');
        continue;
      }

      if (_action == ActionType.exit.index) {
        ioService.print(byeMsg);
        return;
      }

      if (mockAskTextForTransform != null) {
        mockAskTextForTransform(_action);
        break;
      } else {
        await askTextForTransform(_action);
      }
    }
  }

  Future<void> askTextForTransform(
    int action, {
    String Function(String)? mockTransformInputByChar,
    String Function(String)? mockGenerateCsv,
  }) async {
    String? _input;
    while (_input == null || _input.isEmpty) {
      _input = ioService.askInput(textSomethingMsg);

      if (_input == null || _input.trim().isEmpty) {
        ioService.error(invalidTextMsg);
        continue;
      }

      break;
    }

    if (action == ActionType.uppercase.index) {
      ioService.print('$uppercaseResultPrefix ${_input.toUpperCase()}\n');
      return;
    }

    if (action == ActionType.lowercase.index) {
      ioService.print('$lowercaseResultPrefix ${_input.toLowerCase()}\n');
      return;
    }

    if (action == ActionType.transformByChar.index) {
      final _transformResult =
          mockTransformInputByChar != null ? mockTransformInputByChar(_input) : transformInputByChar(_input);
      ioService.print('$transformResultPrefix $_transformResult\n');
      return;
    }

    if (action == ActionType.generateCsv.index) {
      final _path = mockGenerateCsv != null ? mockGenerateCsv(_input) : await generateCsv(_input);
      ioService.print('$csvCreatedPrefix $_path\n');
      return;
    }
  }

  String transformInputByChar(String input) {
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

      final _input = ioService.askInput("$transformTextLabelPrefix '$_char': ");

      if (_input == null || _input.trim().isEmpty) {
        ioService.print(invalidTransformActionMsg);
        continue;
      }

      final _lowercaseInput = _input.toLowerCase();
      if (_lowercaseInput != 'u' && _lowercaseInput != 'l') {
        ioService.print(invalidTransformActionMsg);
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

  Future<String> generateCsv(String input) async {
    final _inputList = input.split('');

    final _value = _inputList.map((e) => '$e,').toList();

    final _csv = ListToCsvConverter().convert(
      [
        _value,
      ],
    );

    final _file = File(p.join('bin', 'output.csv'));
    await _file.writeAsString(_csv);

    return _file.absolute.path;
  }
}
