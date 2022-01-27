import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:iprice/iprice.dart';
import 'package:iprice/services/io_service.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'mock/services/mock_services.dart';

void main() {
  late GetIt getIt;

  setUp(() async {
    getIt = GetIt.instance;

    getIt.reset();
  });

  group('startConsole', () {
    test('startConsole will print out supported action correctly', () {
      final _mockIoService = mockIoService();

      getIt.registerLazySingleton<IoService>(() => _mockIoService);

      final _iPrice = IPrice();

      unawaited(_iPrice.startConsole());

      verify(
        _mockIoService.print(
          argThat(contains("Welcome to text converter cli")),
          withNewLine: anyNamed('withNewLine'),
        ),
      ).called(1);

      verify(
        _mockIoService.print(
          argThat(contains("Supported operations")),
          withNewLine: anyNamed('withNewLine'),
        ),
      ).called(1);

      verify(
        _mockIoService.print(
          argThat(contains("1. Convert to uppercase")),
          withNewLine: anyNamed('withNewLine'),
        ),
      ).called(1);

      verify(
        _mockIoService.print(
          argThat(contains("2. Convert to lowercase")),
          withNewLine: anyNamed('withNewLine'),
        ),
      ).called(1);

      verify(
        _mockIoService.print(
          argThat(contains("3. Convert string by character")),
          withNewLine: anyNamed('withNewLine'),
        ),
      ).called(1);

      verify(
        _mockIoService.print(
          argThat(contains("4. Output simple csv")),
          withNewLine: anyNamed('withNewLine'),
        ),
      ).called(1);

      verify(
        _mockIoService.print(
          argThat(contains("5. Exit")),
          withNewLine: anyNamed('withNewLine'),
        ),
      ).called(1);
    });

    test('startConsole will ask for input with expected label', () {
      final _mockIoService = mockIoService();

      getIt.registerLazySingleton<IoService>(() => _mockIoService);

      final _iPrice = IPrice();

      unawaited(_iPrice.startConsole());

      verify(
        _mockIoService.askInput(
          argThat(contains("Select action: ")),
          withNewLine: anyNamed('withNewLine'),
        ),
      ).called(1);
    });
  });
}
