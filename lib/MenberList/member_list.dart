import 'package:flutter/material.dart';
import 'package:project_225/Widgets/comman_widgets.dart';

class MemberList extends StatefulWidget {
  String uid;
  MemberList({super.key, required this.uid});

  @override
  State<MemberList> createState() => _MemberListState(uid: uid);
}

class _MemberListState extends State<MemberList> {
  String uid;
  _MemberListState({required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Search Member",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Text("data $uid"),
        bottomNavigationBar: CommanWidgets(context, uid).footerWidgets(1));
  }
}
