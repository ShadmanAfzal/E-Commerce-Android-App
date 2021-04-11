import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newnippon/screens/favourite.dart';
import 'package:newnippon/screens/homepage.dart';
import 'package:newnippon/screens/searchbar.dart';
import 'package:newnippon/screens/settingpage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
    ));
    _controller = TabController(vsync: this, length: 4);
    _controller.addListener(() {
      print("hello");
      setState(() {
        currentIndex = _controller.index;
      });
    });
    super.initState();
  }

  int currentIndex = 0;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        bottomNavigationBar: SalomonBottomBar(
          unselectedItemColor: Colors.grey,
          currentIndex: currentIndex,
          onTap: (value) {
            _controller.animateTo(
              value,
              curve: Curves.easeOut,
              duration: Duration(milliseconds: 5),
            );
            setState(() {
              currentIndex = value;
            });
          },
          items: [
            SalomonBottomBarItem(
                title: Text(
                  "Home",
                  style: TextStyle(fontSize: 16),
                ),
                icon: Icon(
                  Icons.home_outlined,
                  size: 26,
                )),
            SalomonBottomBarItem(
                unselectedColor: Colors.grey,
                title: Text(
                  "Search",
                  style: TextStyle(fontSize: 16),
                ),
                icon: Icon(
                  Icons.search,
                  size: 26,
                )),
            SalomonBottomBarItem(
                unselectedColor: Colors.grey,
                title: Text(
                  "Favourite",
                  style: TextStyle(fontSize: 16),
                ),
                icon: FaIcon(
                  FontAwesomeIcons.heart,
                  size: 23,
                )),
            SalomonBottomBarItem(
              unselectedColor: Colors.grey,
              title: Text(
                "Settings",
                style: TextStyle(fontSize: 16),
              ),
              icon: Icon(
                Icons.settings_outlined,
                size: 26,
              ),
            )
          ],
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
    );
  }
}
