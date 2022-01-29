import 'package:iprice/constants/msg_constants.dart';
import 'package:iprice/iprice.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'mock/services/mock_services.dart';

void main() {
  final _mockIoService = mockIoService();

  setUp(() {
    reset(_mockIoService);
  });

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

    test('askForAction will ask display bye message if enter action with value 5', () {
      when(_mockIoService.askInput(any)).thenReturn('5');

      final _iPrice = IPrice(ioService: _mockIoService);

      _iPrice.askForAction();

      verify(
        _mockIoService.print(
          argThat(contains(byeMsg)),
          withNewLine: anyNamed('withNewLine'),
        ),
      ).called(1);
    });

    test('askForAction will trigger askTextForTransform if enter value > 0 and value < 5', () {
      var count = 0;
      when(_mockIoService.askInput(any)).thenAnswer((_) => ['1', '2', '3', '4'][count++]);

      final _iPrice = IPrice(ioService: _mockIoService);

      var _value = 0;
      expect(_value, equals(0));

      _iPrice.askForAction(mockAskTextForTransform: (action) {
        _value = action;
      });
      expect(_value, equals(1));

      _iPrice.askForAction(mockAskTextForTransform: (action) {
        _value = action;
      });
      expect(_value, equals(2));

      _iPrice.askForAction(mockAskTextForTransform: (action) {
        _value = action;
      });
      expect(_value, equals(3));

      _iPrice.askForAction(mockAskTextForTransform: (action) {
        _value = action;
      });
      expect(_value, equals(4));
    });
  });

  group('askTextForTransform', () {
    test('askTextForTransform will ask for input with expected label', () {
      final _text = 'abcd efgf';

      when(_mockIoService.askInput(any)).thenReturn(_text);

      final _iPrice = IPrice(ioService: _mockIoService);

      _iPrice.askTextForTransform(1);

      verify(
        _mockIoService.askInput(
          argThat(contains(textSomethingMsg)),
          withNewLine: anyNamed('withNewLine'),
        ),
      ).called(1);
    });

    test('askTextForTransform will ask display error message if enter empty text', () {
      //second time input some value to break the loop
      var count = 0;
      when(_mockIoService.askInput(any)).thenAnswer((_) => ['', 'abcd'][count++]);

      final _iPrice = IPrice(ioService: _mockIoService);

      _iPrice.askTextForTransform(1);

      verify(
        _mockIoService.error(
          argThat(contains(invalidTextMsg)),
          withNewLine: anyNamed('withNewLine'),
        ),
      ).called(1);
    });

    group('handle action', () {
      test('askTextForTransform will output uppercase result if action is 1', () {
        final _text = 'Abcd eFgf';

        when(_mockIoService.askInput(any)).thenReturn(_text);

        final _iPrice = IPrice(ioService: _mockIoService);

        _iPrice.askTextForTransform(1);

        verify(
          _mockIoService.print(
            argThat(contains('$uppercaseResultPrefix ${_text.toUpperCase()}')),
            withNewLine: anyNamed('withNewLine'),
          ),
        ).called(1);
      });

      test('askTextForTransform will output lowercase result if action is 2', () {
        final _text = 'Abcd eFgf';

        when(_mockIoService.askInput(any)).thenReturn(_text);

        final _iPrice = IPrice(ioService: _mockIoService);

        _iPrice.askTextForTransform(2);

        verify(
          _mockIoService.print(
            argThat(contains('$lowercaseResultPrefix ${_text.toLowerCase()}')),
            withNewLine: anyNamed('withNewLine'),
          ),
        ).called(1);
      });

      group('tranform by character', () {
        test('askTextForTransform will trigger transformInputByChar if action is 3', () {
          final _text = 'Abcd eFgf';
          final _transformText = 'abCd EFgF';

          when(_mockIoService.askInput(any)).thenReturn(_text);

          final _iPrice = IPrice(ioService: _mockIoService);

          var _isTrigger = false;
          expect(_isTrigger, isFalse);

          _iPrice.askTextForTransform(3, mockTransformInputByChar: (text) {
            _isTrigger = true;
            return _transformText;
          });

          expect(_isTrigger, isTrue);
        });

        test('askTextForTransform will output transform result if action is 3', () {
          final _text = 'Abcd eFgf';
          final _transformText = 'abCd EFgF';

          when(_mockIoService.askInput(any)).thenReturn(_text);

          final _iPrice = IPrice(ioService: _mockIoService);

          _iPrice.askTextForTransform(3, mockTransformInputByChar: (text) => _transformText);

          verify(
            _mockIoService.print(
              argThat(contains('$transformResultPrefix $_transformText')),
              withNewLine: anyNamed('withNewLine'),
            ),
          ).called(1);
        });
      });
    });
  });

  group('transformInputByChar', () {
    test('transformInputByChar will ask for transform action for each character with expected label', () {
      final _text = 'AbcdeFgf';
      final _textList = _text.split('');

      when(_mockIoService.askInput(any)).thenReturn('u');

      final _iPrice = IPrice(ioService: _mockIoService);

      _iPrice.transformInputByChar(_text);

      for (var t in _textList) {
        verify(
          _mockIoService.askInput(
            argThat(contains("$transformTextLabelPrefix '$t': ")),
            withNewLine: anyNamed('withNewLine'),
          ),
        ).called(1);
      }
    });

    test(
        'transformInputByChar will ask for transform action for each character with expected label but skip empty space',
        () {
      final _text = 'Abcd eFgf';
      final _textList = _text.split('');

      when(_mockIoService.askInput(any)).thenReturn('u');

      final _iPrice = IPrice(ioService: _mockIoService);

      _iPrice.transformInputByChar(_text);

      for (var t in _textList) {
        if (t.trim().isEmpty) {
          verifyNever(
            _mockIoService.askInput(
              argThat(contains("$transformTextLabelPrefix '$t': ")),
              withNewLine: anyNamed('withNewLine'),
            ),
          );
        } else {
          verify(
            _mockIoService.askInput(
              argThat(contains("$transformTextLabelPrefix '$t': ")),
              withNewLine: anyNamed('withNewLine'),
            ),
          ).called(1);
        }
      }
    });

    group('Invalid transform action selected case', () {
      test('transformInputByChar will display error message if transform action is empty', () {
        final _text = 'AbcdeFgf';

        //second time input some value to break the loop
        var _returnEmpty = true;
        when(_mockIoService.askInput(any)).thenAnswer((_) {
          if (_returnEmpty) {
            _returnEmpty = false;
            return '';
          }

          return 'u';
        });

        final _iPrice = IPrice(ioService: _mockIoService);

        _iPrice.transformInputByChar(_text);

        verify(
          _mockIoService.print(
            argThat(contains(invalidTransformActionMsg)),
            withNewLine: anyNamed('withNewLine'),
          ),
        ).called(1);
      });

      test('transformInputByChar will display error message if transform action is null', () {
        final _text = 'AbcdeFgf';

        //second time input some value to break the loop
        var _returnEmpty = true;
        when(_mockIoService.askInput(any)).thenAnswer((_) {
          if (_returnEmpty) {
            _returnEmpty = false;
            return null;
          }

          return 'u';
        });

        final _iPrice = IPrice(ioService: _mockIoService);

        _iPrice.transformInputByChar(_text);

        verify(
          _mockIoService.print(
            argThat(contains(invalidTransformActionMsg)),
            withNewLine: anyNamed('withNewLine'),
          ),
        ).called(1);
      });

      test('transformInputByChar will display error message if transform action is not u or l', () {
        final _text = 'Abc';

        //after enter wrong few time then input some value to break the loop
        var _count = 0;
        when(_mockIoService.askInput(any)).thenAnswer((_) => ['asd', 'q', '1', 'u', 'u', 'u'][_count++]);

        final _iPrice = IPrice(ioService: _mockIoService);

        _iPrice.transformInputByChar(_text);

        verify(
          _mockIoService.print(
            argThat(contains(invalidTransformActionMsg)),
            withNewLine: anyNamed('withNewLine'),
          ),
        ).called(3);
      });
    });

    test('transformInputByChar will return expected transform result', () {
      final _text = 'Abcd eFgf';

      var _count = 0;
      when(_mockIoService.askInput(any)).thenAnswer((_) => ['l', 'u', 'l', 'u', 'u', 'u', 'u', 'l'][_count++]);

      final _iPrice = IPrice(ioService: _mockIoService);

      final _result = _iPrice.transformInputByChar(_text);
      expect(_result, equals('aBcD EFGf'));
    });
  });
}
