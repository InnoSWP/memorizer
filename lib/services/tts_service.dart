import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';


enum TtsState { playing, stopped }

class TtsService {
  late FlutterTts _flutterTts;
  TtsState state = TtsState.stopped;

  bool get isPlaying => state == TtsState.playing;
  bool get isStopped => state == TtsState.stopped;


  void init() async {
    _flutterTts = FlutterTts();
    await _flutterTts.awaitSpeakCompletion(true);
    await _flutterTts.setLanguage('en-US');
  }

  Future play(String sentence) async {
    state = TtsState.playing;
    await _flutterTts.speak(sentence);
    if (kDebugMode) {
      print('finished speaking');
    }
  }

  Future stop() async {
    state = TtsState.stopped;
    await _flutterTts.stop();
  }

  void destroy(){
    _flutterTts.stop();
  }
}