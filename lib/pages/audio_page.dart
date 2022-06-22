import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart' as tts;
import 'package:memorizer/settings/constants.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

enum TtsState { playing, stopped }

class AudioPage extends StatefulWidget {

  final List<String> sentences;

  AudioPage({required this.sentences, Key? key}) : super(key: key);

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {

  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  int _currentSentenceIndex = 0;

  // Audio player vars
  bool isLoop = false;
  IconData playBtnIcon = Icons.play_arrow;
  late tts.FlutterTts _flutterTts;
  late bool _finishedText;
  TtsState ttsState = TtsState.stopped;

  @override
  void initState() {
    super.initState();
    _finishedText = false;
    _speechToText = stt.SpeechToText();
    _flutterTts = tts.FlutterTts();
    _setflutterTts();
  }

  Future _setflutterTts() async {
    await _flutterTts.awaitSpeakCompletion(true);
    await _flutterTts.setLanguage('en-US');
  }

  late stt.SpeechToText _speechToText;
  bool _isListening = false;
  List<String> _command = ['Say', 'a', 'command'];

  Future continueToNextSentence() async {
    if (_currentSentenceIndex < widget.sentences.length - 1) {
      _currentSentenceIndex++;
      scrollToCurrentSentence();
      if (ttsState == TtsState.playing) {
        await playCurrentSentence();
      }
    } else {
      _finishedText = true;
    }
  }

  Future jumpToNextSentence() async {
    bool wasPlaying = ttsState == TtsState.playing;
    if (wasPlaying) {
      stopPlaying();
    }
    if (_currentSentenceIndex < widget.sentences.length - 1) {
      _currentSentenceIndex++;
      scrollToCurrentSentence();
    } else {
      _finishedText = true;
    }
    if (wasPlaying) {
      await playCurrentSentence();
    }
  }

  Future jumpToPreviousSentence() async {
    bool wasPlaying = ttsState == TtsState.playing;
    if (wasPlaying) {
      stopPlaying();
    }
    if (_currentSentenceIndex > 0) {
      _currentSentenceIndex--;
      scrollToCurrentSentence();
    }
    if (wasPlaying) {
      await playCurrentSentence();
    }
  }

  Future playCurrentSentence() async {
    // print('palying ${_currentSentenceIndex}');
    scrollToCurrentSentence();
    setState(() => ttsState = TtsState.playing);
    await _flutterTts.speak(widget.sentences[_currentSentenceIndex]);
    continueToNextSentence();
  }

  Future stopPlaying() async {
    setState(() => ttsState = TtsState.stopped);
    await _flutterTts.stop();
  }

  void scrollToCurrentSentence() {
    setState(() {
      _itemScrollController.scrollTo(
        index: _currentSentenceIndex,
        duration: const Duration(
          // TODO - might be a good idea to make the animation duration a constant
          milliseconds: 500,
        ),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kAppBarBackClr,
        title: Text('AUDIO PLAYER PAGE', style: TextStyle(color: kAppBarTextClr),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: kDarkGradientBackground,
                ),
                child: ScrollablePositionedList.builder(
                  itemCount: widget.sentences.length,
                  itemBuilder: (context, index) => Text(
                    widget.sentences[index],
                    style: index == _currentSentenceIndex
                        ? kTextStyleSelected
                        : kTextStyleMain,
                  ),
                  itemScrollController: _itemScrollController,
                  itemPositionsListener: _itemPositionsListener,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: _listen,
                    child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Icon(Icons.info_outlined),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: kDarkGradientBackground,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        // TODO: set functionality for loop
                      },
                      child: const Icon(Icons.repeat),
                    ),
                    TextButton(
                      child: const Icon(Icons.skip_previous),
                      onPressed: () {
                        setState(() {
                          jumpToPreviousSentence();
                        });
                      },
                    ),
                    TextButton(
                      child: Icon(ttsState == TtsState.stopped
                          ? Icons.play_arrow
                          : Icons.pause),
                      onPressed: () {
                        setState(() {
                          if (ttsState == TtsState.stopped) {
                            playCurrentSentence();
                          } else {
                            stopPlaying();
                          }
                        });
                      },
                    ),
                    TextButton(
                      child: const Icon(Icons.skip_next),
                      onPressed: () {
                        setState(() {
                          jumpToNextSentence();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (val) {
          if (kDebugMode) {
            print('onStatus: $val');
          }
          if (val == 'done') {
            _stopListening();
          }
        },
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(
            onResult: (val) => setState(() {
                  _command = val.recognizedWords.toLowerCase().split(' ');
                }));
      }
    } else {
      _stopListening();
    }
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
      if (_command.isNotEmpty) {
        if (_command.contains('next')) {
          jumpToNextSentence();
        } else if (_command.contains('previous')) {
          jumpToPreviousSentence();
        } else if (_command.contains('play')) {
          playCurrentSentence();
        }
        else if (_command.contains('pause')) {
          // TODO - stop spelling sentences.
          // If user calls 'play' command again,
          // it should continue from the current sentence
        }
        else if (_command.contains('stop')) {
          // TODO - stop spelling sentences and set currentSentence to 0.
        }
        else if (_command.contains('repeat')) {
          // TODO - add repeat functionality
        }
        else {
          // TODO - correctly handle a wrong voice command
          print('$_command is not supported, please, try again...');
        }
      }
    });
    _command = [];
    _speechToText.stop();
  }

  @override
  void dispose() {
    super.dispose();
    _flutterTts.stop();
  }
}
