import 'package:iprice/constants/msg_constants.dart';
import 'package:iprice/services/io_service.dart';

class IPrice {
  final IoService ioService;

  IPrice({required this.ioService});

  void startConsole({Function()? mockAskForAction}) {
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
      askForAction();
    }
  }

  void askForAction({Function(int)? mockAskTextForTransform}) {
    String? _input;
    while (_input == null || _input.isEmpty) {
      _input = ioService.askInput(selectActionMsg);

      final _action = int.tryParse(_input ?? '');
      _input = null;

      if (_action == null || _action < 1 || _action > 5) {
        ioService.error('$invalidActionMsg\n');
        continue;
      }

      if (_action == 5) {
        ioService.print(byeMsg);
        return;
      }

      if (mockAskTextForTransform != null) {
        mockAskTextForTransform(_action);
        break;
      } else {
        askTextForTransform(_action);
      }
    }
  }

  void askTextForTransform(
    int action, {
    String Function(String)? mockTransformInputByChar,
  }) {
    String? _input;
    while (_input == null || _input.isEmpty) {
      _input = ioService.askInput(textSomethingMsg);

      if (_input == null || _input.trim().isEmpty) {
        ioService.error(invalidTextMsg);
        continue;
      }

      break;
    }

    switch (action) {
      case 1:
        ioService.print('$uppercaseResultPrefix ${_input.toUpperCase()}\n');
        break;
      case 2:
        ioService.print('$lowercaseResultPrefix ${_input.toLowerCase()}\n');
        break;
      case 3:
        final _transformResult =
            mockTransformInputByChar != null ? mockTransformInputByChar(_input) : transformInputByChar(_input);
        ioService.print('$transformResultPrefix $_transformResult\n');
        break;
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
}
