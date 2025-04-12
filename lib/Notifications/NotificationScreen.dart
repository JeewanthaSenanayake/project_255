import 'package:flutter/material.dart';
import 'package:project_225/About/AboutScreen.dart';
import 'package:project_225/Account/AccountScreen.dart';
import 'package:project_225/Home/MapScreen.dart';
import 'package:project_225/Notifications/NotificationViewScreen.dart';
import 'package:project_225/models/user_model.dart';
import 'package:project_225/services/NotificationService.dart';
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
  bool isLoading = false;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => MapScreen(uid: uid)));
      }
      if (index == 2) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AboutScreen(uid: uid)));
      }
      if (index == 3) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AccountScreen(uid: uid)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double scrnwidth = MediaQuery.of(context).size.width;
    double scrnheight = MediaQuery.of(context).size.height;
    String getTimeDiff(dateDime) {
      DateTime createdAt = DateTime.parse(dateDime);
      Duration diff = DateTime.now().difference(createdAt);

      String timeAgo;
      String clock = '\u{1F552}';

      if (diff.inDays > 0) {
        timeAgo = "$clock ${diff.inDays}d";
      } else if (diff.inHours > 0) {
        timeAgo = "$clock ${diff.inHours}h";
      } else if (diff.inMinutes > 0) {
        timeAgo = "$clock ${diff.inMinutes}m";
      } else {
        timeAgo = "just now";
      }

      return timeAgo;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // backgroundColor: Colors.transparent,
        title: Text(
          "Notifications",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Consumer<UserModel>(
        builder: (context, userModel, child) {
          final userData = userModel.data;
          return SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.all(scrnwidth * 0.02),
                child:
                    // Text(userData.toString()),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       dynamic notiData = {
                    //         "title": "Sri Lanaka Won ICC ODI Word Cup",
                    //         "notificationId": "",
                    //         "imgUrl":
                    //             "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQDHgli3LTwwXzelzIQ3webW3ExIwDxilLPQ&s",
                    //       };
                    //       Navigator.of(context).push(MaterialPageRoute(
                    //           builder: (context) =>
                    //               Notificationviewscreen(notiData: notiData)));
                    //     },
                    //     child: Text("Open")),
                    FutureBuilder(
                  future: NotificationService().fetchDataNotification(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Image.asset(
                          "assets/loading.gif",
                          width: scrnwidth * 0.2,
                        ),
                      ); // Show loading spinner
                    } else if (snapshot.hasError) {
                      return Text(
                          'Error: ${snapshot.error}'); // Show error message
                    } else if (snapshot.hasData) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (dynamic notification in snapshot.data)
                            InkWell(
                              onTap: () async {},
                              child: Container(
                                margin:
                                    EdgeInsets.only(bottom: scrnheight * 0.02),
                                padding: EdgeInsets.all(scrnheight * 0.01),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      offset: Offset(5, 5),
                                      blurRadius: 10,
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.9),
                                      offset: Offset(-5, -5),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        child: (snapshot.data.length != 0
                                            ? FadeInImage(
                                                placeholder: const AssetImage(
                                                    'assets/loadingMan.png'),
                                                image: NetworkImage(
                                                    "${notification["imgUrl"]}"),
                                                imageErrorBuilder: (context,
                                                    error, stackTrace) {
                                                  return Image.asset(
                                                      'assets/loadingMan.png',
                                                      width: scrnwidth * 0.3,
                                                      height: scrnwidth * 0.175,
                                                      fit: BoxFit.cover);
                                                },
                                                width: scrnwidth * 0.3,
                                                height: scrnwidth * 0.175,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                'assets/loadingMan.png',
                                                width: scrnwidth * 0.3,
                                                height: scrnwidth * 0.175,
                                                fit: BoxFit.cover,
                                              ))),
                                    Container(
                                      height: scrnwidth * 0.175,
                                      width: scrnwidth * 0.6,
                                      child: Column(
                                        children: [
                                          Container(
                                            width: scrnwidth * 0.5,
                                            margin: EdgeInsets.only(
                                                left: scrnwidth * 0.02),
                                            child: Text(
                                              notification["title"].toString(),
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: scrnwidth * 0.05),
                                            ),
                                          ),
                                          Spacer(),
                                          Align(
                                              alignment: Alignment.bottomRight,
                                              child: Text(
                                                getTimeDiff(
                                                    notification["created_at"]),
                                                textAlign: TextAlign.right,
                                              ))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ); // Show the data
                    } else {
                      return Text('No data found');
                    }
                  },
                )),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        currentIndex: 1,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
