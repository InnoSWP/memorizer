import 'package:flutter/material.dart';
import 'package:memorizer/pages/ScreenAudioPlayer.dart';
import 'package:memorizer/pages/ScreenInputText.dart';

void main() => runApp(MaterialApp(
      home: Application(),
    ));

class Application extends StatefulWidget {
  const Application({Key? key}) : super(key: key);

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  int menuCurrentIndex = 0;
  final screens = [
    InputText(),
    AudioPlayerOur(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedFontSize: 12,
          unselectedFontSize: 9,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.shifting,
          currentIndex: menuCurrentIndex,
          onTap: (index) => setState(() => menuCurrentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.audiotrack_outlined),
              label: "Audio",
              backgroundColor: Colors.green,
            ),
          ],
        ),
        appBar: AppBar(
          title:
              Text(menuCurrentIndex == 0 ? "Input Page" : "Audio Player Page"),
          centerTitle: true,
        ),
        body: IndexedStack(
          index: menuCurrentIndex,
          children: screens,
        ),
        drawer: NavigationDrawer(),
      );
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer();
}
