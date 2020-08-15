class Product {
  int id;
  String title;
  String price;
  String imageurl;
  String type;

  Product({this.id,this.title,this.price,this.imageurl,this.type});

  Map<String, dynamic> toMap() => {
      "id": id,
      "title": title,
      "price": price,
      "type": type,
      "imageurl": imageurl
    };

    factory Product.fromMap(Map<String, dynamic> json) => new Product(
        id: json["id"],
        title: json["title"],
        price: json["price"],
        imageurl: json["imageurl"],
        type: json["type"]
      );
 
}