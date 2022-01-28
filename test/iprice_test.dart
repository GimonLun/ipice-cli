import 'package:iprice/constants/msg_constants.dart';
import 'package:iprice/iprice.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'mock/services/mock_services.dart';

void main() {
  final _mockIoService = mockIoService();

  group('startConsole', () {
    test('startConsole will print out supported action correctly', () {
      final _iPrice = IPrice(ioService: _mockIoService);

      _iPrice.startConsole(mockAskForAction: () {});

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

    test('startConsole will trigger askForAction', () {
      final _iPrice = IPrice(ioService: _mockIoService);

      var _isTriggerAskForAction = false;

      expect(_isTriggerAskForAction, isFalse);

      _iPrice.startConsole(mockAskForAction: () {
        _isTriggerAskForAction = !_isTriggerAskForAction;
      });

      expect(_isTriggerAskForAction, isTrue);
    });
  });

  group('askForAction', () {
    test('askForAction will ask for input with expected label', () {
      when(_mockIoService.askInput(any)).thenReturn('5');

      final _iPrice = IPrice(ioService: _mockIoService);

      _iPrice.askForAction();

      verify(
        _mockIoService.askInput(
          argThat(contains(selectActionMsg)),
          withNewLine: anyNamed('withNewLine'),
        ),
      ).called(1);
    });

    test('askForAction will ask display error message if enter action with non-digit', () {
      //second time input choose 5 to exit so it won't keep looping
      var count = 0;
      when(_mockIoService.askInput(any)).thenAnswer((_) => ['a', '5'][count++]);

      final _iPrice = IPrice(ioService: _mockIoService);

      _iPrice.askForAction();

      verify(
        _mockIoService.error(
          argThat(contains(invalidActionMsg)),
          withNewLine: anyNamed('withNewLine'),
        ),
      ).called(1);
    });

    test('askForAction will ask display error message if enter action with value less than 1', () {
      //second time input choose 5 to exit so it won't keep looping
      var count = 0;
      when(_mockIoService.askInput(any)).thenAnswer((_) => ['0', '5'][count++]);

      final _iPrice = IPrice(ioService: _mockIoService);

      _iPrice.askForAction();

      verify(
        _mockIoService.error(
          argThat(contains(invalidActionMsg)),
          withNewLine: anyNamed('withNewLine'),
        ),
      ).called(1);
    });

    test('askForAction will ask display error message if enter action with value greater than 5', () {
      //second time input choose 5 to exit so it won't keep looping
      var count = 0;
      when(_mockIoService.askInput(any)).thenAnswer((_) => ['6', '5'][count++]);

      final _iPrice = IPrice(ioService: _mockIoService);

      _iPrice.askForAction();

      verify(
        _mockIoService.error(
          argThat(contains(invalidActionMsg)),
          withNewLine: anyNamed('withNewLine'),
        ),
      ).called(1);
    });
  });
}
