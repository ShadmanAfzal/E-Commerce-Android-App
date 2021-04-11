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
            icon: Icon(
              Icons.arrow_back,
              color: Colors.red.shade700,
            ),
            onPressed: () {
              widget.controller.animateTo(0);
            }),
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          "Favourite Products",
          style: TextStyle(
            color: Theme.of(context).cardColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ProductCard(
                        isFromHome: true,
                        type: snapshot.data[index].type,
                        id: snapshot.data[index].id.toString(),
                        imageurl: snapshot.data[index].imageurl,
                        price: snapshot.data[index].price
                            .toString()
                            .replaceFirst("₹", ""),
                        title: snapshot.data[index].title,
                      ),
                    );
                  });
            else
              return Container();
          },
        ),
      ),
    );
  }
}
