import 'package:get_it/get_it.dart';
import 'package:iprice/services/io_service.dart';

class IPrice {
  final IoService _ioService;

  IPrice() : _ioService = GetIt.instance.get();

  Future<void> startConsole() async {
    _ioService.print('\n************************ Welcome to text converter cli ************************');
    _ioService.print('***** Supported operations                                                *****');
    _ioService.print('***** 1. Convert to uppercase                                             *****');
    _ioService.print('***** 2. Convert to lowercase                                             *****');
    _ioService.print('***** 3. Convert string by character                                      *****');
    _ioService.print('***** 4. Output simple csv                                                *****');
    _ioService.print('***** 5. Exit                                                             *****');
    _ioService.print('*******************************************************************************');

    _ioService.askInput('Select action: ');
  }
}
