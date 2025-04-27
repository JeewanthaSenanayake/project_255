import 'package:flutter/material.dart';
import 'package:project_225/About/AboutScreen.dart';
import 'package:project_225/Account/AccountScreen.dart';
import 'package:project_225/Home/MapScreen.dart';
import 'package:project_225/Notifications/NotificationScreen.dart';

class CommanWidgets {
  BuildContext context;
  String uid;
  CommanWidgets(this.context, this.uid);

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MapScreen(uid: uid)));
    } else if (index == 1) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NotificationScreen(uid: uid)));
    } else if (index == 2) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => AboutScreen(uid: uid)));
    } else if (index == 3) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AccountScreen(uid: uid)));
    }
  }

  Widget footerWidgets(int currentIndex) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Colors.grey,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notifications',
          backgroundColor: Colors.grey,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.help),
          label: 'Help',
          backgroundColor: Colors.grey,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_sharp),
          label: 'Account',
          backgroundColor: Colors.grey,
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }
}
