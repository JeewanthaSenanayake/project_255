import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_225/Home/MapScreen.dart';
import 'package:project_225/services/UserServices.dart';
import 'package:project_225/SingUp.dart';
import 'globals.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<void> checkingConnection() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/v1/connection"),
      );
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        debugPrint("Connection Established");
      }
    } catch (_) {
      debugPrint("Connection Not Established");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkingConnection();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final AuthenticationService authService = AuthenticationService();
  bool isLoading = false;
  String email = '', password = '';

  void showPopUp(double scrnheight, double scrnwidth) {
    String resetEmail = "";
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          // To display the title it is optional
          title: Row(
            children: [
              Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.close_rounded,
                  color: Colors.red,
                ),
              )
            ],
          ),
          // Message which will be pop up on the screen
          content: SizedBox(
              height: scrnheight * 0.25,
              width: scrnwidth,
              child: Column(
                children: [
                  Text(
                    'Forgot Your Password',
                    style: TextStyle(
                        fontSize: scrnheight * 0.025,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: scrnheight * 0.02, bottom: scrnheight * 0.02),
                    child: Text(
                      'Enter your email address and we will send you a link to reset your password.',
                      style: TextStyle(fontSize: scrnheight * 0.017),
                    ),
                  ),
                  Form(
                      key: _formKey2,
                      child: TextFormField(
                        validator: (value) {
                          String pattern =
                              r'^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,6}$';
                          RegExp regex = RegExp(pattern);
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          } else if (!regex.hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                        onSaved: (text) => resetEmail = text.toString(),
                        decoration: InputDecoration(
                          hintText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ))
                ],
              )),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _formKey2.currentState!.save();
                  if (_formKey2.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(email: resetEmail);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password reset email sent'),
                        ),
                      );
                      Navigator.of(context).pop();
                      setState(() {
                        isLoading = false;
                      });
                    } on FirebaseException catch (e) {
                      // Utils.showSnackBar(e.message);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("This emil does not have an account"),
                        ),
                      );
                      Navigator.of(context).pop();
                      setState(() {
                        isLoading = false;
                      });
                    }
                  } else {
                    resetEmail = "";
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: Text(
                  'Reset Password',
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    double scrnwidth = MediaQuery.of(context).size.width;
    double scrnheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              Column(children: [
                Image.asset(
                  "assets/The_Parliament_Login_Screen.png",
                  width: scrnwidth,
                ),
                Container(
                  margin: EdgeInsets.all(scrnwidth * 0.025),
                  // color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(scrnheight * 0.01),
                        child: TextFormField(
                          validator: (value) {
                            String pattern =
                                r'^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,6}$';
                            RegExp regex = RegExp(pattern);
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            } else if (!regex.hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                          onSaved: (text) => email = text.toString(),
                          decoration: InputDecoration(
                            hintText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(scrnheight * 0.01),
                        child: TextFormField(
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            return null;
                          },
                          onSaved: (text) => password = text.toString(),
                          decoration: InputDecoration(
                            hintText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: TextButton(
                            onPressed: () async {
                              showPopUp(scrnheight, scrnwidth);
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                      Container(
                        padding: EdgeInsets.all(scrnheight * 0.01),
                        width: scrnwidth * 0.5,
                        child: ElevatedButton(
                          onPressed: () async {
                            _formKey.currentState!.save();
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              final uData =
                                  await authService.loginUser(email, password);

                              if (uData != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MapScreen(uid: uData)),
                                );
                              }
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              email = '';
                              password = '';
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(scrnheight * 0.01),
                        child: Text(
                          "or continue with",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          googleSignIn();
                          debugPrint("Google Sign In");
                        },
                        child: Container(
                          padding: EdgeInsets.all(scrnheight * 0.01),
                          child: Image.asset(
                            "assets/google.png",
                            width: scrnwidth * 0.1,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SingUp(),
                                ),
                              );
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
              isLoading
                  ? Positioned(
                      top: scrnheight * 0.45,
                      left: scrnwidth * 0.4,
                      child: Image.asset(
                        "assets/loading.gif",
                        width: scrnwidth * 0.2,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> googleSignIn() async {
    setState(() {
      isLoading = true;
    });
    dynamic user = await authService.signInWithGoogle();

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MapScreen(uid: user)),
      );
    }
    setState(() {
      isLoading = false;
    });
  }
}
