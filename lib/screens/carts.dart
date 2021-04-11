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
  List<String> amount = [];
  List<String> imageurl = [];
  List<String> item = [];
  List<String> orderid = [];
  List<String> desc = [];
  getuid() async {
    uid = await AuthService().getuseruid();
  }

  checkdatabase() async {
    uid = await AuthService().getuseruid();
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection("User")
        .doc(uid)
        .collection("Cart")
        .get();
    setState(() {
      cartitem = result.docs.length;
      if (cartitem != 0) hasdata = true;
    });
    for (int i = 0; i < result.docs.length; i++) {
      orderid.add(result.docs[i].data()["item_id"].toString());
    }

    for (int i = 0; i < result.docs.length; i++) {
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection("Products")
          .doc('WntdoInZ8j7RQJeyMqse')
          .collection("Laptops")
          .where("id", isEqualTo: int.parse(orderid[i]))
          .get();
      amount.add(result.docs[0].data()["cost"].toString().replaceAll(",", ""));
      item.add(result.docs[0].data()["title"]);
      desc.add(result.docs[0].data()["type"]);
      imageurl.add(result.docs[0].data()["imageurl"]);
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
                  child: TextButton(
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
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
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
                              stream: FirebaseFirestore.instance
                                  .collection("User")
                                  .doc(uid)
                                  .collection("Cart")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.data == null) {
                                  return Container(
                                    child: Text(""),
                                  );
                                } else
                                  return ListView.builder(
                                    itemCount: snapshot.data.docs.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (_, i) {
                                      return StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection("Products")
                                              .doc('WntdoInZ8j7RQJeyMqse')
                                              .collection("Laptops")
                                              .where("id",
                                                  isEqualTo: int.parse(snapshot
                                                      .data.docs[i]
                                                      .data()["item_id"]))
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
                                                itemCount:
                                                    second.data.docs.length,
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
                                                                              id: second.data.docs[index].data()['id'].toString(),
                                                                              imageurl: second.data.docs[index].data()['imageurl'],
                                                                              type: second.data.docs[index].data()['type'],
                                                                            ))),
                                                            child: ProductCard(
                                                              type: second.data
                                                                  .docs[index]
                                                                  .data()['type'],
                                                              id: second.data
                                                                  .docs[index]
                                                                  .data()['id']
                                                                  .toString(),
                                                              imageurl: second
                                                                      .data
                                                                      .docs[index]
                                                                      .data()[
                                                                  'imageurl'],
                                                              price: second.data
                                                                  .docs[index]
                                                                  .data()['cost'],
                                                              title: second.data
                                                                      .docs[index]
                                                                      .data()[
                                                                  'title'],
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
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "User")
                                                                    .doc(uid)
                                                                    .collection(
                                                                        "Cart")
                                                                    .doc(snapshot
                                                                        .data
                                                                        .docs[i]
                                                                        .id)
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
                                fontSize: 20,
                                color: Theme.of(context).cardColor),
                          )
                        ]),
                  ));
  }
}
