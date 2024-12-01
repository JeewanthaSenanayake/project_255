import 'package:flutter/material.dart';
import 'package:project_225/Home/MemberProfile.dart';
import 'package:project_225/services/MapAndStatsService.dart';

class District extends StatefulWidget {
  String uid, distric;
  dynamic data;
  District(
      {super.key,
      required this.uid,
      required this.distric,
      required this.data});

  @override
  State<District> createState() =>
      _DistrictState(uid: uid, distric: distric, data: data);
}

class _DistrictState extends State<District> {
  String uid, distric;
  dynamic data;
  bool isLoading = false;
  _DistrictState(
      {required this.uid, required this.distric, required this.data});
  @override
  Widget build(BuildContext context) {
    double scrnwidth = MediaQuery.of(context).size.width;
    double scrnheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          distric.toString().toUpperCase(),
          style: TextStyle(color: Colors.amber),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.amber),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
              left: scrnwidth * 0.025, right: scrnwidth * 0.025),
          child: Stack(
            children: [
              Column(
                children: [
                  for (dynamic membersData in data)
                    InkWell(
                      onTap: () async {
                        debugPrint(membersData['id']);
                        setState(() {
                          isLoading = true;
                        });

                        dynamic data = null;
                        data = await MapAndStats()
                            .getMemberById(membersData['id']);
                        if (data != null) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  MemberProfile(uid: uid, data: data)));
                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: scrnheight * 0.02),
                        padding: EdgeInsets.all(scrnheight * 0.01),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                ClipOval(
                                    child: (data.length != 0
                                        ? FadeInImage(
                                            placeholder: const AssetImage(
                                                'assets/loadingMan.png'),
                                            image: NetworkImage(
                                                "${membersData["imgUrl"]}"),
                                            width: scrnwidth * 0.15,
                                            height: scrnwidth * 0.15,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            'assets/loadingMan.png',
                                            width: scrnwidth * 0.15,
                                            height: scrnwidth * 0.15,
                                            fit: BoxFit.cover,
                                          ))),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: scrnwidth * 0.7,
                                  margin:
                                      EdgeInsets.only(left: scrnwidth * 0.02),
                                  child: Text(
                                    membersData["name"].toString(),
                                    style: TextStyle(
                                        color: Colors.amberAccent,
                                        fontSize: scrnwidth * 0.05),
                                  ),
                                ),
                                Container(
                                  width: scrnwidth * 0.7,
                                  margin:
                                      EdgeInsets.only(left: scrnwidth * 0.02),
                                  child: Text(
                                    membersData["party"].toString(),
                                    style: TextStyle(
                                        color: Colors.amberAccent,
                                        fontSize: scrnwidth * 0.03),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              isLoading
                  ? Positioned(
                      top: scrnheight * 0.35,
                      left: scrnwidth * 0.35,
                      child: Image.asset(
                        "assets/loading.gif",
                        width: scrnwidth * 0.2,
                      ),
                    )
                  : Positioned(
                      top: scrnheight * 0.35,
                      left: scrnwidth * 0.35,
                      child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
