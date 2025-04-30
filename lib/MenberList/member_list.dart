import 'package:flutter/material.dart';
import 'package:project_225/Home/MemberProfile.dart';
import 'package:project_225/Widgets/comman_widgets.dart';
import 'package:project_225/services/MapAndStatsService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberList extends StatefulWidget {
  String uid;
  MemberList({super.key, required this.uid});

  @override
  State<MemberList> createState() => _MemberListState(uid: uid);
}

class _MemberListState extends State<MemberList> {
  String uid;
  _MemberListState({required this.uid});

  bool isLoading = false;
  List data = [];
  List filteredMembers = [];
  Future<void> getLobbyistList() async {
    setState(() {
      isLoading = true;
    });
    dynamic ldata = await MapAndStats().getShortLobbyistList();
    setState(() {
      data = ldata["lobbyist"];
      filteredMembers = ldata["lobbyist"];
      isLoading = false;
    });
  }

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
    });
    getLobbyistList();
  }

  @override
  Widget build(BuildContext context) {
    double scrnwidth = MediaQuery.of(context).size.width;
    double scrnheight = MediaQuery.of(context).size.height;
    Future<void> openPage(uid, id) async {
      setState(() {
        isLoading = true;
      });
      dynamic data;
      data = await MapAndStats().getMemberById(id);
      if (data != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MemberProfile(uid: uid, data: data)));
      }
      setState(() {
        isLoading = false;
      });
    }

    void filterMembers(String query) {
      debugPrint(query);
      final lowerQuery = query.toLowerCase();
      setState(() {
        filteredMembers = data
            .where(
                (member) => member['name'].toLowerCase().contains(lowerQuery))
            .toList();
      });
    }

    return Scaffold(
        body: Center(
          child: Container(
            margin: EdgeInsets.only(
                left: scrnwidth * 0.025, right: scrnwidth * 0.025),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: scrnheight * 0.05,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search members...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    onChanged: filterMembers,
                  ),
                ),
                isLoading
                    ? Image.asset(
                        "assets/loading.gif",
                        width: scrnwidth * 0.2,
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: filteredMembers.length,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final membersData = filteredMembers[index];
                            return InkWell(
                              onTap: () async {
                                openPage(uid, membersData['id']);
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
                                            child: (data.isNotEmpty
                                                ? FadeInImage(
                                                    placeholder: const AssetImage(
                                                        'assets/loadingMan.png'),
                                                    image: NetworkImage(
                                                        "${membersData["imgUrl"]}"),
                                                    imageErrorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Image.asset(
                                                          'assets/loadingMan.png',
                                                          width:
                                                              scrnwidth * 0.15,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CommanWidgets(context, uid).footerWidgets(1));
  }
}
