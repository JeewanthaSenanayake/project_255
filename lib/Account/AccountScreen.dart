import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:project_225/About/AboutScreen.dart';
import 'package:project_225/LoginScreen.dart';
import 'package:project_225/Widgets/comman_widgets.dart';
import 'package:project_225/services/UserServices.dart';
import 'package:project_225/models/user_model.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  String uid;
  AccountScreen({super.key, required this.uid});

  @override
  State<AccountScreen> createState() => _AccountScreenState(uid: uid);
}

class _AccountScreenState extends State<AccountScreen> {
  String uid;
  _AccountScreenState({required this.uid});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false, isLoading2 = false, updateShow = true;

  String fname = "", lname = "";

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
      setState(() {
        _imageFile = file;
      });
    } else {
      // User canceled the picker
    }
  }

  bool fnameUpdate = false, lnameUpdate = false;

  void valueChangeFinder(String value, String input, dynamic userData) {
    if (input == "fname") {
      if (value != userData['firstName']) {
        setState(() {
          updateShow = true;
          fnameUpdate = true;
        });
      } else {
        setState(() {
          fnameUpdate = false;
        });
      }
    }

    if (input == "lname") {
      if (value != userData['lastName']) {
        setState(() {
          updateShow = true;
          lnameUpdate = true;
        });
      } else {
        setState(() {
          lnameUpdate = false;
        });
      }
    }
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  late Key _fieldKey;
  @override
  void initState() {
    super.initState();
    _fieldKey = UniqueKey();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    double scrnwidth = MediaQuery.of(context).size.width;
    double scrnheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Consumer<UserModel>(builder: (context, userModel, child) {
        final userData = userModel.data;
        final inputVertical = scrnheight * 0.001;
        final inputHorizontal = scrnwidth * 0.03;
        return SingleChildScrollView(
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
                                  ? (userData != null &&
                                          userData['imgUrl'] != null
                                      ? FadeInImage(
                                          placeholder: const AssetImage(
                                              'assets/loadingMan.png'),
                                          image: NetworkImage(
                                              "${userData['imgUrl']}"),
                                          imageErrorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                                'assets/loadingMan.png',
                                                width: scrnwidth * 0.5,
                                                height: scrnwidth * 0.5,
                                                fit: BoxFit.cover);
                                          },
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
                          _imageFile != null
                              ? Container(
                                  margin:
                                      EdgeInsets.only(top: scrnheight * 0.025),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: scrnwidth * 0.025),
                                        child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 255, 116, 106),
                                            ),
                                            onPressed: () async {
                                              setState(() {
                                                _imageFile = null;
                                              });
                                            },
                                            label: Text("Discard"),
                                            icon: Icon(Icons.close)),
                                      ),
                                      ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 106, 255, 114),
                                          ),
                                          onPressed: () async {
                                            setState(() {
                                              isLoading2 = true;
                                            });
                                            final response =
                                                await AuthenticationService()
                                                    .updateUserData(
                                                        _imageFile!, uid);
                                            if (response != false) {
                                              setState(() {
                                                userModel.updateUser(
                                                    "imgUrl", response);

                                                _imageFile = null;
                                                isLoading2 = false;
                                              });
                                            } else {
                                              setState(() {
                                                isLoading2 = false;
                                              });
                                            }
                                          },
                                          label: Text("Upload"),
                                          icon: Icon(Icons.upload)),
                                    ],
                                  ),
                                )
                              : Container(),
                          Container(
                            padding: EdgeInsets.only(top: scrnheight * 0.025),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: scrnwidth * 0.8,
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    userData['firstName'] +
                                        " " +
                                        userData['lastName'],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: scrnwidth * 0.07),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Text(userData.toString()),
                                Container(
                                    margin:
                                        EdgeInsets.only(top: scrnheight * 0.03),
                                    child: TextFormField(
                                      key: _fieldKey,
                                      onChanged: (value) {
                                        valueChangeFinder(
                                            value, 'fname', userData);
                                      },
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      initialValue: userData['firstName'],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'First Name is required';
                                        }
                                        return null;
                                      },
                                      onSaved: (text) =>
                                          fname = text.toString(),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: inputVertical,
                                            horizontal: inputHorizontal),
                                        labelText: 'First Name',
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    )),
                                Container(
                                    margin: EdgeInsets.only(
                                        top: scrnheight * 0.015),
                                    child: TextFormField(
                                      key: _fieldKey,
                                      onChanged: (value) {
                                        valueChangeFinder(
                                            value, 'lname', userData);
                                      },
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      initialValue: userData['lastName'],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Last Name is required';
                                        }
                                        return null;
                                      },
                                      onSaved: (text) =>
                                          lname = text.toString(),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: inputVertical,
                                            horizontal: inputHorizontal),
                                        labelText: 'Last Name',
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    )),
                                Container(
                                    margin: EdgeInsets.only(
                                        top: scrnheight * 0.015),
                                    child: TextFormField(
                                      enabled: false,
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      initialValue: userData['email'],
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: inputVertical,
                                            horizontal: inputHorizontal),
                                        labelText: 'Email',
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    )),
                                ((lnameUpdate || fnameUpdate) && updateShow)
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            top: scrnheight * 0.025),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  right: scrnwidth * 0.025),
                                              child: ElevatedButton.icon(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 255, 116, 106),
                                                  ),
                                                  onPressed: () async {
                                                    setState(() {
                                                      _fieldKey = UniqueKey();
                                                      updateShow = false;
                                                    });
                                                  },
                                                  label: Text("Discard"),
                                                  icon: Icon(Icons.close)),
                                            ),
                                            ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 106, 255, 114),
                                                ),
                                                onPressed: () async {
                                                  _formKey.currentState!.save();
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    setState(() {
                                                      isLoading2 = true;
                                                    });
                                                    final response =
                                                        await AuthenticationService()
                                                            .updateUserNameData(
                                                                {
                                                          "firstName": fname,
                                                          "lastName": lname
                                                        },
                                                                uid);

                                                    if (response != false) {
                                                      setState(() {
                                                        userModel.updateUser(
                                                            "firstName", fname);
                                                        userModel.updateUser(
                                                            "lastName", lname);
                                                        isLoading2 = false;
                                                        updateShow = false;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        isLoading2 = false;
                                                      });
                                                    }
                                                  } else {
                                                    fname = '';
                                                    lname = '';
                                                  }
                                                },
                                                label: Text("Update"),
                                                icon: Icon(Icons.update)),
                                          ],
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                top: scrnheight * 0.0025,
                              ),
                              child: Divider()),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              style: ButtonStyle(
                                foregroundColor: WidgetStateProperty.all<Color>(
                                    Colors.black),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        AboutScreen(uid: uid)));
                              },
                              label: Text("About"),
                              icon: Icon(Icons.info_outline),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              style: ButtonStyle(
                                foregroundColor: WidgetStateProperty.all<Color>(
                                    Colors.black),
                              ),
                              onPressed: () {
                                AuthenticationService().SingOut();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              },
                              label: Text("Sing Out"),
                              icon: Icon(Icons.logout_outlined),
                            ),
                          ),
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
                                    debugPrint("Camera");
                                  },
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: scrnwidth * 0.075,
                                  )),
                            ),
                          )),
                      isLoading2
                          ? Container(
                              margin: EdgeInsets.only(top: scrnheight * 0.45),
                              child: Center(
                                child: Image.asset(
                                  "assets/loading.gif",
                                  width: scrnwidth * 0.2,
                                ),
                              ),
                            )
                          : Container(),
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
        );
      }),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              margin: EdgeInsets.only(bottom: scrnheight * 0.005),
              child: Center(child: Text("VERSION ${_packageInfo.version}"))),
          CommanWidgets(context, uid).footerWidgets(3),
        ],
      ),
    );
  }
}
