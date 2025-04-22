import 'package:flutter/material.dart';
import 'package:project_225/Home/MemberProfile.dart';
import 'package:project_225/models/user_model.dart';
import 'package:project_225/services/MapAndStatsService.dart';
import 'package:project_225/services/NotificationService.dart';
import 'package:provider/provider.dart';

class Notificationviewscreen extends StatefulWidget {
  dynamic notiData;
  Notificationviewscreen({super.key, required this.notiData});

  @override
  State<Notificationviewscreen> createState() =>
      _NotificationviewscreenState(notiData: notiData);
}

class _NotificationviewscreenState extends State<Notificationviewscreen> {
  dynamic notiData;
  bool isLoading = false;
  _NotificationviewscreenState({required this.notiData});

  @override
  Widget build(BuildContext context) {
    double scrnwidth = MediaQuery.of(context).size.width;
    double scrnheight = MediaQuery.of(context).size.height;
    // dynamic notificationData = {
    //   "memberId":
    //       "225-2024-dcabf16f-7141-4482-a6e8-e8a8bbc82d2c-1733073478.4179246",
    //   "body":
    //       "The Sri Lanka cricket team has reached the World Cup final three times. Winning in 1996 under the leadership of Arjuna Ranatunga and finishing as runners-up in the 2007 & 2011 World Cups.\nSri Lanka has also reached the Semi Final at the 2003 World Cup and the Quarter Final at the 2015 World Cup.",
    // };
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        // backgroundColor: Colors.transparent,
        title: Text(
          "Notifications",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Consumer<UserModel>(builder: (context, userModel, child) {
        final userData = userModel.data;
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(scrnwidth * 0.02),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: scrnwidth * 0.9,
                    margin: EdgeInsets.only(bottom: scrnheight * 0.025),
                    // height: scrnwidth * 0.1,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: FadeInImage(
                        placeholder: const AssetImage('assets/loadingMan.png'),
                        image: NetworkImage(notiData['imgUrl']),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/loadingMan.png',
                              fit: BoxFit.cover);
                        },
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Text(
                  notiData['title'].toString(),
                  style: TextStyle(
                      color: const Color.fromARGB(167, 0, 0, 0),
                      fontSize: scrnwidth * 0.055),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: notiData.containsKey("body")
                        ? Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.all(scrnwidth * 0.04),
                                  child: Text(
                                    notiData['body'],
                                    textAlign: TextAlign.left,
                                  )),
                              ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    dynamic data = null;
                                    data = await MapAndStats()
                                        .getMemberById(notiData['memberId']);
                                    if (data != null) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MemberProfile(
                                                      uid: userModel.userId,
                                                      data: data)));
                                      setState(() {
                                        isLoading = false;
                                      });
                                    } else {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  },
                                  child: Text("Add Comment")),
                            ],
                          )
                        : FutureBuilder(
                            future: NotificationService().getNotificationById(
                                notiData["notificationId"]),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
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
                                  children: [
                                    Container(
                                        margin:
                                            EdgeInsets.all(scrnwidth * 0.04),
                                        child: Text(
                                          snapshot.data['body'],
                                          textAlign: TextAlign.left,
                                        )),
                                    ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            isLoading = true;
                                          });

                                          dynamic data = null;
                                          data = await MapAndStats()
                                              .getMemberById(
                                                  snapshot.data['memberId']);
                                          if (data != null) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MemberProfile(
                                                            uid: userModel
                                                                .userId,
                                                            data: data)));
                                            setState(() {
                                              isLoading = false;
                                            });
                                          } else {
                                            setState(() {
                                              isLoading = false;
                                            });
                                          }
                                        },
                                        child: Text("Add Comment")),
                                  ],
                                );
                              } else {
                                return Text('No data found');
                              }
                            })),
              ],
            ),
          ),
        );
      }),
    );
  }
}
