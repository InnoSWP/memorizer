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
          backgroundColor: menuCurrentIndex == 0 ? Colors.blue : Colors.green,
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
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );

  buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
    );
  }

  buildMenuItems(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.table_chart_sharp),
            title: const Text('Tasks'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.star_rate),
            title: const Text('Achievements'),
            onTap: () {},
          ),
          const Divider(
            thickness: 1,
            color: Colors.black54,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {},
          ),
          const Divider(
            thickness: 1,
            color: Colors.black54,
          ),
          ListTile(
            leading: const Icon(Icons.question_answer_rounded),
            title: const Text('Questions'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.contact_phone),
            title: const Text('Contacts'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.support),
            title: const Text('Support'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
