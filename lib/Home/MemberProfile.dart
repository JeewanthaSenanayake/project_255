import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_225/globals.dart';
import 'package:project_225/models/map_color_model.dart';
import 'package:project_225/models/user_model.dart';
import 'package:project_225/services/MapAndStatsService.dart';
import 'package:provider/provider.dart';

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

  TextEditingController _controller = TextEditingController();
  String comentString = "";
  String memberDistrict = "";

  Future<void> _refreshPage() async {
    data = await MapAndStats().getMemberById(data['id']);
    _scrollController.addListener(_scrollListener);
    setState(() {});
  }

  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  Future<void> getPeganitionNotification() async {
    setState(() => _isLoading = true);
    final commentData = await MapAndStats()
        .getByPeganition(data['id'], commentLimit, data["next_start_from"]);

    if (commentData == null) {
      _scrollController.removeListener(_scrollListener);
    }

    if (commentData["next_start_from"] == null) {
      _scrollController.removeListener(_scrollListener);
      setState(() {
        data["next_start_from"] = commentData["next_start_from"];
        data['comments'].addAll(commentData["comments"]);
        _isLoading = false;
      });
    } else {
      setState(() {
        data["next_start_from"] = commentData["next_start_from"];
        data['comments'].addAll(commentData["comments"]);
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
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    double scrnwidth = MediaQuery.of(context).size.width;
    double scrnheight = MediaQuery.of(context).size.height;

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          final mapColorModel =
              Provider.of<MapColorModel>(context, listen: false);
          return AlertDialog(
            title: Row(
              children: [
                Text("Add this Comment as"),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    alignment: Alignment.topRight,
                    icon: Icon(
                      Icons.close_rounded,
                      color: Colors.red,
                    )),
              ],
            ),
            backgroundColor: const Color.fromARGB(242, 255, 255, 255),
            content: SingleChildScrollView(
                child: Text(
              comentString,
            )),
            actions: <Widget>[
              Stack(
                children: [
                  Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: () async {
                            final userModel =
                                Provider.of<UserModel>(context, listen: false);
                            dynamic comentData = {
                              "user_id": userModel.data['id'],
                              "user_name": userModel.data['firstName'] +
                                  " " +
                                  userModel.data['lastName'],
                              "user_imgUrl": userModel.data['imgUrl'],
                              "comment": comentString,
                              "isGood": true,
                            };

                            Navigator.of(context).pop();
                            bool res = await MapAndStats().addComment(
                                data['id'], comentData, memberDistrict);
                            if (res) {
                              setState(() {
                                comentData['created_at'] = DateFormat(
                                        "yyyy-MM-dd'T'HH:mm:ss.SSSSSS+00:00")
                                    .format(DateTime.now());
                                data['comments'].add(comentData);
                                comentString = "";
                                _controller.clear();
                              });
                              mapColorModel.updateColorVersion();
                            } else {
                              setState(() {
                                comentString = "";
                                _controller.clear();
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Something went wrong, comment not submitted'),
                                ),
                              );
                            }
                          },
                          child: Text(
                            "Positive",
                            style: TextStyle(color: Colors.white),
                          ))),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: () async {
                            final userModel =
                                Provider.of<UserModel>(context, listen: false);
                            dynamic comentData = {
                              "user_id": userModel.data['id'],
                              "user_name": userModel.data['firstName'] +
                                  " " +
                                  userModel.data['lastName'],
                              "user_imgUrl": userModel.data['imgUrl'],
                              "comment": comentString,
                              "isGood": false,
                            };

                            Navigator.of(context).pop();
                            bool res = await MapAndStats().addComment(
                                data['id'], comentData, memberDistrict);
                            if (res) {
                              setState(() {
                                comentData['created_at'] = DateFormat(
                                        "yyyy-MM-dd'T'HH:mm:ss.SSSSSS+00:00")
                                    .format(DateTime.now());
                                data['comments'].add(comentData);
                                comentString = "";
                                _controller.clear();
                              });
                              mapColorModel.updateColorVersion();
                            } else {
                              setState(() {
                                comentString = "";
                                _controller.clear();
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Something went wrong, comment not submitted'),
                                ),
                              );
                            }
                          },
                          child: Text(
                            "Negative",
                            style: TextStyle(color: Colors.white),
                          ))),
                ],
              )
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      // backgroundColor: Colors.black,
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        color: Colors.red[900],
        child: Consumer<UserModel>(builder: (context, userModel, child) {
          return SafeArea(
              child: Container(
                  margin: EdgeInsets.only(
                      left: scrnwidth * 0.03, right: scrnwidth * 0.03),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: ClipOval(
                                    child: (data['imgUrl'] != null
                                        ? FadeInImage(
                                            placeholder: const AssetImage(
                                                'assets/loadingMan.png'),
                                            image: NetworkImage(
                                                "${data['imgUrl']}"),
                                            imageErrorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                  'assets/loadingMan.png',
                                                  width: scrnwidth * 0.4,
                                                  height: scrnwidth * 0.4,
                                                  fit: BoxFit.cover);
                                            },
                                            width: scrnwidth * 0.4,
                                            height: scrnwidth * 0.4,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            'assets/loadingMan.png',
                                            width: scrnwidth * 0.4,
                                            height: scrnwidth * 0.4,
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
                                    color: Colors.black,
                                    fontSize: scrnwidth * 0.07),
                              ),
                              Text(
                                data["fname"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black87,
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
                                        color: data['percentage'] != -1
                                            ? const Color.fromARGB(
                                                255, 255, 17, 0)
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
                                          color: const Color.fromARGB(
                                              255, 0, 255, 8),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Text(data.toString())
                            ]),
                        SizedBox(
                          height: scrnheight * 0.015,
                        ),
                        data['comments'].length > 0
                            ? Expanded(
                                child: ListView.builder(
                                    controller: _scrollController,
                                    itemCount: data['comments'].length,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.only(
                                            bottom: scrnheight * 0.02),
                                        padding:
                                            EdgeInsets.all(scrnheight * 0.01),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              children: [
                                                ClipOval(
                                                    child: (data['comments']
                                                                    [index][
                                                                "user_imgUrl"] !=
                                                            null
                                                        ? FadeInImage(
                                                            placeholder:
                                                                const AssetImage(
                                                                    'assets/loadingMan.png'),
                                                            image: NetworkImage(
                                                                "${data['comments'][index]["user_imgUrl"]}"),
                                                            imageErrorBuilder:
                                                                (context, error,
                                                                    stackTrace) {
                                                              return Image.asset(
                                                                  'assets/loadingMan.png',
                                                                  width:
                                                                      scrnwidth *
                                                                          0.1,
                                                                  height:
                                                                      scrnwidth *
                                                                          0.1,
                                                                  fit: BoxFit
                                                                      .cover);
                                                            },
                                                            width:
                                                                scrnwidth * 0.1,
                                                            height:
                                                                scrnwidth * 0.1,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Image.asset(
                                                            'assets/loadingMan.png',
                                                            width:
                                                                scrnwidth * 0.1,
                                                            height:
                                                                scrnwidth * 0.1,
                                                            fit: BoxFit.cover,
                                                          ))),
                                              ],
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                left: scrnwidth * 0.015,
                                              ),
                                              padding: EdgeInsets.only(
                                                  left: scrnwidth * 0.001,
                                                  right: scrnwidth * 0.001,
                                                  top: scrnheight * 0.01,
                                                  bottom: scrnheight * 0.01),
                                              decoration: BoxDecoration(
                                                  color: data['comments'][index]
                                                          ['isGood']
                                                      ? Color.fromARGB(
                                                              255, 55, 124, 55)
                                                          .withOpacity(0.25)
                                                      : Color.fromARGB(
                                                              255, 105, 43, 38)
                                                          .withOpacity(0.25),
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(
                                                          scrnheight * 0.02))),
                                              child: Column(
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
                                                      data['comments'][index]
                                                              ["user_name"]
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 0, 0, 0),
                                                          fontSize:
                                                              scrnwidth * 0.04,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: scrnwidth * 0.75,
                                                    margin: EdgeInsets.only(
                                                        left: scrnwidth * 0.02),
                                                    child: Text(
                                                      data['comments'][index]
                                                              ["comment"]
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 0, 0, 0),
                                                          fontSize: scrnwidth *
                                                              0.035),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              )
                            : Center(child: Text("No Comments")),
                        SizedBox(
                          height: scrnheight * 0.06,
                        ),
                      ])));
        }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: EdgeInsets.only(
          left: scrnwidth * 0.02,
          right: scrnwidth * 0.02,
        ),
        // decoration: BoxDecoration(
        //   color: Color.fromARGB(255, 0, 0, 0),
        // ),
        child: TextFormField(
          controller: _controller,
          onChanged: (value) {
            setState(() {
              comentString = value.toString();
            });
          },
          keyboardType: TextInputType.multiline,
          maxLines: 3,
          minLines: 1,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(scrnheight * 0.03))),
            hintText: "Type Your Comment",
            suffixIcon: IconButton(
              iconSize: scrnheight * 0.04,
              icon: Icon(Icons.send),
              color: comentString == "" ? Colors.grey : Colors.amber,
              onPressed: () {
                setState(() {
                  memberDistrict = data['district'];
                });
                if (comentString != "") {
                  _showMyDialog();
                }
              },
            ),
          ),
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
