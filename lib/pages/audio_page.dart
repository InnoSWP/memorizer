import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:memorizer/modules/tts_service.dart';
import 'package:memorizer/settings/constants.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../modules/stt_service.dart';

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
  late SttService sst;
  late TtsService tts;

  @override
  void initState() {
    super.initState();
    tts = TtsService();
    tts.init();
    sst = SttService(
        next: jumpToNextSentence,
        previous: jumpToPreviousSentence,
        play: playCurrentSentence,
        stop: stopPlaying);
  }

  @override
  void dispose() {
    super.dispose();
    tts.destroy();
  }

  Future continueToNextSentence() async {
    if (_currentSentenceIndex < widget.sentences.length - 1) {
      _currentSentenceIndex++;
      scrollToCurrentSentence();
      if (tts.isPlaying) {
        await playCurrentSentence();
      }
    } else {
      stopPlaying();
      _currentSentenceIndex = 0;
    }
  }

  Future jumpToNextSentence() async {
    bool wasPlaying = tts.isPlaying;
    if (wasPlaying) {
      sst.stop();
    }
    if (_currentSentenceIndex < widget.sentences.length - 1) {
      _currentSentenceIndex++;
      scrollToCurrentSentence();
    } else {
      stopPlaying();
      _currentSentenceIndex = 0;
    }
    if (wasPlaying) {
      await playCurrentSentence();
    }
  }

  Future jumpToPreviousSentence() async {
    bool wasPlaying = tts.isPlaying;
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
    scrollToCurrentSentence();
    await tts.play(widget.sentences[_currentSentenceIndex]);
    setState(() {});
    continueToNextSentence();
  }

  Future stopPlaying() async {
    await tts.stop();
    setState(() {});
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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: [
            FloatingActionButton.small(
              backgroundColor: kAppBarBackClr,
              foregroundColor: Colors.white,
              splashColor: Colors.yellow.shade700,
              onPressed: () {},
              child: const Icon(
                Icons.info_outline,
                size: 20,
              ),
            )
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: Colors.grey.shade700,
            ),
          ),
          backgroundColor: kAppBarBackClr,
          title: Text(
            'AUDIO PLAYER PAGE',
            style: TextStyle(color: kAppBarTextClr),
          ),
          centerTitle: true,
        ),
        body: Container(
          color: Colors.black,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 24),
            child: Column(
              children: [
                Expanded(
                  flex: 10,
                  child: Container(
                    //color: kGrey,
                    decoration: BoxDecoration(
                      color: kGrey,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.fromBorderSide(BorderSide(
                        color: Colors.grey.shade700,
                        width: 5,
                      )),
                      // gradient: kDarkGradientBackground,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
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
                ),
                Expanded(
                  flex: 2,
                  child: FloatingActionButton(
                    mini: false,
                    splashColor: Colors.yellow.shade700,
                    shape: CircleBorder(
                      side: BorderSide(
                        color: Colors.yellow.shade700,
                        width: 2,
                      ),
                    ),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.yellow.shade700,
                    onPressed: () => setState(() {
                      sst.listen();
                    }),
                    child: Icon(sst.isListening ? Icons.mic : Icons.mic_none),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                      // border: Border.fromBorderSide(BorderSide(
                      //   color: Colors.grey.shade700,
                      //   width: 2,
                      // )),
                      // gradient: kDarkGradientBackground,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all<Color>(
                              Colors.yellow.shade700,
                            ),
                            side: MaterialStateProperty.all<BorderSide>(
                                BorderSide(
                              width: 1.75,
                              color: Colors.grey.shade700,
                            )),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            )),
                          ),
                          onPressed: () {},
                          child: const Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                            size: 45,
                          ),
                        ),
                        OutlinedButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all<Color>(
                              Colors.yellow.shade700,
                            ),
                            side: MaterialStateProperty.all<BorderSide>(
                                BorderSide(
                              width: 1.75,
                              color: Colors.grey.shade700,
                            )),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            )),
                          ),
                          child: const Icon(
                            Icons.skip_previous,
                            color: Colors.white,
                            size: 45,
                          ),
                          onPressed: () {
                            setState(() {
                              jumpToPreviousSentence();
                            });
                          },
                        ),
                        OutlinedButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all<Color>(
                              Colors.yellow.shade700,
                            ),
                            side: MaterialStateProperty.all<BorderSide>(
                                BorderSide(
                              width: 1.75,
                              color: Colors.grey.shade700,
                            )),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            )),
                          ),
                          child: Icon(
                            tts.isStopped ? Icons.play_arrow : Icons.pause,
                            color: Colors.white,
                            size: 45,
                          ),
                          onPressed: () {
                            setState(() {
                              if (tts.isStopped) {
                                playCurrentSentence();
                              } else {
                                stopPlaying();
                              }
                            });
                          },
                        ),
                        OutlinedButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all<Color>(
                              Colors.yellow.shade700,
                            ),
                            side: MaterialStateProperty.all<BorderSide>(
                                BorderSide(
                              width: 1.75,
                              color: Colors.grey.shade700,
                            )),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            )),
                          ),
                          child: const Icon(
                            Icons.skip_next,
                            color: Colors.white,
                            size: 45,
                          ),
                          onPressed: () {
                            setState(() {
                              jumpToNextSentence();
                            });
                          },
                        ),
                        OutlinedButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all<Color>(
                                Colors.yellow.shade700,
                              ),
                              side: MaterialStateProperty.all<BorderSide>(
                                  BorderSide(
                                width: 1.75,
                                color: Colors.grey.shade700,
                              )),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              )),
                            ),
                            onPressed: () {},
                            child: const Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                              size: 45,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
