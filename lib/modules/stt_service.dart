import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SttService {
  bool _isListening = false;
  final SpeechToText _sst = SpeechToText();
  List<String> _commands = [];
  bool _available = false;

  late VoidCallback next, previous, play, stop, repeat;


  bool get isListening => _isListening;


  SttService({required this.next, required this.previous, required this.play, required this.stop}) {
    init();
  }

  void init() async {
    _available = await _sst.initialize(
      onStatus: (val) {
        if (val == 'done') {
          _stopListening();
        }
      },
      onError: (val) => print('onError: $val'),
    );
  }

  void listen() async {
    if (!_isListening) {
      if (_available) {
        _isListening = true;
        _sst.listen(
            onResult:
                (val) => _commands = val.recognizedWords.toLowerCase().split(' ')
        );
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
          print('next');
        } else if (_commands.contains('previous')) {
          previous();
        } else if (_commands.contains('play')) {
          play();
        } else if (_commands.contains('pause')) {
          // TODO - stop spelling sentences.
          // If user calls 'play' command again,
          // it should continue from the current sentence
          stop();
        } else if (_commands.contains('stop')) {
          // TODO - stop spelling sentences and set currentSentence to 0.
          stop();
        } else if (_commands.contains('repeat')) {
          // TODO - add repeat functionality
          repeat();
        } else {
          // TODO - correctly handle a wrong voice command
          print('$_commands is not supported, please, try again...');
        }
      }
    _commands = [];
    _sst.stop();
  }
}