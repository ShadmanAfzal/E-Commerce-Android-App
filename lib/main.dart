import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newnippon/screens/dashboard.dart';
import 'package:newnippon/screens/signuppage.dart';
import 'package:newnippon/services/authservice.dart';
import 'screens/loginpage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.black,
      theme: ThemeData(
          fontFamily: "Whitney",
          accentColor: Colors.red,
          primaryColorDark: Colors.red.shade100,
          primaryColor: Colors.red.shade700,
          backgroundColor: Colors.white,
          cardColor: Colors.black),
      debugShowCheckedModeBanner: false,
      title: 'NewNippon',
      home: AuthService().handleAuth(),
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUp(),
        '/dashboard': (context) => DashBoard(),
      },
    );
  }
}
