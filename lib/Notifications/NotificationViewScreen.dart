import 'package:flutter/material.dart';
import 'package:project_225/models/user_model.dart';
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
  _NotificationviewscreenState({required this.notiData});
  @override
  Widget build(BuildContext context) {
    double scrnwidth = MediaQuery.of(context).size.width;
    double scrnheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                children: [
                  Text(userData.toString()),
                  Text("\n\n"),
                  Text(notiData.toString()),
                ],
              )),
        );
      }),
    );
  }
}
