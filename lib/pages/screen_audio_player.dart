import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:memorizer/settings/constants.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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
  IconData playBtnIcon = Icons.play_arrow;
  late AudioPlayer _audioPlayer;

  //dsfdsfsderkjtherhterjkhtkehtrekrjtherjkt
  @override
  void initState() {
    super.initState();
    initAudio();
  }

  initAudio() {
    _audioPlayer = AudioPlayer();
//    _audioPlayer.load();
  }

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
    const url = 'assets/Welcome_Imlerith.mp3';
    _audioPlayer.setAsset(url);
    _audioPlayer.play();

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
                TextButton(
                  onPressed: () {},
                  child: const Icon(Icons.mic),
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
                    onPressed: () {},
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
}
