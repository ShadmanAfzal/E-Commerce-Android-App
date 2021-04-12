import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newnippon/screens/products.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductCard extends StatelessWidget {
  final bool isFromHome;
  final String id;
  final String title;
  final String imageurl;
  final String price;
  final String type;

  const ProductCard(
      {Key key,
      this.title,
      this.imageurl,
      this.price,
      this.id,
      this.type,
      this.isFromHome})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: false,
      elevation: isFromHome == null ? 0.8 : 3,
      color: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Container(
            height: 106,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
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
                      mainAxisAlignment: MainAxisAlignment.start,
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
                                fontSize: 16,
                                color: Theme.of(context).cardColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 5.0),
                          child: Text("₹ " + price,
                              style: TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.w700,
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
                              child: MaterialButton(
                                  elevation: 0,
                                  highlightColor: Colors.white,
                                  splashColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(CupertinoPageRoute(
                                            builder: (_) => ProductDetails(
                                                  id: id,
                                                  imageurl: imageurl,
                                                  type: type,
                                                )));
                                  },
                                  child: Text(
                                    "Shop Now",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                  color: (Theme.of(context).brightness ==
                                          Brightness.dark)
                                      ? Theme.of(context).backgroundColor
                                      : Colors.red.shade600),
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
      ),
    );
  }
}
