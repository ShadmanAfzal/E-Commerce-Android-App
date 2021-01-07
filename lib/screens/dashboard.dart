import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newnippon/screens/favourite.dart';
import 'package:newnippon/screens/homepage.dart';
import 'package:newnippon/screens/searchbar.dart';
import 'package:newnippon/screens/settingpage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';

class DashBoard extends StatefulWidget {
  DashBoard({Key key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    _controller = TabController(vsync: this, length: 4);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
              accentColor: Colors.red,
              primaryColorDark: (brightness == Brightness.light)
                  ? Colors.red.shade100
                  : Colors.amber.shade100,
              primaryColor: (brightness == Brightness.light)
                  ? Colors.red.shade700
                  : Colors.amber.shade400,
              textTheme: GoogleFonts.latoTextTheme(
                Theme.of(context).textTheme,
              ),
              brightness: brightness,
              backgroundColor: (brightness == Brightness.light)
                  ? Colors.white
                  : Color(0xff424242),
              cardColor: (brightness == Brightness.light)
                  ? Colors.black
                  : Colors.white,
            ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
              color: theme.brightness == Brightness.dark
                  ? Color(0xff424242)
                  : Colors.black,
              debugShowCheckedModeBanner: false,
              title: 'NewNippon',
              theme: theme,
              home: DefaultTabController(
                length: 4,
                initialIndex: 0,
                child: Scaffold(
                  bottomNavigationBar: Material(
                    elevation: 10,
                    child: TabBar(
                      controller: _controller,
                      onTap: (value) {
                        _controller.animateTo(value,
                            curve: Curves.easeOut,
                            duration: Duration(milliseconds: 5));
                      },
                      tabs: [
                        Tab(
                            icon: Icon(
                          Icons.home,
                          size: 23,
                        )),
                        Tab(
                            icon: FaIcon(
                          FontAwesomeIcons.search,
                          size: 23,
                        )),
                        Tab(
                            icon: FaIcon(
                          FontAwesomeIcons.heart,
                          size: 23,
                        )),
                        Tab(
                          icon: Icon(
                            Icons.settings,
                            size: 23,
                          ),
                        )
                      ],
                      indicatorWeight: 3,
                      labelColor: theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      unselectedLabelColor: Colors.grey.shade400,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorPadding: EdgeInsets.only(bottom: 5.0),
                      indicatorColor: theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  body: TabBarView(
                    controller: _controller,
                    children: [
                      HomePage(
                        controller: _controller,
                      ),
                      SearchBar(
                        controller: _controller,
                      ),
                      Favourite(
                        controller: _controller,
                      ),
                      SettingPage()
                    ],
                  ),
                ),
              ));
        });
  }
}
