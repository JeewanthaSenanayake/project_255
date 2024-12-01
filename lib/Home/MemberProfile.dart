import 'package:flutter/material.dart';

class MemberProfile extends StatefulWidget {
  String uid;
  dynamic data;
  MemberProfile({super.key, required this.uid, required this.data});

  @override
  State<MemberProfile> createState() =>
      _MemberProfileState(uid: uid, data: data);
}

class _MemberProfileState extends State<MemberProfile> {
  String uid;
  dynamic data;
  _MemberProfileState({required this.uid, required this.data});
  @override
  Widget build(BuildContext context) {
    double scrnwidth = MediaQuery.of(context).size.width;
    double scrnheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.amber),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.only(
                  left: scrnwidth * 0.03, right: scrnwidth * 0.03),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: ClipOval(
                          child: (data['imgUrl'] != null
                              ? FadeInImage(
                                  placeholder:
                                      const AssetImage('assets/loadingMan.png'),
                                  image: NetworkImage("${data['imgUrl']}"),
                                  width: scrnwidth * 0.5,
                                  height: scrnwidth * 0.5,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/loadingMan.png',
                                  width: scrnwidth * 0.5,
                                  height: scrnwidth * 0.5,
                                  fit: BoxFit.cover,
                                ))),
                    ),
                    SizedBox(
                      height: scrnheight * 0.01,
                    ),
                    Text(
                      data["name"],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.amber, fontSize: scrnwidth * 0.07),
                    ),
                    Text(
                      data["fname"],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.amberAccent,
                          fontSize: scrnwidth * 0.04),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: scrnheight * 0.02),
                      width: scrnwidth, // Total width of the bar
                      height: scrnheight * 0.015, // Height of the bar
                      child: Stack(
                        children: [
                          // Background (red color)
                          Container(
                            decoration: BoxDecoration(
                              color: data['percentage'] != 0
                                  ? const Color.fromARGB(255, 255, 17, 0)
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          // Foreground (green color)
                          FractionallySizedBox(
                            widthFactor: data['percentage'] /
                                100, // Calculate width based on percentage
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 0, 255, 8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(data.toString())
                  ]))),
    );
  }
}
