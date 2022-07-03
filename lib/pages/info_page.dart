import 'package:flutter/material.dart';
import 'package:memorizer/settings/constants.dart' as clr;
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
                    splashColor: clr.kOrangeAccent,
                    shape: const CircleBorder(
                      side: BorderSide(
                        color: clr.kOrangeAccent,
                        width: 2,
                      ),
                    ),
                    backgroundColor: Colors.black,
                    foregroundColor: clr.kOrangeAccent,
                    onPressed: () {},
                    child: const Icon(Icons.mic),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Tap microphone to start a voice command',
                    style: clr.kTextStyleDefault,
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
                    style: clr.kTextStyleDefault),
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
                Expanded(
                  child: Text('Tap to go to the previous sentence',
                      style: clr.kTextStyleDefault),
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
                Expanded(
                  child: Text('Tap to start memorizing, tap once more to stop',
                      style: clr.kTextStyleDefault),
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
                Expanded(
                  child: Text('Tap to go to the next sentence',
                      style: clr.kTextStyleDefault),
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
                Expanded(
                  child: Text('Tap to repeat the current sentence',
                      style: clr.kTextStyleDefault),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
