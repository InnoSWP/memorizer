import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:memorizer/pages/audio_page.dart';
import 'package:memorizer/pages/input_page.dart';
import 'package:memorizer/settings/constants.dart' as clr;
import 'package:flutter/services.dart';

void main() {
  debugPaintSizeEnabled = false;
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.dark(),
            home: InputText(),
          )));
}
