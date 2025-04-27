import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_225/Widgets/comman_widgets.dart';
import 'package:project_225/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  String uid;
  AboutScreen({super.key, required this.uid});

  @override
  State<AboutScreen> createState() => _AboutScreenState(uid: uid);
}

class _AboutScreenState extends State<AboutScreen> {
  String uid;
  _AboutScreenState({required this.uid});

  @override
  Widget build(BuildContext context) {
    double scrnwidth = MediaQuery.of(context).size.width;
    double scrnheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // backgroundColor: Colors.transparent,
        title: Text(
          "About",
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
              Center(
                  child: ClipOval(
                      child: Image.asset(
                'assets/The_Parliament_Login_Screen.png',
                width: scrnwidth * 0.5,
                height: scrnwidth * 0.5,
                fit: BoxFit.cover,
              ))),
              Container(
                padding: EdgeInsets.only(
                    left: scrnwidth * 0.02,
                    right: scrnwidth * 0.02,
                    top: scrnheight * 0.03),
                child: Text(
                  "Project 225 is a platform designed to promote transparency and public engagement in Sri Lanka’s political landscape. With this app, you can share your opinions on parliament members by adding positive or negative comments\n\n"
                  "Each member’s feedback contributes to a good-bad ratio, visually represented by a linear indicator bar. The app also features an interactive map of Sri Lanka, highlighting all election districts. By selecting a district, you can view its parliament representatives and submit your feedback.\n\n"
                  "The app dynamically calculates the overall district sentiment based on the combined good-bad scores of its MPs. Districts are then color-coded on the map, ranging from green (positive feedback) to red (negative feedback), giving you a clear visual representation of public perception.\n\n"
                  "Project 225 empowers you to voice your opinions, fostering accountability and informed decision-making.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.black87),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: scrnheight * 0.02),
                child: Center(
                  child: GestureDetector(
                    onTap: () async {
                      // Launch the URL in the external browser
                      await launchUrl(
                        Uri(scheme: 'https', host: 'ecoderssl.com'),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: SvgPicture.asset(
                      'assets/logo.svg',
                      width: scrnwidth * 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
      }),
      bottomNavigationBar: CommanWidgets(context, uid).footerWidgets(0),
    );
  }
}
