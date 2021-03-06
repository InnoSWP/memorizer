import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SttService {
  bool _isListening = false;
  final SpeechToText _sst = SpeechToText();
  List<String> _commands = [];
  bool _available = false;
  Map<String, int> convertToNumber = {
    'infinitely': -1,
    'inifnity': -1,
    'off': 1,
    'zero': 1,
    'one': 1,
    'once': 1,
    'two': 2,
    'twice': 2,
    'three': 3,
    'four': 4,
    'five': 5,
    'six': 6,
    'seven': 7,
    'eight': 8,
    'nine': 9,
    'ten': 10,
  };

  late VoidCallback next, previous, play, stop, error;
  late Function(int, bool) repeat;

  bool get isListening => _isListening;

  SttService({
    required this.next,
    required this.previous,
    required this.play,
    required this.stop,
    required this.repeat,
    required this.error,
  }) {
    init();
  }

  void init() async {
    _available = await _sst.initialize(
      onStatus: (val) {
        if (val == 'done') {
          _stopListening();
        }
      },
      onError: (val) => kDebugMode ? print('onError: $val') : init(),
    );
    if (kDebugMode) {
      print('available: $_available');
    }
  }

  void listen() async {
    if (!_isListening) {
      if (_available) {
        _isListening = true;
        if (kDebugMode) {
          print('start listening');
        }
        _sst.listen(
            //pauseFor: Duration(seconds: 1),
            listenMode: ListenMode.confirmation,
            onResult: (val) =>
                _commands = val.recognizedWords.toLowerCase().split(' '));
      }
    } else {
      await _stopListening();
    }
  }

  Future<void> _stopListening() async {
    _isListening = false;
    if (kDebugMode) {
      print('stop listening');
    }
    if (_commands.isNotEmpty) {
      if (_commands.contains('next')) {
        next();
        if (kDebugMode) {
          print('next');
        }
      } else if (_commands.contains('previous')) {
        previous();
        if (kDebugMode) {
          print('previous');
        }
      } else if (_commands.contains('play')) {
        play();
        if (kDebugMode) {
          print('play');
        }
      } else if (_commands.contains('pause')) {
        // TODO - stop spelling sentences.
        // If user calls 'play' command again,
        // it should continue from the current sentence
        stop();
        if (kDebugMode) {
          print('pause');
        }
      } else if (_commands.contains('stop')) {
        // TODO - stop spelling sentences and set currentSentence to 0.
        stop();
        if (kDebugMode) {
          print('stop');
        }
      } else if (_commands.contains('repeat')) {
        // TODO - add repeat functionality
        bool repeatForAll = false;
        if (_commands.contains('every') || _commands.contains('each')) {
          repeatForAll = true;
        } else {
          repeatForAll = false;
        }
        print('repeatForAll: $repeatForAll');
        String numberStr = _commands[_commands.indexOf('repeat') + 1];
        print(numberStr);
        int? times = int.tryParse(numberStr);
        print(times);
        if (times == null) {
          print(convertToNumber.containsKey(numberStr));
          if (convertToNumber.containsKey(numberStr)) {
            times = convertToNumber[numberStr];
          } else {
            if (kDebugMode) {
              print(
                  'Not correct repeat number: ${_commands[_commands.indexOf('repeat') + 1]}');
            }
            error();
            await _sst.stop();
          }
        }
        repeat(times!, repeatForAll);
        if (kDebugMode) {
          print('repeat: $times times');
        }
      } else {
        // TODO - correctly handle a wrong voice command
        error();
        if (kDebugMode) {
          print('$_commands is not supported, please, try again...');
        }
        //_sst.stop();
      }
      if (kDebugMode) {
        print('commands: $_commands');
      }
    }
    _commands = [];
    await _sst.stop();
    if (kDebugMode) {
      print('STOPPED');
      print('isListening: $_isListening');
    }
  }
}
