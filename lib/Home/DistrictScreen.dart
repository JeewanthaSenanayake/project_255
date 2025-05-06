import 'package:flutter/material.dart';
import 'package:project_225/Home/MemberProfile.dart';
import 'package:project_225/Widgets/comman_widgets.dart';
import 'package:project_225/services/MapAndStatsService.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool? districtGuide = prefs.getBool('districtGuide');
      if (districtGuide == null || districtGuide == false) {
        CommanWidgets(context, uid).showPopUp(1);
      }
      await prefs.setBool('mapGuide', true);
    });
  }

  @override
  Widget build(BuildContext context) {
    double scrnwidth = MediaQuery.of(context).size.width;
    double scrnheight = MediaQuery.of(context).size.height;
    setState(() {
      data['percentage'] = data["status"] != -1
          ? (data["status"]["good"] /
                  (data["status"]["good"] + data["status"]["bad"])) *
              100
          : data["status"];
    });
    double positivePercentage = 0;
    double negativePercentage = 0;
    if (data["percentage"] != -1) {
      positivePercentage = double.parse(data["percentage"].toStringAsFixed(1));
      negativePercentage = (100 - positivePercentage).abs();
    }
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              distric.toString().toUpperCase(),
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? Center(
              child: Image.asset(
                "assets/loading.gif",
                width: scrnwidth * 0.2,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(
                    left: scrnwidth * 0.025, right: scrnwidth * 0.025),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "District trust meter",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: scrnwidth, // Total width of the bar
                      height: scrnheight * 0.015, // Height of the bar
                      child: Stack(
                        children: [
                          // Background (red color)
                          Container(
                            decoration: BoxDecoration(
                              color: data['percentage'] != -1
                                  ? const Color.fromARGB(255, 255, 17, 0)
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          // Foreground (green color)
                          FractionallySizedBox(
                            widthFactor: data['percentage'] == -1
                                ? 0
                                : data['percentage'] /
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
                    Row(
                      children: [
                        Text("${positivePercentage.toStringAsFixed(1)} %",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Spacer(),
                        Text(
                          "${negativePercentage.toStringAsFixed(1)} %",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: scrnheight * 0.02,
                    ),
                    Column(
                      children: [
                        for (dynamic membersData in data["members"])
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
                                                  imageErrorBuilder: (context,
                                                      error, stackTrace) {
                                                    return Image.asset(
                                                        'assets/loadingMan.png',
                                                        width: scrnwidth * 0.15,
                                                        height:
                                                            scrnwidth * 0.15,
                                                        fit: BoxFit.cover);
                                                  },
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: scrnwidth * 0.7,
                                        margin: EdgeInsets.only(
                                            left: scrnwidth * 0.02),
                                        child: Text(
                                          membersData["name"].toString(),
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: scrnwidth * 0.05),
                                        ),
                                      ),
                                      Container(
                                        width: scrnwidth * 0.7,
                                        margin: EdgeInsets.only(
                                            left: scrnwidth * 0.02),
                                        child: Text(
                                          membersData["party"].toString(),
                                          style: TextStyle(
                                              color: Colors.black87,
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
                  ],
                ),
              ),
            ),
    );
  }
}
