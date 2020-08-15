import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newnippon/screens/products.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductCard extends StatelessWidget {
  final String id;
  final String title;
  final String imageurl;
  final String price;
  final String type;

  const ProductCard(
      {Key key, this.title, this.imageurl, this.price, this.id, this.type})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: false,
      elevation: 0.8,
      color: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      child: Container(
          height: 106,
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  child: CachedNetworkImage(
                      imageUrl: imageurl,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Container(
                                width: 120,
                                height: 106,
                                child: Center(
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor),
                                      value: downloadProgress.progress),
                                ),
                              ),
                      errorWidget: (context, url, error) =>
                          Center(child: Icon(Icons.error)),
                      fit: BoxFit.cover,
                      width: 150,
                      height: 112),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(7),
                      bottomLeft: Radius.circular(7))),
              Flexible(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                        child: Center(
                          child: Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).cardColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 5.0),
                        child: Text("₹ " + price,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? Colors.white
                                  : Colors.black87,
                            )),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FlatButton(
                                highlightColor: Colors.white,
                                splashColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: () {
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (_) => ProductDetails(
                                            id: id,
                                            imageurl: imageurl,
                                            type: type,
                                          )));
                                },
                                child: Text("Shop Now",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).primaryColor)),
                                color: (Theme.of(context).brightness ==
                                        Brightness.dark)
                                    ? Theme.of(context).backgroundColor
                                    : Colors.red.shade100),
                          ),
                        ],
                      )
                    ]),
              ),
              SizedBox(
                height: 5,
              )
            ],
          )),
    );
  }
}
