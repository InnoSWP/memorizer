import 'package:flutter/material.dart';
import 'package:memorizer/pages/ScreenAudioPlayer.dart';
import 'package:memorizer/pages/ScreenInputText.dart';
import 'package:memorizer/settings/appColors.dart' as clr;

void main() => runApp(const MaterialApp(
      home: Application(),
    ));

//////TEXT TEXT

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
          title: Text(
            menuCurrentIndex == 0 ? "Input Page" : "Audio Player Page",
            style: const TextStyle(color: Colors.white),
          ),
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
        children: [
          ListTile(
            leading: Icon(
              Icons.table_chart_sharp,
              color: clr.leftMenuItemsClr,
            ),
            title: Text(
              'Tasks',
              style: TextStyle(color: clr.leftMenuItemsClr),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.star_rate,
              color: clr.leftMenuItemsClr,
            ),
            title: Text(
              'Achievements',
              style: TextStyle(color: clr.leftMenuItemsClr),
            ),
            onTap: () {},
          ),
          const Divider(
            thickness: 1,
            color: Colors.black54,
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: clr.leftMenuItemsClr,
            ),
            title: Text(
              'Settings',
              style: TextStyle(color: clr.leftMenuItemsClr),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.notifications,
              color: clr.leftMenuItemsClr,
            ),
            title: Text(
              'Notifications',
              style: TextStyle(color: clr.leftMenuItemsClr),
            ),
            onTap: () {},
          ),
          const Divider(
            thickness: 1,
            color: Colors.black54,
          ),
          ListTile(
            leading: Icon(
              Icons.question_answer_rounded,
              color: clr.leftMenuItemsClr,
            ),
            title: Text(
              'Questions',
              style: TextStyle(color: clr.leftMenuItemsClr),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.contact_phone,
              color: clr.leftMenuItemsClr,
            ),
            title: Text(
              'Contacts',
              style: TextStyle(color: clr.leftMenuItemsClr),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.support,
              color: clr.leftMenuItemsClr,
            ),
            title: Text(
              'Support',
              style: TextStyle(color: clr.leftMenuItemsClr),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
