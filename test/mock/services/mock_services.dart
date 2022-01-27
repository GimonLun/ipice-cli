import 'package:iprice/services/io_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mock_services.mocks.dart';

@GenerateMocks([
  IoService,
])
void main() {}

MockIoService mockIoService({String? mockInput}) {
  final _service = MockIoService();

  when(_service.askInput(any, withNewLine: anyNamed('withNewLine'))).thenReturn(mockInput ?? '');
  when(_service.print(any, withNewLine: anyNamed('withNewLine'))).thenReturn(null);
  when(_service.error(any, withNewLine: anyNamed('withNewLine'))).thenReturn(null);

  return _service;
}
