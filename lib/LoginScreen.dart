import 'package:flutter/material.dart';
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
        print("Connection Established");
      }
    } catch (_) {
      print("Connection Not Established");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkingConnection();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthenticationService authService = AuthenticationService();
  bool isLoading = false;
  String email = '', password = '';
  @override
  Widget build(BuildContext context) {
    double scrnwidth = MediaQuery.of(context).size.width;
    double scrnheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
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
                              return 'First Name is required';
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
                              color: Colors.amber,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.amber,
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
                              color: Colors.amber,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: TextButton(
                            onPressed: () async {
                              print("Forgot Password?");
                              authService.SingOut();
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
                          child: Text("Login"),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(scrnheight * 0.01),
                        child: Text(
                          "or continue with",
                          style: TextStyle(
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          googleSignIn();
                          print("Google Sign In");
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
                              color: Colors.amber,
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
