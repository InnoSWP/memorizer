import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:memorizer/settings/constants.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AudioPlayerOur extends StatefulWidget {
  const AudioPlayerOur({Key? key}) : super(key: key);

  @override
  State<AudioPlayerOur> createState() => _AudioPlayerOurState();
}

class _AudioPlayerOurState extends State<AudioPlayerOur> {
  // TODO - This list should contain the sentences that are received from IExtractAPI
  final List<String> _sentences = sentencesConst;

  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  int _currentSentenceIndex = 0;

  //Audio player vars
  bool isPlayingAudio = false;
  bool isLoop = false;
  IconData playBtnIcon = Icons.play_arrow;
  AudioPlayer? audioPlayer;
  final String path = "assets/Welcome_Imlerith.mp3";

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer?.setAsset(path);
    _speechToText = stt.SpeechToText();
  }

  late stt.SpeechToText _speechToText;
  bool _isListening = false;
  String _command = 'Say a command';

  void nextSentence() {
    if (_currentSentenceIndex != _sentences.length - 1) _currentSentenceIndex++;

    playCurrentSentence();
  }

  void previousSentence() {
    if (_currentSentenceIndex != 0) _currentSentenceIndex--;

    playCurrentSentence();
  }

  // TODO - This method should play current sentence using TTS package
  // TODO - might be a good idea to make the animation duration a constant
  void playCurrentSentence() {
    if (isPlayingAudio) {
      audioPlayer?.play();
    } else {
      audioPlayer?.pause();
    }

    _itemScrollController.scrollTo(
      index: _currentSentenceIndex,
      duration: const Duration(
        milliseconds: 500,
      ),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 10,
            child: Container(
              decoration: const BoxDecoration(
                gradient: kDarkGradientBackground,
              ),
              child: ScrollablePositionedList.builder(
                itemCount: _sentences.length,
                itemBuilder: (context, index) => Text(
                  _sentences[index],
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
                      setState(() {
                        if (isLoop == false) {
                          audioPlayer?.setLoopMode(LoopMode.one);
                        } else {
                          audioPlayer?.setLoopMode(LoopMode.off);
                        }
                      });
                    },
                    child: const Icon(Icons.repeat),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        previousSentence();
                      });
                    },
                    child: const Icon(Icons.skip_previous),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        if (isPlayingAudio) {
                          isPlayingAudio = false;
                          playBtnIcon = Icons.play_arrow;
                        } else {
                          isPlayingAudio = true;
                          playBtnIcon = Icons.pause;
                        }
                        playCurrentSentence();
                      });
                    },
                    child: Icon(playBtnIcon),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        nextSentence();
                      });
                    },
                    child: const Icon(Icons.skip_next),
                  ),
                ],

                /////dsfsdfsdf
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (val) {
          print('onStatus: $val');
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
                  _command = val.recognizedWords;
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
        if (_command == 'next') {
          nextSentence();
        }
        else if (_command == 'previous') {
          previousSentence();
        }
        else if (_command == 'play') {
          playCurrentSentence();
        }
      }
    });
    _speechToText.stop();
  }
}
