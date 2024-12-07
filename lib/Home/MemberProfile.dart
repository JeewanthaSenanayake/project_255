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

  String comentString = "";
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
      body: SafeArea(
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
                                      image: NetworkImage("${data['imgUrl']}"),
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
                        // Text(data.toString())
                      ]),
                  SizedBox(
                    height: scrnheight * 0.015,
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                              children: List.generate(
                    data['comments'].length,
                    (index) => Container(
                      margin: EdgeInsets.only(bottom: scrnheight * 0.02),
                      padding: EdgeInsets.all(scrnheight * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              ClipOval(
                                  child: (data['comments'].length != 0
                                      ? FadeInImage(
                                          placeholder: const AssetImage(
                                              'assets/loadingMan.png'),
                                          image: NetworkImage(
                                              "${data['comments'][index]["user_imgUrl"]}"),
                                          width: scrnwidth * 0.1,
                                          height: scrnwidth * 0.1,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/loadingMan.png',
                                          width: scrnwidth * 0.1,
                                          height: scrnwidth * 0.1,
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
                                top: scrnheight * 0.007,
                                bottom: scrnheight * 0.007),
                            decoration: BoxDecoration(
                                color: data['comments'][index]['isGood']
                                    ? Color.fromARGB(47, 160, 255, 160)
                                    : Color.fromARGB(48, 255, 167, 160),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(scrnheight * 0.02))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: scrnwidth * 0.7,
                                  margin:
                                      EdgeInsets.only(left: scrnwidth * 0.02),
                                  child: Text(
                                    data['comments'][index]["user_name"]
                                        .toString(),
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        fontSize: scrnwidth * 0.04,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  width: scrnwidth * 0.75,
                                  margin:
                                      EdgeInsets.only(left: scrnwidth * 0.02),
                                  child: Text(
                                    data['comments'][index]["comment"]
                                        .toString(),
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        fontSize: scrnwidth * 0.035),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )))),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            comentString = value.toString();
                          });
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        minLines: 1,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(scrnheight * 0.03))),
                          hintText: "Type your message here",
                          suffixIcon: IconButton(
                            iconSize: scrnheight * 0.04,
                            icon: Icon(Icons.send),
                            color:
                                comentString == "" ? Colors.grey : Colors.amber,
                            onPressed: () {
                             if(comentString!=""){
                               print(comentString);
                             }
                             
                            },
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.amberAccent,
                        ),
                      )),
                ],
              ))),
    );
  }
}
