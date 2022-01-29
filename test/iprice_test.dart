import 'dart:convert';
import 'dart:io';
import 'package:iprice/data/enums/action_type.dart';

import 'mock/services/mock_services.dart';
import 'package:csv/csv.dart';
import 'package:iprice/constants/msg_constants.dart';
import 'package:iprice/iprice.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

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
      when(_mockIoService.askInput(any)).thenReturn(ActionType.exit.index.toString());

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
      //second time input choose exit so it won't keep looping
      var count = 0;
      when(_mockIoService.askInput(any)).thenAnswer(
        (_) => [
          'a',
          ActionType.exit.index.toString(),
        ][count++],
      );

      final _iPrice = IPrice(ioService: _mockIoService);

      _iPrice.askForAction();

      verify(
        _mockIoService.error(
          argThat(contains(invalidActionMsg)),
          withNewLine: anyNamed('withNewLine'),
        ),
      ).called(1);
    });

    test('askForAction will ask display error message if enter action with value less than supportedActionMin', () {
      //second time input choose exit so it won't keep looping
      var count = 0;
      when(_mockIoService.askInput(any)).thenAnswer(
        (_) => [
          ActionType.none.index.toString(),
          ActionType.exit.index.toString(),
        ][count++],
      );

      final _iPrice = IPrice(ioService: _mockIoService);

      _iPrice.askForAction();

      verify(
        _mockIoService.error(
          argThat(contains(invalidActionMsg)),
          withNewLine: anyNamed('withNewLine'),
        ),
      ).called(1);
    });

    test('askForAction will ask display error message if enter action with value greater than supportedActionMax', () {
      //second time input choose exit so it won't keep looping
      var count = 0;
      when(_mockIoService.askInput(any)).thenAnswer(
        (_) => [
          '6',
          ActionType.exit.index.toString(),
        ][count++],
      );

      final _iPrice = IPrice(ioService: _mockIoService);

      _iPrice.askForAction();

      verify(
        _mockIoService.error(
          argThat(contains(invalidActionMsg)),
          withNewLine: anyNamed('withNewLine'),
        ),
      ).called(1);
    });

    test('askForAction will ask display bye message if enter action with value ActionType.exit.index', () {
      when(_mockIoService.askInput(any)).thenReturn(
        ActionType.exit.index.toString(),
      );

      final _iPrice = IPrice(ioService: _mockIoService);

      _iPrice.askForAction();

      verify(
        _mockIoService.print(
          argThat(contains(byeMsg)),
          withNewLine: anyNamed('withNewLine'),
        ),
      ).called(1);
    });

    test('askForAction will trigger askTextForTransform if enter value within supported action range', () {
      var count = 0;
      when(_mockIoService.askInput(any)).thenAnswer(
        (_) => [
          ActionType.uppercase.index.toString(),
          ActionType.lowercase.index.toString(),
          ActionType.transformByChar.index.toString(),
          ActionType.generateCsv.index.toString(),
        ][count++],
      );

      final _iPrice = IPrice(ioService: _mockIoService);

      var _value = 0;
      expect(_value, equals(0));

      _iPrice.askForAction(mockAskTextForTransform: (action) {
        _value = action;
      });
      expect(_value, equals(ActionType.uppercase.index));

      _iPrice.askForAction(mockAskTextForTransform: (action) {
        _value = action;
      });
      expect(_value, equals(ActionType.lowercase.index));

      _iPrice.askForAction(mockAskTextForTransform: (action) {
        _value = action;
      });
      expect(_value, equals(ActionType.transformByChar.index));

      _iPrice.askForAction(mockAskTextForTransform: (action) {
        _value = action;
      });
      expect(_value, equals(ActionType.generateCsv.index));
    });
  });

  group('askTextForTransform', () {
    test('askTextForTransform will ask for input with expected label', () {
      final _text = 'abcd efgf';

      when(_mockIoService.askInput(any)).thenReturn(_text);

      final _iPrice = IPrice(ioService: _mockIoService);

      _iPrice.askTextForTransform(ActionType.uppercase.index);

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

      _iPrice.askTextForTransform(ActionType.uppercase.index);

      verify(
        _mockIoService.error(
          argThat(contains(invalidTextMsg)),
          withNewLine: anyNamed('withNewLine'),
        ),
      ).called(1);
    });

    group('handle action', () {
      test('askTextForTransform will output uppercase result if action is ActionType.uppercase', () {
        final _text = 'Abcd eFgf';

        when(_mockIoService.askInput(any)).thenReturn(_text);

        final _iPrice = IPrice(ioService: _mockIoService);

        _iPrice.askTextForTransform(ActionType.uppercase.index);

        verify(
          _mockIoService.print(
            argThat(contains('$uppercaseResultPrefix ${_text.toUpperCase()}')),
            withNewLine: anyNamed('withNewLine'),
          ),
        ).called(1);
      });

      test('askTextForTransform will output lowercase result if action is ActionType.lowercase', () {
        final _text = 'Abcd eFgf';

        when(_mockIoService.askInput(any)).thenReturn(_text);

        final _iPrice = IPrice(ioService: _mockIoService);

        _iPrice.askTextForTransform(ActionType.lowercase.index);

        verify(
          _mockIoService.print(
            argThat(contains('$lowercaseResultPrefix ${_text.toLowerCase()}')),
            withNewLine: anyNamed('withNewLine'),
          ),
        ).called(1);
      });

      group('tranform by character', () {
        test('askTextForTransform will trigger transformInputByChar if action is ActionType.transformByChar', () {
          final _text = 'Abcd eFgf';
          final _transformText = 'abCd EFgF';

          when(_mockIoService.askInput(any)).thenReturn(_text);

          final _iPrice = IPrice(ioService: _mockIoService);

          var _isTrigger = false;
          expect(_isTrigger, isFalse);

          _iPrice.askTextForTransform(ActionType.transformByChar.index, mockTransformInputByChar: (text) {
            _isTrigger = true;
            return _transformText;
          });

          expect(_isTrigger, isTrue);
        });

        test('askTextForTransform will output transform result if action is ActionType.transformByChar', () {
          final _text = 'Abcd eFgf';
          final _transformText = 'abCd EFgF';

          when(_mockIoService.askInput(any)).thenReturn(_text);

          final _iPrice = IPrice(ioService: _mockIoService);

          _iPrice.askTextForTransform(ActionType.transformByChar.index,
              mockTransformInputByChar: (text) => _transformText);

          verify(
            _mockIoService.print(
              argThat(contains('$transformResultPrefix $_transformText')),
              withNewLine: anyNamed('withNewLine'),
            ),
          ).called(1);
        });
      });

      group('generate csv', () {
        test('askTextForTransform will trigger generateCsv if action is ActionType.generateCsv', () {
          final _text = 'Abcd eFgf';

          when(_mockIoService.askInput(any)).thenReturn(_text);

          final _iPrice = IPrice(ioService: _mockIoService);

          var _isTrigger = false;
          expect(_isTrigger, isFalse);

          _iPrice.askTextForTransform(ActionType.generateCsv.index, mockGenerateCsv: (text) {
            _isTrigger = true;
            return './output.csv';
          });

          expect(_isTrigger, isTrue);
        });

        test('askTextForTransform will output transform result if action is ActionType.generateCsv', () {
          final _text = 'Abcd eFgf';
          final _path = './output.csv';

          when(_mockIoService.askInput(any)).thenReturn(_text);

          final _iPrice = IPrice(ioService: _mockIoService);

          _iPrice.askTextForTransform(ActionType.generateCsv.index, mockGenerateCsv: (text) => _path);

          verify(
            _mockIoService.print(
              argThat(contains('$csvCreatedPrefix $_path')),
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

  group('generateCsv', () {
    test('generateCsv will return csv generated path', () async {
      final _text = 'Abcd eFgf';

      final _iPrice = IPrice(ioService: _mockIoService);

      final _result = await _iPrice.generateCsv(_text);
      final _file = File(p.join('bin', 'output.csv'));

      expect(_result, equals(_file.absolute.path));
    });

    test('generateCsv will generate a output.csv file in bin folder with expected content', () async {
      final _text = 'Abcd eFgf';

      final _iPrice = IPrice(ioService: _mockIoService);

      final _result = await _iPrice.generateCsv(_text);
      final _file = File(_result);

      //read the generated file to check content
      final _input = _file.openRead();
      final _fields = await _input.transform(utf8.decoder).transform(CsvToListConverter()).toList();

      final _readResult = [
        _text.split('').map((t) => '$t,').toList(),
      ];

      expect(
        _fields,
        equals(_readResult),
      );
    });
  });
}
