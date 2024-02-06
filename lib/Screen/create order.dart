import 'dart:io';
import 'package:cleanconnectortab/Screen/site_recomondation.dart';
import 'package:cleanconnectortab/Stock.dart';
import 'package:cleanconnectortab/constants/const_api.dart';
import 'package:cleanconnectortab/constants/style.dart';
import 'package:cleanconnectortab/widget/text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart' as dioo;
import 'package:http_parser/http_parser.dart';

import '../login.dart';

class AddOrder extends StatefulWidget {
  @override
  _AddOrderState createState() =>
      _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController productname = new TextEditingController();
  TextEditingController quantity = new TextEditingController();
  TextEditingController description = new TextEditingController();
  bool isLoading = false;

  createOrder () async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await Dio().post(
          "${BASE_API2}order/place-order",
          data: {
            "product_name" : productname.text,
            "site_id" : loginSiteData['id'],
            "qty" : quantity.text,
            "description": description.text
          },
          options: Options(headers: {
            "Authorization": "Bearer " + loginSiteData["accessToken"]
          }));
      print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      print("Response*** => ${response.data["status"]}");
      setState(() {
        isLoading = false;
      });
      if (response.data["status"] == true && response.data["message"] == "Order placed Successfully") {
        print("Order placed Successfully");
        showSuccessDialog(context);
      } else if (response.data["status"] == false) {

      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        print("Bad Error");
        print(e.response);
        var message = e.response?.data["message"];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 100,
              right: 5,
              left: 5),
        ));


      } else if((e.response?.statusCode == 401)){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Session expired. Please Login again"),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: EdgeInsets.only(
              right: 5,
              left: 5,
              top: 100),
        ));
      }
      print(e.toString());
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  void showSubmitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text('Registration successful'),
          content: Text('Do you want to submit?'),
          actions: <Widget>[
            TextButton(
              child: Text('NO'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('YES'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                createOrder();
              },
            ),
          ],
        );
      },
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text("Order placed Successfully"),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  productname.clear();
                  description.clear();
                  quantity.clear();
                });
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Stock()));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const Stock()));
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text(
              "Place Order",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: kiconColor,
              ),
            ),
            backgroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Stock()));
                },
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: kiconColor,
                  child: CircleAvatar(
                    radius: 17,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.arrow_back,
                      color: kiconColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(2, 2),
                    blurRadius: 2,
                  ),
                ],
              ),

              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: SingleChildScrollView(
                  reverse: true,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Column(
                                children: [
                                  Row(children: [
                                    const Icon(
                                      Icons.production_quantity_limits,
                                      color: kiconColor,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      child: const Text(
                                        "Product Name ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: kiconColor,
                                            fontFamily: "OpenSans"),
                                      ),
                                    ),
                                    Container(
                                      width: 10,
                                      child: const Text(
                                        ":",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: kiconColor,
                                            fontFamily: "OpenSans"),
                                      ),
                                    ),
                                  ]),

                                  const SizedBox(
                                    height: 15,
                                  ),

                                  Container(
                                    // padding: EdgeInsets.only(top: 20, bottom: 20),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            offset: Offset(2, 2),
                                            blurRadius: 2,
                                          )
                                        ],
                                        color: const Color.fromRGBO(
                                            241, 239, 239, 0.298),
                                        border: Border.all(
                                            width: 0, color: Colors.white),
                                        borderRadius: BorderRadius.circular(11)),
                                    // width: width,
                                    child: TextFormField(
                                      controller: productname,
                                      enabled: true,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                          ),
                                          // borderSide: BorderSide.none
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                          borderSide: const BorderSide(
                                            color: kiconColor,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                          borderSide:
                                          const BorderSide(color: Colors.red),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                          borderSide:
                                          const BorderSide(color: Colors.red),
                                        ),
                                        isDense: true,
                                        contentPadding: const EdgeInsets.fromLTRB(
                                            15, 30, 15, 0),
                                        hintText: "Product Name",
                                        hintStyle: const TextStyle(
                                            color: Colors.black54, fontSize: 14),
                                      ),
                                      style: const TextStyle(color: Colors.black),
                                      validator: (String? u_name) {
                                        if (u_name != null && u_name.isEmpty) {
                                          return "Product name can't be empty";
                                        } else {
                                          return null;
                                        }
                                      },
                                      autovalidateMode: AutovalidateMode.onUserInteraction,

                                    ),
                                  ),

                                  const SizedBox(
                                    height: 30,
                                  ),

                                  Row(children: [
                                    const Icon(
                                      Icons.text_snippet_outlined,
                                      color: kiconColor,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      child: const Text(
                                        "Description ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: kiconColor,
                                            fontFamily: "OpenSans"),
                                      ),
                                    ),
                                    Container(
                                      width: 10,
                                      child: const Text(
                                        ":",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: kiconColor,
                                            fontFamily: "OpenSans"),
                                      ),
                                    ),
                                  ]),

                                  const SizedBox(
                                    height: 15,
                                  ),

                                  Container(
                                    // padding: EdgeInsets.only(top: 20, bottom: 20),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            offset: Offset(2, 2),
                                            blurRadius: 2,
                                          )
                                        ],
                                        color: const Color.fromRGBO( 241, 239, 239, 0.298),
                                        border: Border.all( width: 0, color: Colors.white),
                                        borderRadius: BorderRadius.circular(11)),
                                    // width: width,
                                    child: TextFormField(
                                      controller: description,
                                      enabled: true,
                                      maxLength: 50,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                          ),
                                          // borderSide: BorderSide.none
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                          borderSide: const BorderSide(
                                            color: kiconColor,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                          borderSide:
                                          const BorderSide(color: Colors.red),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                          borderSide:
                                          const BorderSide(color: Colors.red),
                                        ),
                                        isDense: true,
                                        contentPadding: const EdgeInsets.fromLTRB(
                                            15, 30, 15, 0),
                                        hintText: "Description",
                                        hintStyle: const TextStyle(
                                            color: Colors.black54, fontSize: 14),
                                      ),
                                      style: const TextStyle(color: Colors.black),
                                      // validator: (String? u_name) {
                                      //   if (u_name != null && u_name.isEmpty) {
                                      //     return "Description can't be empty";
                                      //   } else {
                                      //     return null;
                                      //   }
                                      // },
                                      autovalidateMode: AutovalidateMode.onUserInteraction,

                                    ),
                                  ),


                                  const SizedBox(
                                    height: 30,
                                  ),

                                  Row(children: [
                                    const Icon(
                                      Icons.numbers,
                                      color: kiconColor,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      child: const Text(
                                        "Quantity",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: kiconColor,
                                            fontFamily: "OpenSans"),
                                      ),
                                    ),
                                    Container(
                                      width: 10,
                                      child: const Text(
                                        ":",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: kiconColor,
                                            fontFamily: "OpenSans"),
                                      ),
                                    ),
                                  ]),

                                  const SizedBox(
                                    height: 15,
                                  ),

                                  Container(
                                    // padding: EdgeInsets.only(top: 20, bottom: 20),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            offset: Offset(2, 2),
                                            blurRadius: 2,
                                          )
                                        ],
                                        color: const Color.fromRGBO( 241, 239, 239, 0.298),
                                        border: Border.all( width: 0, color: Colors.white),
                                        borderRadius: BorderRadius.circular(11)),
                                    // width: width,
                                    child: TextFormField(
                                      controller: quantity,
                                      enabled: true,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                      ],
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                          ),
                                          // borderSide: BorderSide.none
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                          borderSide: const BorderSide(
                                            color: kiconColor,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                          borderSide:
                                          const BorderSide(color: Colors.red),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                          borderSide:
                                          const BorderSide(color: Colors.red),
                                        ),
                                        isDense: true,
                                        contentPadding: const EdgeInsets.fromLTRB(
                                            15, 30, 15, 0),
                                        hintText: "Quantity",
                                        hintStyle: const TextStyle(
                                            color: Colors.black54, fontSize: 14),
                                      ),
                                      style: const TextStyle(color: Colors.black),
                                      validator: (String? u_name) {
                                        if (u_name != null && u_name.isEmpty) {
                                          return "Quantity can't be empty";
                                        } else {
                                          return null;
                                        }
                                      },
                                      autovalidateMode: AutovalidateMode.onUserInteraction,

                                    ),
                                  ),

                                  const SizedBox(
                                    height: 30,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (_formKey.currentState!.validate()  ) {
                                        print("Submit");

                                        showSubmitDialog(context);
                                      }
                                    },
                                    child: Buttons_in_form(
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                      text: (isLoading == true)
                                          ? const Padding(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: SpinKitDualRing(
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      )
                                          : Text("Submit",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.white)),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom))
                                ]
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ),




            ),
          ),
        ),
      ),
    );
  }
}


