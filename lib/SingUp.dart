import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_225/services/UserServices.dart';

class SingUp extends StatefulWidget {
  const SingUp({super.key});

  @override
  State<SingUp> createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthenticationService authService = AuthenticationService();
  bool isLoading = false;

  dynamic inputData = {
    'email': '',
    'password': '',
    'confirmPassword': '',
    'firstName': '',
    'lastName': '',
  };

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    double scrnwidth = MediaQuery.of(context).size.width;
    double scrnheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Stack(children: [
            Column(
              children: <Widget>[
                SizedBox(height: scrnheight * 0.075),
                Text(
                  'Sign Up',
                  style: TextStyle(
                      fontSize: scrnheight * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: scrnheight * 0.02),
                Padding(
                  padding: EdgeInsets.all(scrnheight * 0.01),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'First Name is required';
                      }
                      return null;
                    },
                    onSaved: (text) => inputData['firstName'] = text.toString(),
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Last Name is required';
                      }
                      return null;
                    },
                    onSaved: (text) => inputData['lastName'] = text.toString(),
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
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
                    onSaved: (text) => inputData['email'] = text.toString(),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
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
                      } else if (inputData['password'] !=
                          inputData['confirmPassword']) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    onSaved: (text) => inputData['password'] = text.toString(),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
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
                        return 'Confirm Password is required';
                      } else if (inputData['password'] !=
                          inputData['confirmPassword']) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    onSaved: (text) =>
                        inputData['confirmPassword'] = text.toString(),
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: scrnheight * 0.025),
                  padding: EdgeInsets.all(scrnheight * 0.01),
                  width: scrnwidth,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(scrnwidth * 0.02),
                      ),
                    ),
                    onPressed: () async {
                      _formKey.currentState!.save();
                      if (_formKey.currentState!.validate()) {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text('Processing Data')),
                        // );
                        setState(() {
                          isLoading = true;
                        });
                        final uData =
                            await authService.createNewUser(inputData);
                        setState(() {
                          isLoading = false;
                        });
                        if (uData != null) {
                          Navigator.pop(context);
                        }
                      } else {
                        inputData['email'] = '';
                        inputData['password'] = '';
                        inputData['confirmPassword'] = '';
                        inputData['firstName'] = '';
                        inputData['lastName'] = '';
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          top: scrnheight * 0.02, bottom: scrnheight * 0.02),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
          ]),
        ),
      ),
    );
  }
}
