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

        //TODO ask is it want continue
      }
    }
  }

  void askTextForTransform(int action) {
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
        ioService.print('Uppercase: ${_input.toUpperCase()}\n');
        break;
      case 2:
        ioService.print('Lowercase: ${_input.toLowerCase()}\n');
        break;
    }
  }
}
