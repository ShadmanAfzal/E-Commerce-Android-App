import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newnippon/screens/dashboard.dart';
import 'package:newnippon/services/userinfo.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:newnippon/services/authservice.dart';

class DetailPage extends StatefulWidget {
  final List<String> amount;
  final List<String> name;
  final List<String> type;
  final List<String> id;
  final List<String> imageurl;
  DetailPage(
      {Key key, this.amount, this.name, this.type, this.id, this.imageurl})
      : super(key: key);
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Razorpay _razorpay;
  String uid = "";
  String email = "";
  String totalamount = "";
  String address1 = "";
  String address2 = "";
  String landmark = "";
  String city = "";
  String phone = "";
  String state = "Delhi";
  String name = "";
  int pincode = 0;
  int sum = 0;
  String orderid = "";
  Random random;
  bool isSuccess = false;
  final _formKey = GlobalKey<FormState>();
  getrequireddata() async {
    String userid = await AuthService().getuseruid();
    String useremail = await AuthService().getuseremail();
    String username = await Userinfo().getusername();
    widget.amount.forEach((item) {
      sum += int.parse(item);
    });
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      orderid = "ORDER_$id";
      email = useremail;
      uid = userid;
      name = username;
      totalamount = sum.toString();
    });
  }

  @override
  void initState() {
    getrequireddata();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_bFuhq4cpnVwNrm',
      'amount': (double.parse(totalamount) * 100).toString(),
      'name': widget.name.toString().replaceAll("[", "").replaceAll("]", ""),
      'description': "Payment for " +
          widget.type.toString().replaceAll("[", "").replaceAll("]", ""),
      'prefill': {'contact': phone, 'email': email},
      "notes": {
        "orderid": orderid,
        "item": widget.name.toString().replaceAll("[", "").replaceAll("]", ""),
        "name": name,
        "email": email,
        "phone": phone,
        "address": address1,
        "apartment": address2,
        "landmark": landmark,
        "city": city,
        "state": state,
        "pincode": "$pincode"
      },
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  adddatatofirebase() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    Firestore.instance
        .collection("User")
        .document(uid)
        .collection("Order")
        .document(formattedDate)
        .setData({
      "imageurl": widget.imageurl,
      "Item": widget.name,
      "cost": widget.amount,
      "desc": widget.type,
      "order_id": widget.id,
      "address": address1,
      "apartment": address2,
      "landmark": landmark,
      "city": city,
      "state": state,
      "pincode": "$pincode",
      "Date": FieldValue.serverTimestamp(),
      "amount": totalamount,
      "ORDERID": orderid
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    adddatatofirebase();
    setState(() {
      isSuccess = true;
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("failure");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("handleexternal");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(
          color: Theme.of(context).cardColor,
        ),
        elevation: 0,
        
        title: Text(
          !isSuccess?"Enter Shipping Details":"Payment Successful",
          style: TextStyle(
            fontFamily: "MeriendaOne",
            color: Theme.of(context).cardColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: !isSuccess
            ? Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Container(
                          child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            TextFormField(
                              cursorColor: Theme.of(context).cardColor,
                              initialValue: name,
                              style: GoogleFonts.lato(
                                fontSize: 17.5,
                                color: Theme.of(context).cardColor,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 10),
                                hintText: "Name",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                errorStyle: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: (Theme.of(context).brightness ==
                                          Brightness.light)
                                      ? Colors.red.shade600
                                      : Colors.amber.shade600,
                                ),
                                hintStyle: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black54
                                        : Colors.white70),
                                errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                // border: UnderlineInputBorder(
                                //     borderSide: BorderSide(
                                //         color: Theme.of(context).cardColor,
                                //         width: 1.1)),

                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                              ),
                              onSaved: (value) {
                                setState(() {
                                  name = value;
                                });
                              },
                              validator: (value) {
                                if (value.length == 0) return "Enter Name";
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              cursorColor: Theme.of(context).cardColor,
                              initialValue: email,
                              style: GoogleFonts.lato(
                                fontSize: 17.5,
                                color: Theme.of(context).cardColor,
                              ),
                              decoration: InputDecoration(
                                hintText: "Email ID",
                                focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                errorStyle: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: (Theme.of(context).brightness ==
                                          Brightness.light)
                                      ? Colors.red.shade600
                                      : Colors.amber.shade600,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                hintStyle: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black54
                                        : Colors.white70),
                                errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 10),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                              ),
                              onSaved: (value) {
                                setState(() {
                                  email = value;
                                });
                              },
                              validator: (value) {
                                if (value.length == 0) return "Enter Email";
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              cursorColor: Theme.of(context).cardColor,
                              style: GoogleFonts.lato(
                                  color: Theme.of(context).cardColor,
                                  fontSize: 17.5),
                              keyboardType: TextInputType.numberWithOptions(),
                              decoration: InputDecoration(
                                hintText: "Phone Number",
                                errorStyle: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: (Theme.of(context).brightness ==
                                          Brightness.light)
                                      ? Colors.red.shade600
                                      : Colors.amber.shade600,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                hintStyle: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black54
                                        : Colors.white70),
                                focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 10),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                              ),
                              onSaved: (value) {
                                setState(() {
                                  phone = value;
                                });
                              },
                              validator: (value) {
                                if (value.length == 0) return "Enter Phone";
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              cursorColor: Theme.of(context).cardColor,
                              style: GoogleFonts.lato(
                                  color: Theme.of(context).cardColor,
                                  fontSize: 17.5),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: "Address",
                                errorStyle: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: (Theme.of(context).brightness ==
                                          Brightness.light)
                                      ? Colors.red.shade600
                                      : Colors.amber.shade600,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                hintStyle: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black54
                                        : Colors.white70),
                                errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 10),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                              ),
                              onSaved: (value) {
                                setState(() {
                                  address1 = value;
                                });
                              },
                              validator: (value) {
                                if (value.length == 0)
                                  return "Enter Address";
                                else if (value.length < 5)
                                  return "Enter Valid Address";
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              cursorColor: Theme.of(context).cardColor,
                              style: GoogleFonts.lato(
                                  color: Theme.of(context).cardColor,
                                  fontSize: 17.5),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Apartment No.",
                                errorStyle: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: (Theme.of(context).brightness ==
                                          Brightness.light)
                                      ? Colors.red.shade600
                                      : Colors.amber.shade600,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                hintStyle: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black54
                                        : Colors.white70),
                                errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 10),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                              ),
                              onSaved: (value) {
                                setState(() {
                                  address2 = value;
                                });
                              },
                              validator: (value) {
                                if (value.length == 0) return "Enter Address";
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              cursorColor: Theme.of(context).cardColor,
                              style: GoogleFonts.lato(
                                  color: Theme.of(context).cardColor,
                                  fontSize: 17.5),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Landmark",
                                errorStyle: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: (Theme.of(context).brightness ==
                                          Brightness.light)
                                      ? Colors.red.shade600
                                      : Colors.amber.shade600,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                hintStyle: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black54
                                        : Colors.white70),
                                errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 10),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                              ),
                              onSaved: (value) {
                                setState(() {
                                  landmark = value;
                                });
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              cursorColor: Theme.of(context).cardColor,
                              style: GoogleFonts.lato(
                                  color: Theme.of(context).cardColor,
                                  fontSize: 17.5),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "City",
                                errorStyle: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: (Theme.of(context).brightness ==
                                          Brightness.light)
                                      ? Colors.red.shade600
                                      : Colors.amber.shade600,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                hintStyle: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black54
                                        : Colors.white70),
                                errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 10),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 1.1)),
                              ),
                              onSaved: (value) {
                                setState(() {
                                  city = value;
                                });
                              },
                              validator: (value) {
                                if (value.length == 0) return "Enter City";
                              },
                            ),
                            SizedBox(height: 10),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  DropdownButton<String>(
                                    underline: Container(
                                      height: 1.1,
                                      color: Theme.of(context).cardColor,
                                    ),
                                    iconSize: 30,
                                    style: GoogleFonts.lato(
                                        color: Theme.of(context).cardColor,
                                        fontSize: 17.5),
                                    value: state,
                                    hint: Text("Enter State"),
                                    items: <String>[
                                      'Andhra Pradesh',
                                      'Arunachal Pradesh',
                                      'Assam',
                                      'Bihar',
                                      'Chhattisgarh',
                                      'Delhi',
                                      'Goa',
                                      'Gujarat',
                                      'Haryana',
                                      'Himachal Pradesh',
                                      'Jammu & Kashmir',
                                      'Jharkhand',
                                      'Karnataka',
                                      'Kerala',
                                      'Madhya Pradesh',
                                      'Maharashtra',
                                      'Manipur',
                                      'Meghalaya',
                                      'Mizoram',
                                      'Nagaland',
                                      'Odisha',
                                      'Punjab',
                                      'Rajasthan',
                                      'Sikkim',
                                      'Tamil Nadu',
                                      'Tripura',
                                      'Uttarakhand',
                                      'Uttar Pradesh',
                                      'West Bengal',
                                    ].map((String value) {
                                      return new DropdownMenuItem<String>(
                                        value: value,
                                        child: new Text(value,
                                            style: GoogleFonts.lato(
                                                color:
                                                    Theme.of(context).cardColor,
                                                fontSize: 17.5)),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        state = value;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: TextFormField(
                                        cursorColor:
                                            Theme.of(context).cardColor,
                                        keyboardType: TextInputType.number,
                                        style: GoogleFonts.lato(
                                          fontSize: 17.5,
                                          color: Theme.of(context).cardColor,
                                        ),
                                        decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .cardColor,
                                                    width: 1.1)),
                                            errorBorder: UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .cardColor,
                                                    width: 1.1)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .cardColor,
                                                    width: 1.1)),
                                            contentPadding: EdgeInsets.symmetric(
                                                vertical: 6.0, horizontal: 10),
                                            border: UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .cardColor,
                                                    width: 1.1)),
                                            errorStyle: TextStyle(
                                              fontSize: 15,
                                              color: (Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light)
                                                  ? Colors.red.shade600
                                                  : Colors.amber.shade600,
                                            ),
                                            focusedErrorBorder: UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                borderSide: BorderSide(color: Theme.of(context).cardColor, width: 1.1)),
                                            hintStyle: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black54 : Colors.white70),
                                            hintText: "Pincode",
                                            helperText: ""),
                                        onSaved: (value) {
                                          setState(() {
                                            pincode = int.parse(value);
                                          });
                                        },
                                        validator: (value) {
                                          if (value.length == 0)
                                            return "Enter Pincode";
                                        },
                                      ),
                                    ),
                                  ),
                                ])
                          ],
                        ),
                      )),
                    ),
                    SizedBox(height: 20),
                    FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)),
                        color: Colors.red.shade600,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            openCheckout();
                          }
                        },
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width - 50,
                          child: Center(
                              child: Text("Place Order",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600))),
                        ))
                  ],
                ),
              )
            : Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height:50),
                    Image.asset(
                      "images/Success_payment.png",
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                    ),
                    SizedBox(height:40),

                    FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      color: Colors.teal.shade500,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("Back to HomePage",style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600
                        )),
                      ),
                      onPressed: () => Navigator.of(context).pop()),
                    
                  ],
                ),
              ),
      ),
    );
  }
}
