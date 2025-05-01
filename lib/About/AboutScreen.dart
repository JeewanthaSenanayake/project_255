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
        // automaticallyImplyLeading: false,
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
                'assets/Splash.png',
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
                  "Project 225 is a platform designed to promote transparency and encourage public engagement in Sri Lanka’s political landscape. It empowers citizens to voice their opinions about parliament members by sharing positive or negative feedback directly through the app.\n\n"
                  "Within the app, you can submit either positive or negative comments for any parliament member. Based on the feedback provided by you and others, a positive-negative ratio is calculated for each member, and a linear indicator bar is shown to reflect their overall public sentiment.\n\n"
                  "You can also explore an interactive map of Sri Lanka’s election districts, where each district is automatically color-coded according to the feedback received for its MPs. "
                  "As a result, districts are visually represented with colors ranging from green to red, giving you a clear and immediate view of how each region’s political representatives are being perceived by the public.\n\n"
                  "With Project 225, a space has been created where your voice can contribute to accountability, transparency, and informed decision-making across the nation.",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              
              Container(
                margin: EdgeInsets.only(top: scrnheight * 0.025),
                child: Center(
                  child: GestureDetector(
                    onTap: () async {
                      // Launch the URL in the external browser
                      await launchUrl(
                        Uri(scheme: 'https', host: 'ecoderssl.com'),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: Image.asset(
                      'assets/NewLogo.png',
                      width: scrnwidth * 0.45,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
      }),
    );
  }
}
