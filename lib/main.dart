import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newnippon/screens/dashboard.dart';
import 'package:newnippon/screens/signuppage.dart';
import 'package:newnippon/services/authservice.dart';
import 'screens/loginpage.dart';

void main() => runApp(Phoenix(
      child: MyApp(),
    ),);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color:Colors.black,
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
                Theme.of(context).textTheme,
              ),
      ),
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
