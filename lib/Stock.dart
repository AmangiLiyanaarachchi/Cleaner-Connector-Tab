import 'dart:async';

// import 'package:cleanconnectortab/Communication.dart';
// import 'package:cleanconnectortab/Stock.dart';
// import 'package:cleanconnectortab/Timer.dart';
// import 'package:cleanconnectortab/constants/DashboardCard.dart';
// import 'package:cleanconnectortab/login.dart';
import 'package:cleanconnectortab/Screen/create%20order.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'Dashboard.dart';
// import 'Models/Card_model.dart';
// import 'constants/SiteInfo_card.dart';
import 'Timer.dart';
import 'constants/const_api.dart';
import 'constants/style.dart';
import 'login.dart';
List<Orders> orderList = [];
class Stock extends StatefulWidget {
  const Stock({Key? key}) : super(key: key);

  @override
  _StockState createState() => _StockState();
}

class _StockState extends State<Stock> {

  // final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isEmptyList = false;
  bool isEmptyUserList = false;
  bool isGetConfirmOrders = false;
  bool isGetPendingOrders = false;
  String searchValue = '';
  bool isSearching = false;
  String url = "${BASE_API2}order/get-order-by-site/${loginSiteData['id']}";
  TextEditingController searchController = TextEditingController();
  String? _selectedValue;
  List<String> listOfOrder = <String>["All Orders", "Confirmed Orders", "Pending Orders"];

  @override
  void initState() {
    super.initState();
    _selectedValue = "All Orders";
  }

  Future<List<Orders>> getOrdersbySiteId() async {
    print("Getting orders.... ${loginSiteData['id']}  \n ${loginSiteData['accessToken']}");
    orderList = [];
    try{
      final response = await Dio().get(
          "${BASE_API2}order/get-order-by-site/${loginSiteData['id']}",
          options: Options(headers: {"Authorization": loginSiteData['accessToken']}));
      var data = response.data['data'];
      print("DATA: $data");
      if (response.statusCode == 200) {
        print("DATA: 1");
        orderList = [];
        for (Map i in data) {
         // if (loginSiteData['id'] == i['site_id']) {
            Orders orders = Orders(
              order_ids: i['reference_no'] == null ? '' : i['reference_no'],
              site_id: i['site_id'] == null ? '' : i['site_id'],
              product_names: i['product_name'] == null
                   ? '' : i['product_name'],
              quantity: i['order_qty'],
              is_approved: i['is_approved'],
            );
            orderList.add(orders);
          }
        print("------------------");
        print(orderList.length);
        if(orderList.length== 0){
          setState(() {
            isEmptyList= true;
          });
        }
      }
      return orderList;
    }on DioException catch (e) {
      setState(() {
        isEmptyList= true;
      });
      if (e.response?.statusCode == 401) {
        print("Bad Error");
        print(e.response?.data["message"]);
        setState(() {
          isEmptyList= true;
        });
      }
      print(e.toString());
      setState(() {
        isLoading = false;
      });
      print(e);
    }
    return orderList;
  }

  Future<List<Orders>> getConfirmOrdersbySiteId() async {
    print("Getting orders.... ${loginSiteData['id']}  \n ${loginSiteData['accessToken']}");
    orderList = [];
    try{
      final response = await Dio().get(
          "${BASE_API2}stock/filter-approved-orders/${loginSiteData['id']}",
          options: Options(headers: {"Authorization": loginSiteData['accessToken']}));
      var data = response.data['data'];
      print("DATA: $data");
      if (response.statusCode == 200) {
        print("DATA: 1");
        orderList = [];
        for (Map i in data) {
          // if (loginSiteData['id'] == i['site_id']) {
          Orders orders = Orders(
            order_ids: i['reference_no'] == null ? '' : i['reference_no'],
            site_id: i['site_id'] == null ? '' : i['site_id'],
            product_names: i['product_name'] == null
                ? '' : i['product_name'],
            quantity: i['order_qty'],
            is_approved: i['is_approved'],
          );
          orderList.add(orders);
        }
        print("------------------");
        print(orderList.length);
        if(orderList.length== 0){
          setState(() {
            isEmptyList= true;
          });
        }
      }
      return orderList;
    }on DioException catch (e) {
      setState(() {
        isEmptyList= true;
      });
      if (e.response?.statusCode == 401) {
        print("Bad Error");
        print(e.response?.data["message"]);
        setState(() {
          isEmptyList= true;
        });
      }
      print(e.toString());
      setState(() {
        isLoading = false;
      });
      print(e);
    }
    return orderList;
  }

