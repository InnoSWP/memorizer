import 'package:flutter/material.dart';
import 'package:memorizer/pages/ScreenAudioPlayer.dart';
import 'package:memorizer/pages/ScreenInputText.dart';
import 'package:memorizer/settings/appColors.dart' as clr;

void main() => runApp(const MaterialApp(
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
    const InputText(),
    const AudioPlayerOur(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: clr.bnbBackClr,
          selectedItemColor: clr.bnbSelectedItemClr,
          unselectedItemColor: clr.bnbUnselectedItemClr,
          selectedFontSize: 12,
          unselectedFontSize: 9,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          currentIndex: menuCurrentIndex,
          onTap: (index) => setState(() => menuCurrentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: "Home",
              backgroundColor: clr.backClrBnbItem_1,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.audiotrack_outlined),
              label: "Audio",
              backgroundColor: clr.backClrBnbItem_2,
            ),
          ],
        ),
        appBar: AppBar(
          backgroundColor: clr.appBarBackClr,
          title: Text(["Input Page", "Audio Player Page"][menuCurrentIndex],
              style: TextStyle(color: clr.appBarTextClr)),
          centerTitle: true,
        ),
        body: IndexedStack(
          index: menuCurrentIndex,
          children: screens,
        ),
        drawer: const NavigationDrawer(),
      );
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        backgroundColor: clr.leftMenuClr,
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
        children: const [
          _leftMenuItem(icon: Icons.table_chart_sharp, text: 'Tasks'),
          _leftMenuItem(icon: Icons.star_rate, text: 'Achievements'),
          Divider(
            color: Colors.white,
            thickness: 1,
          ),
          _leftMenuItem(icon: Icons.settings, text: 'Settings'),
          _leftMenuItem(icon: Icons.notifications, text: 'Notifications'),
          Divider(
            color: Colors.white,
            thickness: 1,
          ),
          _leftMenuItem(icon: Icons.question_answer_rounded, text: 'Questions'),
          _leftMenuItem(icon: Icons.contact_phone, text: 'Contacts'),
          _leftMenuItem(icon: Icons.support, text: 'Support'),
        ],
      ),
    );
  }
}

class _leftMenuItem extends StatelessWidget {
  final String text;
  final IconData icon;

  const _leftMenuItem({required this.icon, required this.text, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: clr.leftMenuItemsClr,
      ),
      title: Text(
        text,
        style: TextStyle(color: clr.leftMenuItemsClr),
      ),
      onTap: () {},
    );
  }
}
