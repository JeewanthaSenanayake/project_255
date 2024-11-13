import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_225/Home/MapScreen.dart';
import 'package:project_225/LoginScreen.dart';
import 'package:project_225/services/UserServices.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AccountScreen extends StatefulWidget {
  String uid;
  AccountScreen({super.key, required this.uid});

  @override
  State<AccountScreen> createState() => _AccountScreenState(uid: uid);
}

class _AccountScreenState extends State<AccountScreen> {
  String uid;
  _AccountScreenState({required this.uid});
  // for footer
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => MapScreen(uid: uid)));
      }
      // if (index == 1) {
      //   Navigator.of(context)
      //       .push(MaterialPageRoute(builder: (context) => Oder(uid: uid)));
      // }
      // if (index == 2) {
      //   Navigator.of(context)
      //       .push(MaterialPageRoute(builder: (context) => cart(uid: uid)));
      // }
    });
  }

  dynamic userData;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  getUserData() async {
    dynamic userInfo = await AuthenticationService().getUserData(uid);
    setState(() {
      isLoading = false;
      userData = userInfo;
    });
  }

  Future<String> uploadImage(_imageFile) async {
    if (_imageFile == null) {
      return "fail";
    }

    final firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child('user/profile');

    await ref.putFile(_imageFile!);
    final url = await ref.getDownloadURL();

    // Do something with the download URL (e.g. save to Firebase Firestore)
    return url;
    // print(url);
  }

  File? _imageFile;
  getProfileImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'jpeg',
          'png',
          'gif',
          'bmp',
          'tiff',
          'svg',
          'webp'
        ]);
    if (result != null) {
      File file = File(result.files.single.path!);
      print(file);
      print(_imageFile);
      setState(() {
        _imageFile = file;
      });
      print(_imageFile);
      // uploadProfileImage(file);
      // print(uploadImage(file));
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    double scrnwidth = MediaQuery.of(context).size.width;
    double scrnheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: isLoading == false
            ? Container(
                margin: EdgeInsets.only(
                    top: scrnheight * 0.05,
                    left: scrnwidth * 0.025,
                    right: scrnwidth * 0.025),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: ClipOval(
                            child: _imageFile == null
                                ? (userData['imgUrl'] != null
                                    ? Image.network(
                                        userData['imgUrl'],
                                        width: scrnwidth * 0.5,
                                        height: scrnwidth * 0.5,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/loadingMan.png',
                                        width: scrnwidth * 0.5,
                                        height: scrnwidth * 0.5,
                                        fit: BoxFit.cover,
                                      ))
                                : Image.file(
                                    _imageFile!,
                                    width: scrnwidth * 0.5,
                                    height: scrnwidth * 0.5,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: scrnheight * 0.025),
                          child: Text(
                            userData['firstName'] + " " + userData['lastName'],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: scrnwidth * 0.075),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              AuthenticationService().SingOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                            },
                            child: Text("Sing Out")),
                        Text(userData.toString())
                      ],
                    ),
                    Positioned(
                        top: scrnheight * 0.18,
                        left: scrnwidth * 0.57,
                        child: ClipOval(
                          child: Container(
                            color: const Color.fromARGB(185, 0, 0, 0),
                            child: IconButton(
                                onPressed: () async {
                                  await getProfileImage();
                                  print("Camera");
                                },
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: scrnwidth * 0.075,
                                )),
                          ),
                        ))
                  ],
                ))
            : Container(
                margin: EdgeInsets.only(top: scrnheight * 0.45),
                child: Center(
                  child: Image.asset(
                    "assets/loading.gif",
                    width: scrnwidth * 0.2,
                  ),
                ),
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color.fromARGB(121, 34, 33, 33),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
            backgroundColor: Color.fromARGB(121, 34, 33, 33),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp),
            label: 'Account',
            backgroundColor: Color.fromARGB(121, 34, 33, 33),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Help',
            backgroundColor: Color.fromARGB(121, 34, 33, 33),
          ),
        ],
        currentIndex: 2,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
