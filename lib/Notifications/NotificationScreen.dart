import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  dynamic NotificationList = [];
  String lastDoc = "";
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  final int _pageSize = 10;

  Future<void> getNotificationList() async {
    setState(() {
      isLoading = true;
    });
    final notiData = await NotificationService().getByPeganition(_pageSize, "");
    NotificationList = notiData["data"];
    if (NotificationList.length > 0) {
      lastDoc = notiData["lastDocId"];
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _refreshPage() async {
    final notiData = await NotificationService().getByPeganition(_pageSize, "");
    NotificationList = notiData["data"];
    lastDoc = notiData["lastDocId"];
    _scrollController.addListener(_scrollListener);

    setState(() {});
  }

  Future<void> getPeganitionNotification() async {
    setState(() => _isLoading = true);
    final notiData =
        await NotificationService().getByPeganition(_pageSize, lastDoc);
    if (notiData["lastDocId"] == null) {
      _scrollController.removeListener(_scrollListener);
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        lastDoc = notiData["lastDocId"];
        NotificationList.addAll(notiData["data"]);
        _isLoading = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading) {
      getPeganitionNotification();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotificationList();

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

      if (diff.inDays >= 365) {
        timeAgo = DateFormat('MMM d, y').format(createdAt);
      } else if (diff.inDays > 7 && diff.inDays < 365) {
        timeAgo = DateFormat('MMM d').format(createdAt);
      } else if (diff.inDays > 0 && diff.inDays <= 7) {
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
      body: RefreshIndicator(
          onRefresh: _refreshPage,
          color: Colors.red[900],
          child: isLoading
              ? Center(
                  child: Image.asset(
                    "assets/loading.gif",
                    width: scrnwidth * 0.2,
                  ),
                )
              : NotificationList.length > 0
                  ? ListView.builder(
                      controller: _scrollController,
                      itemCount: NotificationList.length,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (index <= NotificationList.length) {
                          final notification = NotificationList[index];
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Notificationviewscreen(
                                      notiData: notification)));
                            },
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
                                  FadeInImage(
                                    placeholder: const AssetImage(
                                        'assets/loadingMan.png'),
                                    image: NetworkImage(
                                        "${notification["imgUrl"]}"),
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                          'assets/loadingMan.png',
                                          width: scrnwidth * 0.3,
                                          height: scrnwidth * 0.175,
                                          fit: BoxFit.cover);
                                    },
                                    width: scrnwidth * 0.3,
                                    height: scrnwidth * 0.175,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(
                                    height: scrnwidth * 0.175,
                                    width: scrnwidth * 0.6,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: scrnwidth * 0.6,
                                          padding: EdgeInsets.only(
                                              left: scrnwidth * 0.0175),
                                          child: Text(
                                            notification["title"].toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: scrnwidth * 0.035),
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
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      })
                  : Center(child: Text("No Notifications"))),
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
