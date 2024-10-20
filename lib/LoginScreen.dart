import 'package:flutter/material.dart';
import 'package:project_225/MapScreen.dart';
import 'package:project_225/Services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthenticationService authService = AuthenticationService();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    double scrnwidth = MediaQuery.of(context).size.width;
    double scrnheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
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
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Username",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(scrnheight * 0.01),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: TextButton(
                          onPressed: () {
                            print("Forgot Password?");
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
                        onPressed: () {
                          authService.SingOut();
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
                            print("Sign Up");
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
    );
  }

  Future<void> googleSignIn() async {
    setState(() {
      isLoading = true;
    });
    dynamic user = await authService.signInWithGoogle();
    setState(() {
      isLoading = false;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MapScreen(user: user)),
    );
  }
}
