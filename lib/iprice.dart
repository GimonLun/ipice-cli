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

  void askForAction() {
    String? _input;
    while (_input == null || _input.isEmpty) {
      _input = ioService.askInput(selectActionMsg);

      final _action = int.tryParse(_input ?? '');
      _input = null;

      if (_action == null || _action < 1 || _action > 5) {
        ioService.error(invalidActionMsg);
        continue;
      }

      switch (_action) {
        case 5:
          ioService.print(byeMsg);
          return;
      }
    }
  }
}
