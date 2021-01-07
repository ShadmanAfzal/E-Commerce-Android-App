import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newnippon/screens/products.dart';

class SearchBar extends StatefulWidget {
  final TabController controller;
  SearchBar({Key key, this.controller}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _search;
  String search = "123";
  @override
  void initState() {
    _search = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).cardColor),
            onPressed: () {
              FocusScope.of(context).unfocus();
              widget.controller.animateTo(0);
            }),
        backgroundColor: Theme.of(context).backgroundColor,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Theme.of(context).cardColor),
            onPressed: () {
              setState(() {
                search = _search.value.text;
                _search.clear();
              });
            },
          ),
        ],
        title: TextField(
          controller: _search,
          onChanged: (value) {
            if (value.length > 0)
              setState(() {
                search = value;
              });
            else if (value.length == 0)
              setState(() {
                search = "123456789";
              });
          },
          style: GoogleFonts.lato(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            // fontWeight: FontWeight.w600,
            color: Theme.of(context).cardColor,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: " Search...",
            hintStyle: TextStyle(
                fontSize: 17,
                color: (Theme.of(context).brightness == Brightness.light)
                    ? Colors.grey.shade700
                    : Colors.white70),
          ),
          cursorColor: (Theme.of(context).brightness == Brightness.light)
              ? Colors.black87
              : Colors.white,
          autofocus: true,
          maxLines: 1,
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection("Products")
                      .document('WntdoInZ8j7RQJeyMqse')
                      .collection("Laptops")
                      .where('search',
                          isGreaterThanOrEqualTo: search.toLowerCase())
                      .where('search', isLessThan: search.toLowerCase() + 'z')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                        separatorBuilder: (_, x) {
                          return Divider(
                            thickness: 2,
                            indent: 40,
                            endIndent: 40,
                          );
                        },
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            visualDensity: VisualDensity.comfortable,
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => ProductDetails(
                                      type: snapshot
                                          .data.documents[index].data['type'],
                                      imageurl: snapshot.data.documents[index]
                                          .data['imageurl'],
                                      id: snapshot
                                          .data.documents[index].data['id']
                                          .toString())));
                            },
                            title: Text(
                              snapshot.data.documents[index].data['title'],
                              style: TextStyle(
                                fontSize: 17,
                                color: Theme.of(context).cardColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            leading: Icon(Icons.search,
                                color: Theme.of(context).cardColor),
                            trailing: RotatedBox(
                              child: Icon(Icons.call_made,
                                  color: Theme.of(context).cardColor),
                              quarterTurns: 3,
                            ),
                          );
                        },
                      );
                    } else
                      return Container();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
