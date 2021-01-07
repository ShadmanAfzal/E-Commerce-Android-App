import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newnippon/screens/detailsPage.dart';
import 'package:newnippon/screens/products.dart';
import 'package:newnippon/services/authservice.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:newnippon/widgetslib.dart/productcards.dart';

class Carts extends StatefulWidget {
  Carts({Key key}) : super(key: key);

  @override
  _CartsState createState() => _CartsState();
}

class _CartsState extends State<Carts> {
  String uid = "";
  bool isloading = true;
  bool hasdata = false;
  int cartitem = 0;
  List<String> amount = List<String>();
  List<String> imageurl = List<String>();
  List<String> item = List<String>();
  List<String> orderid = List<String>();
  List<String> desc = List<String>();
  getuid() async {
    uid = await AuthService().getuseruid();
  }

  // ignore: unused_element
  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red.shade600,
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        )));
  }

  checkdatabase() async {
    uid = await AuthService().getuseruid();
    QuerySnapshot result = await Firestore.instance
        .collection("User")
        .document(uid)
        .collection("Cart")
        .getDocuments();
    setState(() {
      cartitem = result.documents.length;
      if (cartitem != 0) hasdata = true;
    });
    for (int i = 0; i < result.documents.length; i++) {
      orderid.add(result.documents[i].data["item_id"].toString());
    }

    for (int i = 0; i < result.documents.length; i++) {
      QuerySnapshot result = await Firestore.instance
          .collection("Products")
          .document('WntdoInZ8j7RQJeyMqse')
          .collection("Laptops")
          .where("id", isEqualTo: int.parse(orderid[i]))
          .getDocuments();
      amount
          .add(result.documents[0].data["cost"].toString().replaceAll(",", ""));
      item.add(result.documents[0].data["title"]);
      desc.add(result.documents[0].data["type"]);
      imageurl.add(result.documents[0].data["imageurl"]);
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    getuid();
    checkdatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: hasdata
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Material(
                  elevation: 3,
                  color: Colors.red.shade600,
                  borderRadius: BorderRadius.circular(10),
                  child: FlatButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onPressed: () {
                      if (item.length != 0) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => DetailPage(
                                  amount: amount,
                                  imageurl: imageurl,
                                  id: orderid,
                                  name: item,
                                  type: desc,
                                )));
                      }
                    },
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      child: Center(
                          child: Text(
                        "Order Now",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      )),
                    ),
                  ),
                ),
              )
            : Container(),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).backgroundColor,
          iconTheme: IconThemeData(
            color: Theme.of(context).cardColor,
          ),
          title: Text(
            (cartitem != 0) ? "My Cart ($cartitem)" : "My Cart",
            style: TextStyle(
              fontFamily: "MeriendaOne",
              fontSize: 17,
              color: Theme.of(context).cardColor,
            ),
          ),
        ),
        body: isloading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  ),
                ),
              )
            : hasdata
                ? SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          child: StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance
                                  .collection("User")
                                  .document(uid)
                                  .collection("Cart")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.data == null) {
                                  return Container(
                                    child: Text(""),
                                  );
                                } else
                                  return ListView.builder(
                                    itemCount: snapshot.data.documents.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (_, i) {
                                      return StreamBuilder<QuerySnapshot>(
                                          stream: Firestore.instance
                                              .collection("Products")
                                              .document('WntdoInZ8j7RQJeyMqse')
                                              .collection("Laptops")
                                              .where("id",
                                                  isEqualTo: int.parse(snapshot
                                                      .data
                                                      .documents[i]
                                                      .data["item_id"]))
                                              .snapshots(),
                                          builder: (_, second) {
                                            if (second.data == null)
                                              return Container(
                                                child: Text(""),
                                              );
                                            else
                                              return ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount: second
                                                    .data.documents.length,
                                                itemBuilder: (_, index) {
                                                  return Stack(
                                                    children: [
                                                      Slidable(
                                                        actionPane:
                                                            SlidableDrawerActionPane(),
                                                        actionExtentRatio: 0.25,
                                                        child: Container(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () => Navigator
                                                                    .of(context)
                                                                .push(
                                                                    MaterialPageRoute(
                                                                        builder: (_) =>
                                                                            ProductDetails(
                                                                              id: second.data.documents[index].data['id'].toString(),
                                                                              imageurl: second.data.documents[index].data['imageurl'],
                                                                              type: second.data.documents[index].data['type'],
                                                                            ))),
                                                            child: ProductCard(
                                                              type: second
                                                                  .data
                                                                  .documents[
                                                                      index]
                                                                  .data['type'],
                                                              id: second
                                                                  .data
                                                                  .documents[
                                                                      index]
                                                                  .data['id']
                                                                  .toString(),
                                                              imageurl: second
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  'imageurl'],
                                                              price: second
                                                                  .data
                                                                  .documents[
                                                                      index]
                                                                  .data['cost'],
                                                              title: second
                                                                  .data
                                                                  .documents[
                                                                      index]
                                                                  .data['title'],
                                                            ),
                                                          ),
                                                        ),
                                                        secondaryActions: [
                                                          IconSlideAction(
                                                              color: Colors
                                                                  .red.shade600,
                                                              iconWidget: Icon(
                                                                  Icons.close,
                                                                  size: 27,
                                                                  color: Colors
                                                                      .white),
                                                              onTap: () async {
                                                                Firestore
                                                                    .instance
                                                                    .collection(
                                                                        "User")
                                                                    .document(
                                                                        uid)
                                                                    .collection(
                                                                        "Cart")
                                                                    .document(snapshot
                                                                        .data
                                                                        .documents[
                                                                            i]
                                                                        .documentID)
                                                                    .delete();
                                                                setState(() {
                                                                  --cartitem;
                                                                  amount
                                                                      .removeAt(
                                                                          i);
                                                                  item.removeAt(
                                                                      i);
                                                                  desc.removeAt(
                                                                      i);
                                                                  orderid
                                                                      .removeAt(
                                                                          i);
                                                                  imageurl
                                                                      .removeAt(
                                                                          i);
                                                                });
                                                              }),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                          });
                                    },
                                  );
                              }),
                        ),
                        SizedBox(height: 60)
                      ],
                    ),
                  )
                : Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("images/empty-cart.png"),
                          SizedBox(height: 10),
                          Text(
                            "No item Found in My Cart!",
                            style: TextStyle(
                                fontSize: 22,
                                color: Theme.of(context).cardColor),
                          )
                        ]),
                  ));
  }
}
