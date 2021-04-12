import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/authservice.dart';
import './signuppage.dart';
import 'dashboard.dart';

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
    Widget okButton = TextButton(
      child: Text(
        "OK",
        style: TextStyle(fontSize: 16.5, color: Colors.red.shade700),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Text(
        errormsg,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
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
          Text(
            "Please Wait...",
            style: TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
            ),
          ),
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
          backgroundColor: Colors.white,
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
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                          text: "Nippon",
                                          style: TextStyle(
                                            fontSize: 50,
                                            color: Colors.black,
                                            // color: Colors.white,
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
                                            horizontal: 20.0),
                                        child: TextFormField(
                                          style: TextStyle(
                                              fontSize: 16.5,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
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
                                          cursorColor: Colors.black,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              gapPadding: 0,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                gapPadding: 0,
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            hintText: 'Enter your Email ID',
                                            fillColor: Colors.grey.shade100,
                                            filled: true,
                                            errorStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            hintStyle: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
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
                                          cursorColor: Colors.black,
                                          enableInteractiveSelection: false,
                                          style: TextStyle(
                                            fontSize: 16.5,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          decoration: InputDecoration(
                                              disabledBorder: InputBorder.none,
                                              fillColor: Colors.grey.shade100,
                                              filled: true,
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
                                              isDense: true,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                gapPadding: 0,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  gapPadding: 0,
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              errorStyle: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              hintText: 'Password',
                                              hintStyle: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
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
                                  child: MaterialButton(
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
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
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
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) => DashBoard(),
                                            ),
                                          );
                                        } else {
                                          Navigator.of(context).pop();
                                          showAlertDialog(context, result[1]);
                                        }
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.white,
                                              width: 0.0,
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 3.0),
                                          child: Text(
                                            "Don't have an account?",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
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
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
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
