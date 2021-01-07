import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/authservice.dart';
import './signuppage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  bool secure = true;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  showAlertDialog(BuildContext context, errormsg) {
    Widget okButton = FlatButton(
      child: Text("OK",
          style: TextStyle(fontSize: 18, color: Colors.red.shade700)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Text(errormsg,
          style: TextStyle(
            fontSize: 18,
          )),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showloadingscreen(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Row(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red[700]),
          ),
          SizedBox(width: 20),
          Text("Please Wait...",
              style: TextStyle(
                fontSize: 18,
              )),
        ],
      ),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.black87,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: "New",
                                        style: TextStyle(
                                          fontSize: 50,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                          text: "Nippon",
                                          style: TextStyle(
                                            fontSize: 50,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: ".com",
                                              style: TextStyle(
                                                  color: Colors.red.shade700,
                                                  fontSize: 50,
                                                  fontFamily: "KaushanScript"),
                                            )
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Container(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30.0),
                                        child: TextFormField(
                                          style: GoogleFonts.lato(
                                              fontSize: 17.5,
                                              color: Colors.white),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          validator: (email) {
                                            bool emailValid = RegExp(
                                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                .hasMatch(email.trim());
                                            if (!emailValid) {
                                              if (email.length == 0)
                                                return "Enter Email Id";
                                              return "Enter valid Email Id";
                                            } else {
                                              return null;
                                            }
                                          },
                                          onSaved: (email) {
                                            setState(() {
                                              _email = email;
                                            });
                                          },
                                          controller: _emailController,
                                          cursorColor: Colors.white,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              hintText: ' some@domian.com',
                                              errorStyle: GoogleFonts.lato(
                                                  fontSize: 16),
                                              hintStyle: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 17)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30.0),
                                        child: TextFormField(
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          validator: (password) {
                                            bool passwordValid = RegExp(
                                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                                .hasMatch(password.trim());
                                            if (!passwordValid) {
                                              if (password.length == 0)
                                                return "Enter Password";
                                              return "Enter valid Password";
                                            } else {
                                              return null;
                                            }
                                          },
                                          onSaved: (password) {
                                            setState(() {
                                              _password = password;
                                            });
                                          },
                                          controller: _passwordController,
                                          obscureText: secure,
                                          cursorColor: Colors.white,
                                          enableInteractiveSelection: false,
                                          style: GoogleFonts.lato(
                                            fontSize: 17.5,
                                            color: Colors.white,
                                          ),
                                          decoration: InputDecoration(
                                              disabledBorder: InputBorder.none,
                                              suffixIcon: IconButton(
                                                icon: secure
                                                    ? Icon(Icons.lock_outline,
                                                        size: 26)
                                                    : Icon(Icons.lock_open,
                                                        size: 26),
                                                color: Colors.grey[500],
                                                onPressed: () {
                                                  setState(() {
                                                    secure = !secure;
                                                  });
                                                },
                                              ),
                                              enabledBorder: InputBorder.none,
                                              border: InputBorder.none,
                                              errorStyle: GoogleFonts.lato(
                                                  fontSize: 16),
                                              hintText: ' Password',
                                              hintStyle: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 17,
                                              )),
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                            //  Container(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: FlatButton(
                                    splashColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    visualDensity: VisualDensity.comfortable,
                                    child: Container(
                                        child: Center(
                                            child: Text(
                                          "Login",
                                          style: TextStyle(
                                              fontSize: 19,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        )),
                                        width:
                                            MediaQuery.of(context).size.width -
                                                70,
                                        height: 50),
                                    color: Colors.red.shade700,
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        showloadingscreen(context);
                                        var result = await AuthService()
                                            .signInwithemail(_email.trim(),
                                                _password.trim());
                                        if (result[0]) {
                                          Navigator.of(context).pop();
                                          Phoenix.rebirth(context);
                                        } else {
                                          Navigator.of(context).pop();
                                          showAlertDialog(context, result[1]);
                                        }
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                          color: Colors.white,
                                          width: 1.0,
                                        ))),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 3.0),
                                          child: RichText(
                                            text: TextSpan(
                                              text: "Don't have an account?",
                                              style: GoogleFonts.lato(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _emailController.clear();
                                          _passwordController.clear();
                                          Navigator.of(context).push(
                                            CupertinoPageRoute(
                                              builder: (_) => SignUp(),
                                            ),
                                          );
                                        },
                                        child: RichText(
                                          text: TextSpan(
                                              text: ' Sign up',
                                              style: GoogleFonts.lato(
                                                fontSize: 16,
                                                color: Colors.red.shade700,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ),
                    Container(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
