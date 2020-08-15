import 'package:flutter/material.dart';
import 'package:newnippon/services/databaseclient.dart';
import 'package:newnippon/widgetslib.dart/productcards.dart';

class Favourite extends StatefulWidget {
  final TabController controller;
  Favourite({Key key, this.controller}) : super(key: key);

  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              widget.controller.animateTo(0);
            }),
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text("Favourite Products",
            style: TextStyle(
                color: Theme.of(context).cardColor,
                fontFamily: "MeriendaOne",
                )),
        iconTheme: IconThemeData(
          color: Theme.of(context).cardColor,
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: ProductDatabaseProvider.db.getAllPersons(),
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      type: snapshot.data[index].type,
                      id: snapshot.data[index].id.toString(),
                      imageurl: snapshot.data[index].imageurl,
                      price: snapshot.data[index].price
                          .toString()
                          .replaceFirst("₹", ""),
                      title: snapshot.data[index].title,
                    );
                  });
            else
              return Container(
                  );
             
          },
        ),
      ),
    );
  }
}
