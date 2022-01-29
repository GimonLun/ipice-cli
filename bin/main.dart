import 'package:iprice/iprice.dart';
import 'package:iprice/services/io_service.dart';

Future<void> main(List<String> arguments) async {
  final _iPrice = IPrice(ioService: IoService());

  _iPrice.startConsole();
}
