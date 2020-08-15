import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newnippon/services/authservice.dart';

class CartFunction {
  addtocart(id) async {
    String uid = await AuthService().getuseruid();
    Firestore.instance
        .collection("User")
        .document(uid)
        .collection("Cart")
        .add({"item_id": id});
  return "success";
  }
}
