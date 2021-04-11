import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                    TextButton(
                        child: Text('Cancel',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: (color.brightness == Brightness.light)
                                    ? Colors.black
                                    : Colors.white)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    TextButton(
                        child: Text('Confirm',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
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
        iconTheme: IconThemeData(
          color: Colors.red.shade700,
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          "Settings",
          style: TextStyle(
            color: Theme.of(context).cardColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
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
                leading: Icon(
                  Icons.shopping_bag_outlined,
                  size: 27,
                  color: Colors.red.shade700,
                ),
                title: Text(
                  "My Cart",
                  style: TextStyle(
                      color: Theme.of(context).cardColor,
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Divider(thickness: 0.6),
              ListTile(
                visualDensity: VisualDensity.comfortable,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => Orders(),
                    ),
                  );
                },
                leading: Icon(
                  Icons.category,
                  size: 27,
                  color: Colors.red.shade700,
                ),
                title: Text(
                  "My Orders",
                  style: TextStyle(
                      color: Theme.of(context).cardColor,
                      fontSize: 16.5,
                      fontWeight: FontWeight.bold),
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
                  Icons.logout,
                  color: Colors.red.shade700,
                  // color: Theme.of(context).cardColor,
                  size: 26,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(
                      color: Theme.of(context).cardColor,
                      fontSize: 16.5,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Divider(thickness: 0.6),
              ListTile(
                visualDensity: VisualDensity.comfortable,
                onTap: () {
                  showalert(context, Theme.of(context));
                },
                leading: Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red.shade700,

                  // color: Theme.of(context).cardColor,
                  size: 26,
                ),
                title: Text(
                  "Delete Account",
                  style: TextStyle(
                      color: Theme.of(context).cardColor,
                      fontSize: 16.5,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )),
    );
  }
}
