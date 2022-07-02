import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SttService {
  bool _isListening = false;
  final SpeechToText _sst = SpeechToText();
  List<String> _commands = [];
  bool _available = false;

  late VoidCallback next, previous, play, stop, repeat;

  bool get isListening => _isListening;

  SttService(
      {required this.next,
      required this.previous,
      required this.play,
      required this.stop,
      required this.repeat}) {
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
        _sst.listen(
            //pauseFor: Duration(seconds: 1),
            listenMode: ListenMode.confirmation,

            onResult: (val) =>
                _commands = val.recognizedWords.toLowerCase().split(' '));
      }
    } else {
      _stopListening();
    }
  }

  void _stopListening() {
    _isListening = false;
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
        repeat();
        if (kDebugMode) {
          print('repeat');
        }
      } else {
        // TODO - correctly handle a wrong voice command
        if (kDebugMode) {
          print('$_commands is not supported, please, try again...');
        }
      }
      if (kDebugMode) {
        print('commands: $_commands');
      }
    }
    _commands = [];
    _sst.stop();
  }
}
