import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:project_225/Account/AccountScreen.dart';
import 'package:project_225/Home/MapScreen.dart';
import 'package:project_225/MenberList/member_list.dart';
import 'package:project_225/Notifications/notification_screen.dart';

class CommanWidgets {
  BuildContext context;
  String uid;
  CommanWidgets(this.context, this.uid);

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MapScreen(uid: uid)));
    } else if (index == 2) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NotificationScreen(uid: uid)));
    } else if (index == 1) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MemberList(uid: uid)));
    } else if (index == 3) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AccountScreen(uid: uid)));
    }
  }

  Widget footerWidgets(int currentIndex) {
    print(currentIndex);
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: currentIndex != 0 ? Color.fromRGBO(128, 128, 128, 1) : null,
          ),
          label: 'Home',
          backgroundColor: Colors.white,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.people_alt,
            color: currentIndex != 1 ? Color.fromRGBO(128, 128, 128, 1) : null,
          ),
          label: 'Members',
          backgroundColor: Colors.white,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.notifications,
            color: currentIndex != 2 ? Color.fromRGBO(128, 128, 128, 1) : null,
          ),
          label: 'Notifications',
          backgroundColor: Colors.white,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.account_circle_sharp,
            color: currentIndex != 3 ? Color.fromRGBO(128, 128, 128, 1) : null,
          ),
          label: 'Account',
          backgroundColor: Colors.white,
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.black,
      onTap: _onItemTapped,
    );
  }

  void showPopUp(int id) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            children: [
              Spacer(),
              Row(
                children: [
                  Spacer(),
                  IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape
                              .circle, 
                        ),
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                        ),
                      ))
                ],
              ),
              Image.asset(
                id == 0 ? "assets/home_guide.png" : "assets/district_guide.png",
                // width: scrnwidth * 0.4,
              ),
              Spacer(),
            ],
          ),
        );
      },
    );
  }
}
