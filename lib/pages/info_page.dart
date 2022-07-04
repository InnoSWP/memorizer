import 'package:flutter/material.dart';
import 'package:memorizer/widgets/buttons.dart';
import 'package:sizer/sizer.dart';

class InfoPage extends StatelessWidget {
  InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double kAduioPlayerButtonHeight = 6.h;
    double kAduioPlayerButtonWidth = 16.w;
    var infoTextStyle = TextStyle(
        fontSize: 15.sp,);
    var horizontalMargin = EdgeInsets.symmetric(horizontal: 3.w);
    var paddingVar = EdgeInsets.symmetric(vertical: 0.8.h);
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.sp),
            topRight: Radius.circular(15.sp),
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 1.5.h,
          horizontal: 3.w,
        ),
        child: Wrap(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: paddingVar,
              child: Row(
                children: [
                  Container(
                    margin: horizontalMargin,
                    height: 8.h,
                    width: 12.w,
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
                      style: infoTextStyle,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              margin: horizontalMargin,
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Current voice commands:\n\u2022 Play!\n\u2022 Stop!\n\u2022 Repeat n times (each)!\n\u2022 Repeat infinitely/off\n\u2022 Next!\n\u2022 Previous!',
                  style: infoTextStyle,
                ),
              ),
            ),
            Padding(
              padding: paddingVar,
              child: Row(
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
                    child: Text(
                      'Tap to go to the previous sentence',
                      style: infoTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: paddingVar,
              child: Row(
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
                    child: Text(
                      'Tap to start memorizing, tap once more to stop',
                      style: infoTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: paddingVar,
              child: Row(
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
                    child: Text(
                      'Tap to go to the next sentence',
                      style: infoTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: paddingVar,
              child: Row(
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
                    child: Text(
                      'Tap to repeat the current sentence\nLong press to enter repeat settings',
                      style: infoTextStyle,
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
