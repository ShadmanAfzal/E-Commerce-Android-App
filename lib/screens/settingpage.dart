import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:dynamic_theme/theme_switcher_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newnippon/screens/carts.dart';
import 'package:newnippon/screens/loginpage.dart';
import 'package:newnippon/screens/orders.dart';
import 'package:newnippon/services/authservice.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  void showChooser() {
    showDialog<void>(
        context: context,
        builder: (context) {
          return BrightnessSwitcherDialog(
            onSelectedTheme: (brightness) {
              DynamicTheme.of(context).setBrightness(brightness);
              // Phoenix.rebirth(context);
            },
          );
        });
  }

  @override
  void initState() {
    super.initState();
  }

  showalert(BuildContext context, ThemeData color) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: color.dialogBackgroundColor,
            title: Center(
                child: Text(
              'Delete Account',
              style: TextStyle(
                  color: (color.brightness == Brightness.light)
                      ? Colors.black
                      : Colors.white),
            )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "Once Deleted, can't be restore",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: (color.brightness != Brightness.light)
                                  ? Colors.amber
                                  : Colors.red.shade700,
                              fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlatButton(
                        child: Text('Cancel',
                            style: TextStyle(
                                fontSize: 17,
                                color: (color.brightness == Brightness.light)
                                    ? Colors.black
                                    : Colors.white)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    FlatButton(
                        child: Text('Confirm',
                            style: TextStyle(
                                fontSize: 16,
                                color: (color.brightness == Brightness.light)
                                    ? Colors.black
                                    : Colors.white)),
                        onPressed: () {
                          AuthService().deleteAccount();
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        })
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        // leading: Container(),
        iconTheme: IconThemeData(color: Theme.of(context).cardColor),
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          "Settings",
          style: TextStyle(
              fontFamily: "MeriendaOne",
              color: Theme.of(context).cardColor,
              fontSize: 17),
        ),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => Carts()));
                },
                visualDensity: VisualDensity.comfortable,
                leading: SvgPicture.asset(
                  "images/shopper.svg",
                  color: Theme.of(context).cardColor,
                  height: 26,
                ),
                title: Text(
                  "My Cart",
                  style: GoogleFonts.lato(
                      color: Theme.of(context).cardColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Divider(thickness: 0.6),
              ListTile(
                visualDensity: VisualDensity.comfortable,
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => Orders()));
                },
                leading: SvgPicture.asset(
                  "images/order.svg",
                  color: Theme.of(context).cardColor,
                  height: 27,
                ),
                title: Text(
                  "My Orders",
                  style: GoogleFonts.lato(
                      color: Theme.of(context).cardColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Divider(thickness: 0.6),
              ListTile(
                onTap: () {
                  AuthService().signOut();
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => LoginPage()));
                },
                visualDensity: VisualDensity.comfortable,
                leading: Icon(
                  Icons.exit_to_app,
                  color: Theme.of(context).cardColor,
                  size: 26,
                ),
                title: Text(
                  "Logout",
                  style: GoogleFonts.lato(
                      color: Theme.of(context).cardColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Divider(thickness: 0.6),
              ListTile(
                onTap: () {
                  DynamicTheme.of(context).setBrightness(
                      Theme.of(context).brightness == Brightness.dark
                          ? Brightness.light
                          : Brightness.dark);
                },
                visualDensity: VisualDensity.comfortable,
                leading: FaIcon(
                  Theme.of(context).brightness == Brightness.light
                      ? FontAwesomeIcons.moon
                      : FontAwesomeIcons.sun,
                  color: Theme.of(context).cardColor,
                  size: 25,
                ),
                title: Text(
                  Theme.of(context).brightness == Brightness.light
                      ? "Dark Theme"
                      : "Light Theme",
                  style: GoogleFonts.lato(
                      color: Theme.of(context).cardColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Divider(thickness: 0.6),
              ListTile(
                visualDensity: VisualDensity.comfortable,
                onTap: () {
                  showalert(context, Theme.of(context));
                },
                leading: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).cardColor,
                  size: 26,
                ),
                title: Text(
                  "Delete Account",
                  style: GoogleFonts.lato(
                      color: Theme.of(context).cardColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          )),
    );
  }
}
