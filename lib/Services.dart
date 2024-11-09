import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'globals.dart';
import 'package:http/http.dart' as http;

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String getCurrentUser() {
    return _firebaseAuth.currentUser!.uid;
  }

  Future SingOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult =
          await _firebaseAuth.signInWithCredential(credential);
      final dynamic user = authResult.user;

      List<String> displayName = (user.displayName).split(' ');
      dynamic udata = {
        "id": user.uid,
        "email": user.email,
        "firstName": displayName.first,
        "lastName": displayName.last,
        "imgUrl": user.photoURL,
      };
      if (await userFoundInDB(user.uid)) {
        print("User found in DB");
        return udata;
      } else {
        print("User not found in DB and creating new user");
        return await createNewUserOnDB(udata);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> createNewUser(dynamic udata) async {
    try {
      UserCredential result =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: udata['email'], password: udata['password']);
      //Add data to data base

      return result.user;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> loginUser(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> userFoundInDB(String uid) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/v1/user/get_user_by_id/$uid"),
      );
      if (response.statusCode == 200) {
        if (json.decode(response.body).length != 0) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<dynamic> createNewUserOnDB(dynamic udata) async {
    try {
      final response = await http.post(
          Uri.parse("$baseUrl/api/v1/user/create_user"),
          headers: {'Content-Type': 'application/json'},
          body: json.encoder.convert(udata));
      if (response.statusCode == 200) {
        return udata;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
