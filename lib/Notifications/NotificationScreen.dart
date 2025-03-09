import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_225/About/AboutScreen.dart';
import 'package:project_225/Account/AccountScreen.dart';
import 'package:project_225/Home/MapScreen.dart';
import 'package:project_225/models/user_model.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  String uid;
  NotificationScreen({super.key, required this.uid});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState(uid: uid);
}

class _NotificationScreenState extends State<NotificationScreen> {
  String uid;
  _NotificationScreenState({required this.uid});
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => MapScreen(uid: uid)));
      }
      if (index == 2) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AboutScreen(uid: uid)));
      }
      if (index == 3) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AccountScreen(uid: uid)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    double scrnwidth = MediaQuery.of(context).size.width;
    double scrnheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Text(
          "Notifications",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Consumer<UserModel>(builder: (context, userModel, child) {
        final userData = userModel.data;
        return SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.all(scrnwidth * 0.02),
              child: Text(userData.toString())),
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color.fromARGB(121, 34, 33, 33),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
            backgroundColor: Color.fromARGB(121, 34, 33, 33),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Help',
            backgroundColor: Color.fromARGB(121, 34, 33, 33),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp),
            label: 'Account',
            backgroundColor: Color.fromARGB(121, 34, 33, 33),
          ),
        ],
        currentIndex: 1,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