  Future<List<Orders>> getPendingOrdersbySiteId() async {
    print("Getting orders.... ${loginSiteData['id']}  \n ${loginSiteData['accessToken']}");
    orderList = [];
    try{
      final response = await Dio().get(
          "${BASE_API2}stock/filter-pending-orders/${loginSiteData['id']}",
          options: Options(headers: {"Authorization": loginSiteData['accessToken']}));
      var data = response.data['data'];
      print("DATA: $data");
      if (response.statusCode == 200) {
        print("DATA: 1");
        orderList = [];
        for (Map i in data) {
          // if (loginSiteData['id'] == i['site_id']) {
          Orders orders = Orders(
            order_ids: i['reference_no'] == null ? '' : i['reference_no'],
            site_id: i['site_id'] == null ? '' : i['site_id'],
            product_names: i['product_name'] == null
                ? '' : i['product_name'],
            quantity: i['order_qty'],
            is_approved: i['is_approved'],
          );
          orderList.add(orders);
        }
        print("------------------");
        print(orderList.length);
        if(orderList.length== 0){
          setState(() {
            isEmptyList= true;
          });
        }
      }
      return orderList;
    }on DioException catch (e) {
      setState(() {
        isEmptyList= true;
      });
      if (e.response?.statusCode == 401) {
        print("Bad Error");
        print(e.response?.data["message"]);
        setState(() {
          isEmptyList= true;
        });
      }
      print(e.toString());
      setState(() {
        isLoading = false;
      });
      print(e);
    }
    return orderList;
  }

