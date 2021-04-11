import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newnippon/screens/dashboard.dart';
import 'package:newnippon/screens/loginpage.dart';
import './userinfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  handleAuth() {
    return FutureBuilder<bool>(
        future: Userinfo().issignin(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data == false) {
            {
              return LoginPage();
            }
          } else {
            return DashBoard();
          }
        });
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
    Userinfo().logout();
  }

  signInwithemail(email, password) async {
    String errorMessage;
    bool success;
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      errorMessage = "none";
      success = true;
      Userinfo().signedin();
    } catch (error) {
      success = false;
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "Something went wrong..";
      }
    }
    var dict = [success, errorMessage];
    return dict;
  }

  signup(email, password, name) async {
    String errorMessage;
    bool success;
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      success = true;
      errorMessage = "none";
      Userinfo().username(name);
      Userinfo().signedin();
    } catch (error) {
      success = false;
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "Email address already registered.";
      }
    }
    var dict = [success, errorMessage];
    return dict;
  }

  signIn(AuthCredential authCreds) {
    FirebaseAuth.instance.signInWithCredential(authCreds);
  }

  Future<String> getuseruid() async {
    User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid;
    return uid;
  }

  Future<String> getuseremail() async {
    User user = FirebaseAuth.instance.currentUser;
    final String email = user.email;
    return email;
  }

  deleteAccount() async {
    User user = FirebaseAuth.instance.currentUser;
    try {
      user.delete();
      FirebaseFirestore.instance.collection('User').doc(user.uid).delete();
    } catch (e) {
      print(e);
    }
    user.delete();
  }
}
