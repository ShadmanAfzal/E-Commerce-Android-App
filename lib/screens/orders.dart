import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newnippon/screens/detailspage.dart';
import 'package:newnippon/screens/products.dart';
import 'package:newnippon/services/authservice.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  String uid = "";
  bool isloading = true;
  bool hasData = false;
  List<bool> hide;
  int length = 0;
  getuid() async {
    uid = await AuthService().getuseruid();
    QuerySnapshot result = await Firestore.instance
        .collection("User")
        .document(uid)
        .collection("Order")
        .getDocuments();
    if (result.documents.length != 0)
      setState(() {
        hasData = true;
      });

    if (result.documents.length != 0)
      hide = List<bool>.filled(result.documents.length, false);
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    getuid();
    super.initState();
  }

  showalertDialog(BuildContext context, ThemeData color, documentID, index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: color.dialogBackgroundColor,
            title: Center(
                child: Text(
              'Remove Order from My Account?',
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
                                fontSize: 17,
                                color: (color.brightness == Brightness.light)
                                    ? Colors.black
                                    : Colors.white)),
                        onPressed: () {
                          Firestore.instance
                              .collection("User")
                              .document(uid)
                              .collection("Order")
                              .document(documentID)
                              .delete();
                          Navigator.of(context).pop();
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
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).cardColor),
          title: Text(
            "My Orders",
            style: TextStyle(
              fontFamily: "MeriendaOne",
              color: Theme.of(context).cardColor,
            ),
          ),
        ),
        body: isloading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
              )
            : hasData
                ? StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection("User")
                        .document(uid)
                        .collection("Order")
                        .snapshots(),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                          ),
                        );
                      if (snapshot.hasData) {
                        return ListView.separated(
                          separatorBuilder: (_, int x) {
                            return Divider(
                              endIndent: 25,
                              indent: 25,
                              thickness: 2,
                            );
                          },
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 2.0),
                              child: Center(
                                child: Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  color: Theme.of(context).backgroundColor,
                                  // elevation: 0.8,
                                  child: Container(
                                    // height: 120,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Total Amount : ₹" +
                                                    double.parse(snapshot
                                                            .data
                                                            .documents[index]
                                                            .data["amount"])
                                                        .toString()
                                                        .toString(),
                                                style: GoogleFonts.lato(
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () => setState(() {
                                                      hide[index] =
                                                          !hide[index];
                                                    }),
                                                    child: Text(
                                                      "View Details",
                                                      style: GoogleFonts.lato(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    splashColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    onPressed: () {
                                                      setState(() {
                                                        hide[index] =
                                                            !hide[index];
                                                      });
                                                    },
                                                    icon: RotatedBox(
                                                      quarterTurns: 1,
                                                      child: Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    iconSize: 20.0,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          Text(
                                            DateFormat.yMMMd()
                                                .add_jm()
                                                .format((snapshot
                                                        .data
                                                        .documents[index]
                                                        .data['Date'])
                                                    .toDate())
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Theme.of(context)
                                                    .cardColor),
                                          ),
                                          // SizedBox(height:5),
                                          Container(
                                            height: hide[index] ? null : 0,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 7),
                                                for (int i = 0;
                                                    i <
                                                        snapshot
                                                            .data
                                                            .documents[index]
                                                            .data["imageurl"]
                                                            .length;
                                                    i++)
                                                  GestureDetector(
                                                    onTap: () => Navigator.of(
                                                            context)
                                                        .push(MaterialPageRoute(
                                                            builder: (_) =>
                                                                ProductDetails(
                                                                  id: snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data["order_id"][i],
                                                                  imageurl: snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data["imageurl"][i],
                                                                  type: snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data["desc"][i],
                                                                ))),
                                                    child: Card(
                                                      elevation: 0,
                                                      color: Theme.of(context)
                                                          .backgroundColor,
                                                      child: Container(
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Center(
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl: snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data["imageurl"][i],
                                                                  progressIndicatorBuilder: (context,
                                                                          url,
                                                                          downloadProgress) =>
                                                                      Container(
                                                                    width: 120,
                                                                    height: 106,
                                                                    child:
                                                                        Center(
                                                                      child: CircularProgressIndicator(
                                                                          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context)
                                                                              .primaryColor),
                                                                          value:
                                                                              downloadProgress.progress),
                                                                    ),
                                                                  ),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      Center(
                                                                          child:
                                                                              Icon(Icons.error)),
                                                                  height: 90,
                                                                  width: 120,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 8,
                                                            ),
                                                            Flexible(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                      height:
                                                                          5),
                                                                  Text(
                                                                    snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data["Item"][i],
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          17,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .cardColor,
                                                                      // debugLabel: "Hello"
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          5),
                                                                  Text(
                                                                    NumberFormat
                                                                            .simpleCurrency()
                                                                        .format(int.parse(snapshot.data.documents[index].data["cost"]
                                                                            [
                                                                            i]))
                                                                        .replaceAll(
                                                                            "\$",
                                                                            "₹"),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                SizedBox(height: 5),
                                                Text(
                                                  "Address :  ${snapshot.data.documents[index].data["address"]} ${snapshot.data.documents[index].data["apartment"]} ${snapshot.data.documents[index].data["landmark"]} ${snapshot.data.documents[index].data["city"]} (${snapshot.data.documents[index].data["state"]}) ${snapshot.data.documents[index].data["pincode"]}",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .cardColor,
                                                      fontSize: 17),
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Flexible(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .green.shade700,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: Text(
                                                            snapshot
                                                                    .data
                                                                    .documents[
                                                                        index]
                                                                    .data[
                                                                "ORDERID"],
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                        child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .red.shade600,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(7)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            showalertDialog(
                                                              context,
                                                              Theme.of(context),
                                                              snapshot
                                                                  .data
                                                                  .documents[
                                                                      index]
                                                                  .documentID,
                                                              index,
                                                            );
                                                          },
                                                          child: Container(
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Icon(
                                                                  Icons.clear,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                Text(
                                                                  "Delete",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else
                        return Container();
                    },
                  )
                : Container(
                  child:
                   Container(
                            child: Column(
                              children: [
                                SizedBox(height: 20,),
                                Image.asset(
                                  "images/empty-search.png",
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(
                                  height: 22,
                                ),
                                Text("No Order Placed yet",
                                    style: TextStyle(
                                        color: Theme.of(context).cardColor,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                  ));
  }
}
