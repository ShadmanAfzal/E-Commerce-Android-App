import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newnippon/screens/carts.dart';
import 'package:newnippon/screens/products.dart';
import 'package:newnippon/widgetslib.dart/productcards.dart';

class HomePage extends StatefulWidget {
  final TabController controller;
  HomePage({Key key, this.controller}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List<String> imgList = [
    "images/laptop1.jpg",
    "images/laptop2.jpg",
    "images/laptop3.jpg",
    "images/mobile1.jpg",
    "images/mobile2.jpg",
    "images/mobile3.jpg"
  ];
  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.asset(item, fit: BoxFit.cover, width: 1000.0),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
            ),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {});
                  Navigator.of(context)
                      .push(CupertinoPageRoute(builder: (_) => Carts()));
                },
                child: Stack(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.red.shade700,
                        size: 28,
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .push(CupertinoPageRoute(builder: (_) => Carts()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        centerTitle: true,
        elevation: 0,
        title: Row(
          children: [
            Icon(
              Icons.search,
              size: 27,
              color: Colors.red.shade700,
            ),
            GestureDetector(
              child: Text(
                "Search for deals...",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).cardColor),
              ),
              onTap: () {
                widget.controller.animateTo(1,
                    curve: Curves.bounceInOut,
                    duration: Duration(milliseconds: 300));
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                  ),
                  items: imageSliders ?? [],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 4),
                  child: Text(
                    "Laptops",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).cardColor,
                    ),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Products")
                        .doc('WntdoInZ8j7RQJeyMqse')
                        .collection("Laptops")
                        .orderBy('upload_time', descending: true)
                        .where("type", isEqualTo: "laptop")
                        .snapshots(),
                    // ignore: missing_return
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 60,
                            ),
                            Center(
                                child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                            )),
                          ],
                        );
                      }
                      if (snapshot.hasData) {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.docs.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () =>
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (_) => ProductDetails(
                                            id: snapshot.data.docs[index]
                                                .data()['id']
                                                .toString(),
                                            imageurl: snapshot.data.docs[index]
                                                .data()['imageurl'],
                                            type: snapshot.data.docs[index]
                                                .data()['type'],
                                          ))),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ProductCard(
                                    isFromHome: true,
                                    type: snapshot.data.docs[index]
                                        .data()['type'],
                                    imageurl: snapshot.data.docs[index]
                                        .data()['imageurl'],
                                    title: snapshot.data.docs[index]
                                        .data()['title'],
                                    price: snapshot.data.docs[index]
                                        .data()['cost'],
                                    id: snapshot.data.docs[index]
                                        .data()['id']
                                        .toString()),
                              ),
                            );
                          },
                        );
                      }
                    }),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 4),
                  child: Text("Smart Phones",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).cardColor)),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Products")
                        .doc('WntdoInZ8j7RQJeyMqse')
                        .collection("Laptops")
                        .orderBy('upload_time', descending: true)
                        .where("type", isEqualTo: "mobile")
                        .snapshots(),
                    // ignore: missing_return
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 60,
                            ),
                            Center(
                                child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                            )),
                          ],
                        );
                      }
                      if (snapshot.hasData) {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.docs.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () =>
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (_) => ProductDetails(
                                            id: snapshot.data.docs[index]
                                                .data()['id']
                                                .toString(),
                                            imageurl: snapshot.data.docs[index]
                                                .data()['imageurl'],
                                            type: snapshot.data.docs[index]
                                                .data()['type'],
                                          ))),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ProductCard(
                                    isFromHome: true,
                                    type: snapshot.data.docs[index]
                                        .data()['type'],
                                    imageurl: snapshot.data.docs[index]
                                        .data()['imageurl'],
                                    title: snapshot.data.docs[index]
                                        .data()['title'],
                                    price: snapshot.data.docs[index]
                                        .data()['cost'],
                                    id: snapshot.data.docs[index]
                                        .data()['id']
                                        .toString()),
                              ),
                            );
                          },
                        );
                      }
                    }),
                // SizedBox(height:10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
