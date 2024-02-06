import 'dart:async';

// import 'package:cleanconnectortab/Communication.dart';
// import 'package:cleanconnectortab/Stock.dart';
// import 'package:cleanconnectortab/Timer.dart';
// import 'package:cleanconnectortab/constants/DashboardCard.dart';
// import 'package:cleanconnectortab/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'Dashboard.dart';
// import 'Models/Card_model.dart';
// import 'constants/SiteInfo_card.dart';
import 'Screen/audit_pdf.dart';
import 'Timer.dart';
import 'constants/const_api.dart';
import 'constants/style.dart';
import 'login.dart';
// import 'logoutButton.dart';
List<Users> userList = [];
class SiteInformation extends StatefulWidget {
  const SiteInformation({Key? key}) : super(key: key);

  @override
  _SiteInformationState createState() => _SiteInformationState();
}

class _SiteInformationState extends State<SiteInformation> {

  // final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isEmptyList = false;
  bool isEmptyUserList = false;
  bool showEmail = false;
  bool showProfile = false;
  bool showstartDate = false;
  bool showendDate = false;
  int columnCount = 3;

  @override
  void initState() {
    super.initState();
    loading();
    print("*******************");
  }

  loading() async{
    await getShowColumns();
  }

  getShowColumns() async {
    setState(() {
      isLoading = true;
    });
    try{
      final response = await Dio().get(
          "${BASE_API2}site/show-coloumn",
          options: Options(headers: {"Authorization": loginSiteData['accessToken']}));
      var data = response.data['showColoumn'];
      setState(() {
        isLoading = false;
      });
      //var data = response.data['showColoumn'];
      print("DATA: ${data.toString()}");
      if (response.statusCode == 200) {
        if(response.data['showColoumn'][0]['email'] == 1){
          setState(() {
            showEmail = true;
            columnCount = columnCount + 1;
          });
        }else{
          setState(() {
            showEmail = false;
          });
        }
        if(response.data['showColoumn'][0]['profile'] == 1){
          setState(() {
            showProfile = true;
            columnCount = columnCount + 1;
          });
        }else{
          setState(() {
            showProfile = false;
          });
        }
        if(response.data['showColoumn'][0]['start_date'] == 1){
          setState(() {
            showstartDate = true;
            columnCount = columnCount + 1;
          });
        }else{
          setState(() {
            showstartDate = false;
          });
        }
        if(response.data['showColoumn'][0]['end_date'] == 1){
          setState(() {
            showendDate = true;
            columnCount = columnCount + 1;
          });
        }else{
          setState(() {
            showendDate = false;
          });
        }
        print("1"+ showEmail.toString());
        print("2"+ showProfile.toString());
        print("3"+ showstartDate.toString());
        print("4"+ showendDate.toString());
      }
    }on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        print("Bad Error");
        print(e.response?.data["message"]);
      }
      print(e.toString());
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  Future<List<Users>> getCleanersbySiteId() async {
    print("Getting users.... ${loginSiteData['id']}  \n ${loginSiteData['accessToken']}");
    userList = [];
    try{
      final response = await Dio().get(
          "${BASE_API2}user/getCleanerUsersBySiteId/${loginSiteData['id']}",
          options: Options(headers: {"Authorization": loginSiteData['accessToken']}));
      var data = response.data['result'];
      print("DATA: $data");
      if (response.statusCode == 200) {
        userList = [];
        for (Map i in data) {
          Users users = Users(
            fname: i['f_name'] == null ? '' : i['f_name'],
            lname: i['l_name'] == null ? '' : i['l_name'],
            email: i['email'],
            id: i['user_id'] == null ? '' : i['user_id'],
            start_date: i['start_date'] == null ? '' : DateFormat("yyyy-MM-dd")
                .format(DateTime.parse(i['start_date'])),
            end_date: i['end_date'] == null ? '' : DateFormat("yyyy-MM-dd")
              .format(DateTime.parse(i['end_date'])),
            phone: i['phone'] == null ? '' : i['phone'],
            doc: (i['url'] == null) ? "No Document" : i['url'],
            image: (i['image'] == null) ? "No image" : i['image'],
            siteid: i['site_name'] == null ? '' : i['site_name'],
            emp_no: i['emp_no'],
          );
          userList.add(users);
        }
        print("------------------");
        print(userList.length);
        if(userList.length== 0){
          setState(() {
            isEmptyList= true;
          });
        }
      }
      return userList;
    }on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        print("Bad Error");
        print(e.response?.data["message"]);
          setState(() {
            isEmptyList= true;
          });
      }
      print(e.toString());
      setState(() {
        isLoading = false;
        isEmptyList= true;
      });
      print(e);
    }
    return userList;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double columnWidth = (screenWidth-100)/columnCount;
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
            title: Text("${loginUserProfile['site_name']} - ${loginUserProfile['name']}", style: kboldTitle,),
            backgroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: GestureDetector(
                  onTap: () {
                    loginStatus == true?
                    Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (_) => TimerScreen( ),
                      ),
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
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
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
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20, bottom: 10, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: kiconColor,),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Audit(),
                                      ),
                                    );
                                  },
                                  child: Text('Audit'),
                                ),
                              ],
                            ),
                          ),
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
                                  (showProfile == true) ?
                                  Container(
                                    width: columnWidth,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.transparent,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Profile",
                                        style: ktableTitle,
                                        textAlign: TextAlign.center,),
                                    ),
                                  )
                                      : SizedBox(),
                                  Container(
                                    width: columnWidth,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.transparent,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Cleaner\nID",
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
                                        "Cleaner\nName",
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
                                        "Contact",
                                        style: ktableTitle,
                                        textAlign: TextAlign.center,),
                                    ),
                                  ),
                                  (showEmail == true) ?
                                  Container(
                                    width: columnWidth,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.transparent,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Email",
                                        style: ktableTitle,
                                        textAlign: TextAlign.center,),
                                    ),
                                  )
                                      : SizedBox(),
                                  (showstartDate == true) ?
                                  Container(
                                    width: columnWidth,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.transparent,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Start\nDate",
                                        style: ktableTitle,
                                        textAlign: TextAlign.center,),
                                    ),
                                  )
                                      : SizedBox(),
                                  (showendDate == true) ?
                                  Container(
                                    width: columnWidth,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.transparent,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "End\nDate",
                                        style: ktableTitle,
                                        textAlign: TextAlign.center,),
                                    ),
                                  )
                                      : SizedBox(),
                                ],
                              )
                                  : SizedBox(),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: FutureBuilder(
                                future: getCleanersbySiteId(),
                                builder: (context, AsyncSnapshot<List<Users>> snapshot) {
                                  return userList.isNotEmpty ? ListView.builder(
                                      itemCount: userList.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          color: kcardBackgroundColor,
                                          width: screenWidth,
                                          child: ListTile(
                                            title: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                showProfile == true ?
                                                Container(
                                                  width: columnWidth,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.transparent,
                                                  ),
                                                  child: Center(
                                                    child: CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: kiconColor,
                                                      child: (snapshot.data![index].image == "No image") ?
                                                      CircleAvatar(
                                                        radius: 18,
                                                        backgroundColor: Colors.white,
                                                      )
                                                          :CircleAvatar(
                                                          radius: 18,
                                                          backgroundColor: Colors.white,
                                                          backgroundImage: NetworkImage(snapshot.data![index].image.toString(),)
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                    : SizedBox(),
                                                Container(
                                                  width: columnWidth,
                                                  height: 36,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.white,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                        snapshot.data![index].emp_no.toString(),
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
                                                        snapshot.data![index].fname.toString()+" "+snapshot.data![index].lname.toString(),
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
                                                      snapshot.data![index].phone.toString(),
                                                      style: klistTitle,
                                                      textAlign: TextAlign.center,),
                                                  ),
                                                ),
                                                showEmail == true ?
                                                Container(
                                                  width: columnWidth,
                                                  height: 36,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.white,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      snapshot.data![index].email.toString(),
                                                      style: klistTitle,
                                                      textAlign: TextAlign.center,),
                                                  ),
                                                )
                                                    : SizedBox(),
                                                showstartDate == true ?
                                                Container(
                                                  width: columnWidth,
                                                  height: 36,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.white,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      snapshot.data![index].start_date.toString(),
                                                      style: klistTitle,
                                                      textAlign: TextAlign.center,),
                                                  ),
                                                )
                                                    : SizedBox(),
                                                showendDate == true ?
                                                Container(
                                                  width: columnWidth,
                                                  height: 36,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.white,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      snapshot.data![index].end_date.toString(),
                                                      style: klistTitle,
                                                      textAlign: TextAlign.center,),
                                                  ),
                                                )
                                                    : SizedBox(),
                                              ],
                                            ),
                                          ),
                                        );
                                      })
                                      : (isEmptyList==true)?
                                  const Padding(
                                    padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 50.0),
                                    child: Text("No cleaners to preview"),
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
      ),
    );
  }
}

class Users {
  String fname, lname, email, id, start_date, end_date, doc, image, siteid, phone;
  String? allocationId;
  int? emp_no;

  Users(
      {required this.fname,
        required this.lname,
        required this.email,
        required this.id,
        required this.start_date,
        required this.end_date,
        required this.phone,
        required this.doc,
        required this.image,
        required this.siteid,
        this.emp_no,
        this.allocationId
      });
}