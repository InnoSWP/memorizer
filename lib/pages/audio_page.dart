import 'package:flutter/material.dart';
import 'package:memorizer/services/stt_service.dart';
import 'package:memorizer/services/tts_service.dart';
import 'package:memorizer/widgets/buttons.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../widgets/my_app_bar.dart';

class AudioPage extends StatefulWidget {
  final List<String> sentences;

  const AudioPage({required this.sentences, Key? key}) : super(key: key);

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  int _currentSentenceIndex = 0;

  // Audio player vars
  bool _isLooping = false;
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
      stop: stopPlaying,
      repeat: _triggerLoop,
    );
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
    _isLooping ? playCurrentSentence() : continueToNextSentence();
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

  void _speedDownOnPressed() {}

  void _skipPreviousOnPressed() {
    setState(() {
      jumpToPreviousSentence();
    });
  }

  void _playOnPressed() {
    setState(() {
      if (tts.isStopped) {
        playCurrentSentence();
      } else {
        stopPlaying();
      }
    });
  }

  void _skipNextOnPressed() {
    setState(() {
      jumpToNextSentence();
    });
  }

  void _speedUpOnPressed() {}

  void _triggerLoop() {
    setState(() {
      _isLooping = !_isLooping;
    });
    ;
  }

  @override
  Widget build(BuildContext context) {
    double kScreenHeight = MediaQuery.of(context).size.height;
    double kScreenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar:
            MyAppBar(context: context, input: "AUDIO PLAYER PAGE", actions: [
          FloatingActionButton.small(
            onPressed: () {},
            child: const Icon(
              Icons.info_outline,
              size: 18,
            ),
          )
        ]).get(),
        body: Column(
          children: [
            Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(8),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Theme.of(context).selectedRowColor
                    ),
                  ),
                  child: ScrollablePositionedList.builder(
                    itemCount: widget.sentences.length,
                    itemBuilder: (context, index) => Text(
                      widget.sentences[index],
                      style: index == _currentSentenceIndex
                          ?  Theme.of(context).textTheme.bodyText1
                          : Theme.of(context).textTheme.bodyText2,
                    ),
                    itemScrollController: _itemScrollController,
                    itemPositionsListener: _itemPositionsListener,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: MyButton(
                        height: kScreenHeight / 20,
                        width: kScreenWidth / 6,
                        onPressed: _triggerLoop,
                        iconData: Icons.loop,
                        // iconColor: _isLooping ? Colors.white : Colors.grey,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: kScreenHeight / 15,
                        width: kScreenWidth / 4,
                        child: FloatingActionButton(
                          heroTag: 'micro',
                          onPressed: () => setState(() {
                            sst.listen();
                          }),
                          child: Icon(
                              sst.isListening ? Icons.mic : Icons.mic_none),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyButton(
                        height: kScreenHeight / 20,
                        width: kScreenWidth / 6,
                        iconData: Icons.arrow_back_sharp,
                        onPressed: _speedDownOnPressed),
                    MyButton(
                        height: kScreenHeight / 20,
                        width: kScreenWidth / 6,
                        iconData: Icons.skip_next,
                        onPressed: _skipPreviousOnPressed),
                    MyButton(
                        height: kScreenHeight / 20,
                        width: kScreenWidth / 6,
                        iconData: tts.isStopped
                            ? Icons.play_arrow_outlined
                            : Icons.pause,
                        onPressed: _playOnPressed),
                    MyButton(
                        height: kScreenHeight / 20,
                        width: kScreenWidth / 6,
                        iconData: Icons.skip_previous,
                        onPressed: _skipNextOnPressed),
                    MyButton(
                        height: kScreenHeight / 20,
                        width: kScreenWidth / 6,
                        iconData: Icons.arrow_forward_sharp,
                        onPressed: _speedUpOnPressed),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
