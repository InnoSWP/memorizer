import 'package:flutter/material.dart';
import 'package:memorizer/widgets/buttons.dart';
import 'package:sizer/sizer.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double kAduioPlayerButtonHeight = 6.h;
    double kAduioPlayerButtonWidth = 16.w;
    var horizontalMargin = EdgeInsets.symmetric(horizontal: 3.w);
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 1.5.h,
        horizontal: 3.w,
      ),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Container(
                  margin: horizontalMargin,
                  child: FloatingActionButton(
                    heroTag: 'micro info',
                    mini: false,
                    onPressed: () {},
                    child: const Icon(Icons.mic),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Tap microphone to start a voice command',
                  ),
                ),
              ],
            ),
            Container(
              margin: horizontalMargin,
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Current voice commands:\n\u2022 Play!\n\u2022 Stop!\n\u2022 Repeat n times!\n\u2022 Next!\n\u2022 Previous!',
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: horizontalMargin,
                  child: MyButton(
                      height: kAduioPlayerButtonHeight,
                      width: kAduioPlayerButtonWidth,
                      iconData: Icons.skip_previous,
                      onPressed: () {}),
                ),
                const Expanded(
                  child: Text(
                    'Tap to go to the previous sentence',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: horizontalMargin,
                  child: MyButton(
                      height: kAduioPlayerButtonHeight,
                      width: kAduioPlayerButtonWidth,
                      iconData: Icons.play_arrow,
                      onPressed: () {}),
                ),
                const Expanded(
                  child: Text(
                    'Tap to start memorizing, tap once more to stop',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: horizontalMargin,
                  child: MyButton(
                      height: kAduioPlayerButtonHeight,
                      width: kAduioPlayerButtonWidth,
                      iconData: Icons.skip_next,
                      onPressed: () {}),
                ),
                const Expanded(
                  child: Text(
                    'Tap to go to the next sentence',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: horizontalMargin,
                  child: MyButton(
                    height: kAduioPlayerButtonHeight,
                    width: kAduioPlayerButtonWidth,
                    onPressed: () {},
                    iconData: Icons.repeat,
                    iconColor: Colors.white,
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Tap to repeat the current sentence',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
