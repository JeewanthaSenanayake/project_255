import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../globals.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  dynamic getCurrentUser() {
    try {
      return _firebaseAuth.currentUser?.uid;
    } catch (e) {
      return null;
    }
  }

  Future SingOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('mapGuide');
    await prefs.remove('districtGuide');
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
      dynamic userIndb = await getUserData(user.uid);
      if (userIndb != null) {
        print("User found in DB");
        return user.uid;
      } else {
        print("User not found in DB and creating new user");
        return await createNewUserOnDB(udata);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<dynamic> createNewUser(dynamic udata) async {
    try {
      UserCredential result =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: udata['email'], password: udata['password']);
      //Add data to data base
      dynamic userdata = {
        "id": result.user!.uid,
        "email": udata['email'],
        "firstName": udata['firstName'],
        "lastName": udata['lastName'],
        "imgUrl": null,
      };
      return await createNewUserOnDB(userdata);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<dynamic> loginUser(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user!.uid;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> getUserData(String uid) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/v1/user/get_user_by_id/$uid"),
      );
      if (response.statusCode == 200) {
        if (json.decode(response.body).length != 0) {
          var decodedResponse = utf8.decode(response.bodyBytes);
          return jsonDecode(decodedResponse)[0];
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<dynamic> createNewUserOnDB(dynamic udata) async {
    try {
      final response = await http.post(
          Uri.parse("$baseUrl/api/v1/user/create_user"),
          headers: {'Content-Type': 'application/json'},
          body: json.encoder.convert(udata));
      if (response.statusCode == 200) {
        return udata['id'];
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<dynamic> updateUserNameData(dynamic udata, String uid) async {
    try {
      final response = await http.put(
          Uri.parse("$baseUrl/api/v1/user/update_user_by_id/$uid"),
          headers: {'Content-Type': 'application/json'},
          body: json.encoder.convert(udata));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<dynamic> updateUserData(File imgFile, String uid) async {
    final url = Uri.parse("$baseUrl/api/v1/user/update_user_pic/$uid");
    var request = http.MultipartRequest('PUT', url);
    final mimeType = lookupMimeType(imgFile.path);
    request.files.add(await http.MultipartFile.fromPath(
      'file', // Field name expected by the server
      imgFile.path,
      contentType: MediaType.parse(mimeType ?? 'application/octet-stream'),
    ));

    try {
      var response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        print("Image uploaded successfully: ${responseBody.body}");
        return json.decode(responseBody.body)['imgurl'];
      } else {
        print(
            "Image upload failed with status: ${response.statusCode}, ${responseBody.body}");
        return false;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return false;
    }
  }
}
