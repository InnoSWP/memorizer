import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:memorizer/settings/constants.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class AudioPlayerOur extends StatefulWidget {
  const AudioPlayerOur({Key? key}) : super(key: key);

  @override
  State<AudioPlayerOur> createState() => _AudioPlayerOurState();
}

class _AudioPlayerOurState extends State<AudioPlayerOur> {
  // TODO - This list should contain the sentences that are received from IExtractAPI
  final List<String> _sentences = [
    'The door to the parlor opened and Mildred stood there looking in at them, looking at Beatty and then at Montag.',
    '''Behind her the walls of
the room were flooded with green and yellow and orange fireworks
sizzling and bursting to some music composed almost completely of
trap drums, tom-toms, and cymbals.''',
    '''Her mouth moved and she was
saying something but the sound covered it.''',
    '''Beatty knocked his pipe into the palm of his pink hand, studied
the ashes as if they were a symbol to be diagnosed and searched for
meaning.''',
    '''You must understand that our civilization is so vast that we can't
have our minorities upset and stirred.''',
    '''Ask yourself, What do we want
in this country, above all?''',
  ];

  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  int _currentSentenceIndex = 0;

  void nextSentence() {
    if (_currentSentenceIndex != _sentences.length - 1) {
      _currentSentenceIndex++;
    }
    playCurrentSentence();
  }

  void previousSentence() {
    if (_currentSentenceIndex != 0) {
      _currentSentenceIndex--;
    }
    playCurrentSentence();
  }

  // TODO - This method should play current sentence using TTS package
  // TODO - might be a good idea to make the animation duration a constant
  void playCurrentSentence() {
    _itemScrollController.scrollTo(
      index: _currentSentenceIndex,
      duration: const Duration(milliseconds: 500,),
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
                        if (kDebugMode) {
                          print(_currentSentenceIndex);
                        }
                      });
                    },
                    child: const Icon(Icons.skip_previous),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        playCurrentSentence();
                        if (kDebugMode) {
                          print(_currentSentenceIndex);
                        }
                      });
                    },
                    child: const Icon(Icons.play_arrow_outlined),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        nextSentence();
                        if (kDebugMode) {
                          print(_currentSentenceIndex);
                        }
                      });
                    },
                    child: const Icon(Icons.skip_next),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