  Future<List<Orders>> getFilterOrdersbySiteId() async {
    print("Getting orders.... ${loginSiteData['id']}  \n ${loginSiteData['accessToken']}");
    orderList = [];
    try{
      if(isGetConfirmOrders == false && isGetPendingOrders == false){
        setState(() {
          url = "${BASE_API2}order/get-order-by-site/${loginSiteData['id']}";
        });
      }else if(isGetConfirmOrders == true && isGetPendingOrders == false){
        setState(() {
          url = "${BASE_API2}stock/filter-approved-orders/${loginSiteData['id']}";
        });
      }else if(isGetPendingOrders == true && isGetConfirmOrders == false){
        setState(() {
          url = "${BASE_API2}stock/filter-pending-orders/${loginSiteData['id']}";
        });
      }else{
        setState(() {
          url = "${BASE_API2}order/get-order-by-site/${loginSiteData['id']}";
        });
      }
      final response = await Dio().get(
          url,
          options: Options(headers: {"Authorization": loginSiteData['accessToken']}));
      var data = response.data['data'];
      print("DATA: $data");
      if (response.statusCode == 200) {
        print("DATA: 1");
        orderList = [];
        for (Map i in data) {
          // if (loginSiteData['id'] == i['site_id']) {
          if (i['reference_no'].toString().toLowerCase().startsWith(
              searchValue.toLowerCase()) || i['product_name'].toString().toLowerCase().startsWith(
              searchValue.toLowerCase()) || i['order_qty'].toString().toLowerCase().startsWith(
              searchValue.toLowerCase())) {
            Orders orders = Orders(
              order_ids: i['reference_no'] == null ? '' : i['reference_no'],
              site_id: i['site_id'] == null ? '' : i['site_id'],
              product_names: i['product_name'] == null ? '' : i['product_name'],
              quantity: i['order_qty'],
              is_approved: i['is_approved'],
            );
            orderList.add(orders);
          }
        }
        print("------------------");
        print(orderList.length);
        if(orderList.length== 0){
          setState(() {
            isEmptyList= true;
          });
        }
      }
      return orderList;
    }on DioException catch (e) {
      setState(() {
        isEmptyList= true;
      });
      if (e.response?.statusCode == 401) {
        print("Bad Error");
        print(e.response?.data["message"]);
        setState(() {
          isEmptyList= true;
        });
      }
      print(e.toString());
      setState(() {
        isLoading = false;
      });
      print(e);
    }
    return orderList;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double columnWidth = (screenWidth-100)/4;
    double buttonWidth = (screenWidth-100)/2;
    return WillPopScope(
      onWillPop: () async {
        loginStatus == true?
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const TimerScreen()))
        : Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const Dashboard()));
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text("Orders", style: kboldTitle,),
            backgroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: GestureDetector(
                  onTap: () {
                    loginStatus == true?
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (_) => TimerScreen( ),
                      ) ,
                          (Route<dynamic> route) => false,
                    )
                        :
                    Navigator.push( context, MaterialPageRoute(
                        builder: (context) => Dashboard()
                    ));
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
                  )
              ),
            ),
          ),
          body: Padding(
          padding: const EdgeInsets.all(20.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.0), // Add rounded corners
      boxShadow: const [
      BoxShadow(
      color: Colors.black12,
      offset: Offset(2, 2),
      blurRadius: 2,
      )
      ],
      ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 10, top: 10, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 35,
                        width: buttonWidth,// Set your desired height here
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                5), // Set your desired border radius here
                            border:
                            Border.all(color: kiconColor),
                            color: Colors.black// Add a border color
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 4.0), // Adjust spacing as needed
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: TextField(
                                  controller: searchController,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(color: Colors.white),
                                  onChanged: (value) {
                                    setState(() {
                                      isSearching = true;
                                      searchValue = value.toString();
                                    });
                                    //filterUsers(value);
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Search Order by Reference No or Item or Quantity",
                                    hintStyle: TextStyle(fontSize: 15, color: Colors.white),
                                    hintMaxLines: 2,
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.fromLTRB(0, 10, 15, 10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   width: columnWidth,
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(backgroundColor: kiconColor,),
                      //     onPressed: () {
                      //       if(isGetConfirmOrders == false){
                      //         setState(() {
                      //           isGetConfirmOrders = true;
                      //         });
                      //       }else{
                      //         setState(() {
                      //           isGetConfirmOrders = false;
                      //         });
                      //       }
                      //     },
                      //     child: Text(isGetConfirmOrders == true? 'All Orders' : 'Confirmed Orders'),
                      //   ),
                      // ),
                      Container(
                        alignment: Alignment.center,
                        height: 35,
                        width: columnWidth,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                5), // Set your desired border radius here
                            border:
                            Border.all(color: kiconColor),
                            color: Colors.black// Add a border color
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Colors.black,
                          ),
                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.only(left: 15, right: 15),
                            ),
                            style: const TextStyle(color: Colors.white),
                            value: _selectedValue,
                            items: listOfOrder.map((String priority) {
                              // print(allergyNames.length);
                              return DropdownMenuItem<String>(
                                value: priority,
                                child: Text(priority, style: TextStyle(color: Colors.white),),
                                // enabled: !this.ispreview,
                              );
                            }).toList(),
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            onChanged: (value) {
                              setState(() {
                                _selectedValue = value;
                              });
                              if(_selectedValue == "All Orders"){
                                setState(() {
                                  isGetConfirmOrders = false;
                                  isGetPendingOrders = false;
                                });
                              } else if(_selectedValue == "Confirmed Orders"){
                                setState(() {
                                  isGetPendingOrders = false;
                                  isGetConfirmOrders = true;
                                });
                              } else if(_selectedValue == "Pending Orders"){
                                setState(() {
                                  isGetConfirmOrders = false;
                                  isGetPendingOrders = true;
                                });
                              }
                            },
                            onSaved: (value) {
                              _selectedValue = value.toString();
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: columnWidth,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: kiconColor,),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddOrder(),
                              ),
                            );
                          },
                          child: Text('Place Order'),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(8.0), // Add rounded corners
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(2, 2),
                            blurRadius: 2,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: screenWidth,
                            decoration: BoxDecoration(
                              color: kiconColor,
                              borderRadius:
                              BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8)),
                            ),
                            child: ListTile(
                              title: isLoading == false ?
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: columnWidth,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.transparent,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Reference\nNo",
                                        style: ktableTitle,
                                        textAlign: TextAlign.center,),
                                    ),
                                  ),
                                  Container(
                                    width: columnWidth,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.transparent,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Item",
                                        style: ktableTitle,
                                        textAlign: TextAlign.center,),
                                    ),
                                  ),
                                  Container(
                                    width: columnWidth,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.transparent,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Quantity",
                                        style: ktableTitle,
                                        textAlign: TextAlign.center,),
                                    ),
                                  ),
                                  Container(
                                    width: columnWidth,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.transparent,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Order\nConfirmation",
                                        style: ktableTitle,
                                        textAlign: TextAlign.center,),
                                    ),
                                  ),
                                ],
                              )
                                  : SizedBox(),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: FutureBuilder(
                                future: isSearching == true? getFilterOrdersbySiteId()
                                :isGetConfirmOrders == true ? getConfirmOrdersbySiteId()
                                : isGetPendingOrders == true ? getPendingOrdersbySiteId()
                                    : getOrdersbySiteId(),
                                builder: (context, AsyncSnapshot<List<Orders>> snapshot) {
                                  return orderList.isNotEmpty ? ListView.builder(
                                      itemCount: orderList.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          color: kcardBackgroundColor,
                                          width: screenWidth,
                                          child: ListTile(
                                            title: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  width: columnWidth,
                                                  height: 36,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.white,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      snapshot.data![index].order_ids.toString(),
                                                      style: klistTitle,
                                                      textAlign: TextAlign.center,),
                                                  ),
                                                ),
                                                Container(
                                                  width: columnWidth,
                                                  height: 36,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.white,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      snapshot.data![index].product_names.toString(),
                                                      style: klistTitle,
                                                      textAlign: TextAlign.center,),
                                                  ),
                                                ),
                                                Container(
                                                  width: columnWidth,
                                                  height: 36,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.white,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      snapshot.data![index].quantity.toString(),
                                                      style: klistTitle,
                                                      textAlign: TextAlign.center,),
                                                  ),
                                                ),
                                                Container(
                                                  width: columnWidth,
                                                  height:  36,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.white,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      snapshot.data![index].is_approved == 1 ? "Order Confirmed" : "Pending",
                                                      style: snapshot.data![index].is_approved == 1 ? TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'Open Sans',
                                                        color: Colors.green
                                                      ) : TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'Open Sans',
                                                        color: Colors.amber
                                                      ),
                                                      textAlign: TextAlign.center,),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      })
                                      : (isEmptyList==true)?
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 50.0),
                                    child: Text("No orders to preview"),
                                  )
                                      : const Padding(
                                    padding: EdgeInsets.only(left: 20.0),
                                    child: SpinKitDualRing(
                                      color: kiconColor,
                                      size: 30,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        )
      ),
    );
  }
}

class Orders {
  String order_ids, product_names, site_id;
  int quantity, is_approved;

  Orders(
      {
        required this.site_id,
        required this.order_ids,
        required this.product_names,
        required this.quantity,
        required this.is_approved
      });
}