import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newnippon/screens/detailspage.dart';
import 'package:newnippon/services/authservice.dart';
import 'package:newnippon/services/databaseclient.dart';
import 'package:newnippon/services/models.dart';
import 'package:newnippon/widgetslib.dart/productcards.dart';
import '../services/cartsfunc.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetails extends StatefulWidget {
  final String imageurl;
  final String type;
  final String id;
  ProductDetails({Key key, this.id, this.imageurl, this.type})
      : super(key: key);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails>
    with SingleTickerProviderStateMixin {
  TransformationController _transformationController =
      TransformationController();
  bool favourite = false;
  Product product;
  bool isloading = true;
  Animation<double> _animation;
  AnimationController _animecontroller;
  List<Widget> imageSliders = List<Widget>();
  String _details = "";
  String title = "";
  String cost = "";
  int discountprice = 0;
  String discount = "";

  getdetails() async {
    await Firestore.instance
        .collection("Details")
        .document(widget.id)
        .get()
        .then((value) {
      value.data.forEach((key, ans) {
        if (key.contains("image")) {
          setState(
            () {
              imageSliders.add(
                GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      favourite = !favourite;
                    });
                  },
                  child: Container(
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      child: InteractiveViewer(
                        transformationController: _transformationController,
                        maxScale: 1.6,
                        minScale: 0.5,
                        onInteractionEnd: (value) {
                          setState(() {
                            _transformationController.toScene(Offset.zero);
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          child: Stack(
                            children: <Widget>[
                              CachedNetworkImage(
                                imageUrl: ans,
                                fit: (widget.type == "mobile")
                                    ? BoxFit.scaleDown
                                    : BoxFit.cover,
                                width: 1000.0,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        Container(
                                  width: 1000,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Theme.of(context).primaryColor),
                                        value: downloadProgress.progress),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  child: Center(child: Icon(Icons.error)),
                                  width: 1000,
                                ),
                              ),
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
        setState(() {
          _details = value.data['desc'];
          title = value.data['title'];
          cost = NumberFormat.simpleCurrency()
              .format(value.data['cost'])
              .replaceAll("\$", "₹");

          discountprice = value.data['discout_cost'];
          discount = (((value.data['cost'] - value.data['discout_cost']) /
                      value.data['cost']) *
                  100)
              .toInt()
              .toString();
          isloading = false;
        });
      });
    });
  }

  checkfavourite() {
    ProductDatabaseProvider.db
        .checkproductWithId(int.parse(widget.id))
        .then((value) {
      if (value.length == 1) {
        setState(() {
          favourite = true;
        });
      }
    });
  }

  @override
  void initState() {
    _animecontroller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100))
          ..addListener(() {
            setState(() {});
          });
    _animation = Tween<double>(begin: 24, end: 32).animate(
        CurvedAnimation(parent: _animecontroller, curve: Curves.bounceOut));
    getdetails();
    checkfavourite();
    super.initState();
  }

  @override
  void dispose() {
    _animecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isloading) {
      return Container(
          color: Theme.of(context).backgroundColor,
          child: Center(
              child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          )));
    } else {
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Material(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.red.shade600,
            child: Container(
              height: 45,
              width: double.infinity,
              child: Row(
                children: [
                  Flexible(
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.red.shade600,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () async {
                        await CartFunction().addtocart(widget.id);
                        Fluttertoast.showToast(
                            msg: "Added to Cart",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: (Theme.of(context).brightness ==
                                    Brightness.light)
                                ? Theme.of(context).primaryColor
                                : Colors.amber.shade800,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                      child: Container(
                        child: Center(
                            child: Text("Add to Cart",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600))),
                        width: MediaQuery.of(context).size.width / 2,
                      ),
                    ),
                  ),
                  Flexible(
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.red.shade600,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () => Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => DetailPage(
                                    imageurl: [widget.imageurl],
                                    id: [widget.id],
                                    type: [widget.type],
                                    name: [title],
                                    amount: ['$discountprice'],
                                  ))),
                      child: Container(
                        child: Center(
                            child: Text("Buy Now",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white))),
                        width: (MediaQuery.of(context).size.width / 2) - 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).cardColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          actions: [
            IconButton(
              onPressed: () {
                if (!favourite) {
                  _animecontroller.forward();
                  _animecontroller.reverse();
                  Product product = Product(
                      id: int.parse(widget.id),
                      title: title,
                      price: cost,
                      type: widget.type,
                      imageurl: widget.imageurl);
                  ProductDatabaseProvider.db.addPersonToDatabase(product);
                } else {
                  ProductDatabaseProvider.db
                      .deletePersonWithId(int.parse(widget.id));
                  _animecontroller.reverse();
                }
                setState(() {
                  favourite = !favourite;
                });
              },
              icon: FaIcon(
                favourite
                    ? FontAwesomeIcons.solidHeart
                    : FontAwesomeIcons.heart,
                size: _animation.value,
                color: favourite
                    ? Theme.of(context).brightness == Brightness.light
                        ? Colors.red.shade600
                        : Colors.white
                    : Theme.of(context).cardColor,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: (widget.type == "laptop") ? 2 : 1.0,
                    enableInfiniteScroll: true,
                    enlargeCenterPage: true,
                  ),
                  items: imageSliders,
                ),
                SizedBox(height: 10),
                Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 19,
                            color: Theme.of(context).cardColor,
                            fontWeight: FontWeight.w600))),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            // color: Colors.green.shade600,
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.teal.shade600),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("4.6",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(width: 5),
                                Icon(Icons.star, color: Colors.white)
                              ]),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text("83,405 ratings",
                          style: TextStyle(
                            fontSize: 18,
                            color: (Theme.of(context).brightness ==
                                    Brightness.dark)
                                ? Theme.of(context).cardColor
                                : Colors.black87,
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Container(
                      child: Row(
                    children: [
                      Text(
                        NumberFormat.simpleCurrency()
                            .format(discountprice)
                            .replaceAll("\$", "₹"),
                        style: GoogleFonts.workSans(
                            color: (Theme.of(context).brightness ==
                                    Brightness.dark)
                                ? Theme.of(context).cardColor
                                : Colors.black87,
                            fontSize: 20.5,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        cost,
                        style: GoogleFonts.workSans(
                            fontSize: 18.5,
                            decoration: TextDecoration.lineThrough,
                            decorationThickness: 1,
                            // color: Colors.black,
                            color: (Theme.of(context).brightness ==
                                    Brightness.dark)
                                ? Theme.of(context).cardColor
                                : Colors.black87,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        discount + "% off",
                        style: TextStyle(
                            fontSize: 18.5,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  )),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    _details.replaceAll("\\n", "\n"),
                    style: GoogleFonts.workSans(
                      fontSize: 17,
                      color: (Theme.of(context).brightness == Brightness.dark)
                          ? Theme.of(context).cardColor
                          : Colors.black87,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Similar Products",
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).cardColor,
                        fontFamily: "MeriendaOne"),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection("Products")
                        .document('WntdoInZ8j7RQJeyMqse')
                        .collection("Laptops")
                        .limit(3)
                        .snapshots(),
                    builder: (context, snapshot) => snapshot.hasData
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => Navigator.of(context)
                                    .push(CupertinoPageRoute(
                                        builder: (_) => ProductDetails(
                                              id: snapshot.data.documents[index]
                                                  .data['id']
                                                  .toString(),
                                              imageurl: snapshot
                                                  .data
                                                  .documents[index]
                                                  .data['imageurl'],
                                              type: snapshot
                                                  .data
                                                  .documents[index]
                                                  .data['type'],
                                            ))),
                                child: ProductCard(
                                  id: snapshot.data.documents[index].data['id']
                                      .toString(),
                                  imageurl: snapshot
                                      .data.documents[index].data['imageurl'],
                                  price: snapshot
                                      .data.documents[index].data['cost']
                                      .toString(),
                                  title: snapshot
                                      .data.documents[index].data['title'],
                                  type: snapshot
                                      .data.documents[index].data['type'],
                                ),
                              );
                            })
                        : Container()),
                SizedBox(height: 60)
              ],
            ),
          ),
        ),
      );
    }
  }
}
