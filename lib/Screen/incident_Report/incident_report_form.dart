// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, deprecated_member_use

import 'package:cleanconnectortab/Dashboard.dart';
import 'package:cleanconnectortab/Screen/incident_Report/incident_report.dart';
import 'package:cleanconnectortab/constants/style.dart';
import 'package:cleanconnectortab/login.dart';
import 'package:cleanconnectortab/widget/check_box.dart';
import 'package:cleanconnectortab/widget/text_form.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../constants/const_api.dart';

class IncidentReportForm extends StatefulWidget {
  IncidentReportForm({super.key});

  @override
  State<IncidentReportForm> createState() => _IncidentReportFormState();
  final TextEditingController selectPersonEffect = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController position = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController contactN = TextEditingController();
  final TextEditingController incidentDate = TextEditingController();
  final TextEditingController reportedDate = TextEditingController();
  final TextEditingController timeReported = TextEditingController();
  final TextEditingController contactNu = TextEditingController();
  final TextEditingController incidentType = TextEditingController();
  final TextEditingController describe = TextEditingController();
  final TextEditingController witnessName = TextEditingController();
  final TextEditingController contactNum = TextEditingController();
  final TextEditingController anyoneInj = TextEditingController();
  final TextEditingController hospital = TextEditingController();
  final TextEditingController family = TextEditingController();
}



class _IncidentReportFormState extends State<IncidentReportForm> {
   bool isLoading = false;
  Future getProfile() async {
    print("Data loading....2");
    setState(() {
      isLoading = true;
    });
    print(loginSiteData['accessToken']);
    // print("${loginUserProfile['id']}");
    // String id = loginUserData['id'];
    // print(loginUserData['id']);
    try {
      print("+++++++++++>" + loginSiteData['id']);
      // ${loginUserData['id']}
      final response = await Dio().get(
          '${BASE_API2}site/get-sites/${loginSiteData['id']}',
          options: Options(headers: {
            "Authorization": "Bearer " + loginSiteData['accessToken']
          }));
      print(response.statusCode);
      print(response.data['status']);
      if (response.statusCode == 200 && response.data['status'] == true) {
        print(response.data['sites']);
        print("Result");
        print(response.data['sites'][0]['site_name']);
        setState(() {
          loginUserProfile['id'] = response.data['sites'][0]['site_id'] ?? " ";
          loginUserProfile['name'] =
              response.data['sites'][0]['site_address'] ?? " ";
          loginUserProfile['phone'] =
              response.data['sites'][0]['mobile'] ?? " ";
          loginUserProfile['email'] =
              response.data['sites'][0]['site_email'] ?? " ";
          // loginUserProfile['image'] = response.data['result'][0]['image'] ?? " ";
          loginUserProfile['site_name'] =
              response.data['sites'][0]['site_name'] ?? " ";
          loginUserProfile['rate'] =
              response.data['sites'][0]['rate'].toString() ?? " ";
        });
        print(loginUserProfile['name']);
        print(loginUserProfile['id']);
        print(loginUserProfile['rate']);
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }
  //   @override
  // void initState() {
  //   loginStatus = false;
  //   isLoading = true;
  //   loading();
  //   super.initState();
  //   print("???????????????????");
  // }

  loading() async {
    await getProfile();
    setState(() {
      isLoading = false;
    });
  }
  ////API Call
  void callapi() async {
    print("********callAPI working");
    try {
      var dio = Dio();

      var requestData = {
        "person_affected": selectPersonEffect,
        "f_name": widget.firstName,
        "sur_name": widget.lastName,
        "position": widget.position,
        "site_address": widget.address,
        "telephone": widget.contactN,
        "date_of_incident": DateFormat('yyyy-MM-dd').format(_dateTimeIncident),
        "date_reported": DateFormat('yyyy-MM-dd').format(_incidentReportDate),
        "time_reported": DateFormat('HH:mm').format(_incidentReportTime),
        "incident_reporter_tele": widget.contactNu,
        "type_of_incident": selectTypeOfIncident,
        "description": widget.describe,
        "witness": widget.witnessName,
        "witness_tele": widget.contactNum,
        "is_anyone_injury": widget.anyoneInj,
        "is_taken_hospital": widget.hospital,
        "is_family_notified": widget.family,
        "nature_of_injury": selectedNatureOfInjury,
        "body_location": selectedBodyLocation,
        "mechanism": selectedMechanismOfInjury,
        "agency_of_injury": selectedAgencyOfInjury,
        "dob": DateFormat('yyyy-MM-dd').format(_dateTimeDob),
        "site": '',
      };

      var response = await dio.post("${BASE_API2}incident/add-incident",
          data: requestData);

      print(response.statusCode);
      print(response.data.toString());
    } catch (e) {
      if (e is DioError &&
          e.response != null &&
          e.response!.statusCode == 400) {
        print('Bad request. Check your request parameters.');
        print('Error response: ${e.response!.data}');
      } else {
        print('Error fetching data: $e');
      }
    }
  }

  ///RadioListTile Select Value for the Person Effected
  String selectPersonEffect = '';

  ///RadioListTile Select Value for the Incident Type
  String selectTypeOfIncident = '';

  //// Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ///// Date of birth date picker values
  DateTime _dateTimeDob = DateTime.now();
  String? selectedDob;

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    ).then((value) {
      setState(() {
        _dateTimeDob = value!;
      });
    });
  }

  ///// Incident of birth date picker values
  DateTime _dateTimeIncident = DateTime.now();
  String? selectedIncident;

  void _showDatePickerIncident() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2050),
    ).then((value) {
      setState(() {
        _dateTimeIncident = value!;
      });
    });
  }

  ///// Incident of birth date picker values
  DateTime _incidentReportDate = DateTime.now();
  String? selectedIncidentReport;

  void _showDatePickerIncidentReport() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2050),
    ).then((value) {
      setState(() {
        _incidentReportDate = value!;
      });
    });
  }

////Get all sites
  var jsonList;
  List<String> siteList = [];

  @override
  void initState() {
    super.initState();
    loginStatus = false;
    isLoading = true;
    loading();
    super.initState();
    print("???????????????????");
    getData();
  }

  void getData() async {
    try {
      var dio = Dio();
      var authToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImRlMDY2ODY2LTdmMGQtMTFlZS04MWM4LTBhNjE2NDI2YTJiNyIsImVtYWlsIjoidGVzdGVtYWlsQGdtYWlsLmNvbSIsInJvbGUiOiJzdXBlciBhZG1pbiIsImlhdCI6MTcwMTk2NTg0NywiZXhwIjoxNzA0NTU3ODQ3fQ.wItuUUJZYb5bdMsmfRqIdEORVM3e9VWJpQNWSnUIEKk'; // Replace with your actual token
      dio.options.headers['Authorization'] = 'Bearer $authToken';

      var response = await dio.get('${BASE_API2}site/getall-sites');

      if (response.statusCode == 200) {
        List<dynamic> siteData = response.data["sites"];
        setState(() {
          jsonList = siteData.cast<Map<String, dynamic>>();
        });
        print('Site List: $jsonList');
      } else {
        print('Failed to fetch site list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  ////Incident report date and time picker
  DateTime _incidentReportTime = DateTime.now();

  //// Checkbox
  //// Data Table
  List<String> selectedNatureOfInjury = [];
  List<String> selectedBodyLocation = [];
  List<String> selectedMechanismOfInjury = [];
  List<String> selectedAgencyOfInjury = [];
  void _onCheckboxSelected(String title, bool value) {
    setState(() {
      if (value) {
        if (title.contains('Nature of Injury')) {
          selectedNatureOfInjury.add(title);
        } else if (title.contains('Body Location')) {
          selectedBodyLocation.add(title);
        } else if (title.contains('Mechanism of Injury')) {
          selectedMechanismOfInjury.add(title);
        } else if (title.contains('Agency of Injury')) {
          selectedAgencyOfInjury.add(title);
        }
      } else {
        if (title.contains('Nature of Injury')) {
          selectedNatureOfInjury.remove(title);
        } else if (title.contains('Body Location')) {
          selectedBodyLocation.remove(title);
        } else if (title.contains('Mechanism of Injury')) {
          selectedMechanismOfInjury.remove(title);
        } else if (title.contains('Agency of Injury')) {
          selectedAgencyOfInjury.remove(title);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // getData();
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IncidentReport(),
                    ));
              },
              child: const CircleAvatar(
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
          title: const Text(
            "INCIDENT REPORT FORM",
            style: kTitle,
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              key: _formKey,
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Persons Involved",
                        style: GoogleFonts.openSans(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RadioListTile(
                              title: const Text('Employee'),
                              value: 'Employee',
                              groupValue: selectPersonEffect,
                              onChanged: (String? value) {
                                setState(() {
                                  selectPersonEffect = value!;
                                  print('Selected Value: $selectPersonEffect');
                                });
                              }),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: RadioListTile(
                              title: const Text('Temporary/Casual'),
                              value: 'Temporary/Casual',
                              groupValue: selectPersonEffect,
                              onChanged: (String? value) {
                                setState(() {
                                  selectPersonEffect = value!;
                                  print('Selected Value: $selectPersonEffect');
                                });
                              }),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: RadioListTile(
                              title: const Text('Contractor'),
                              value: 'Contractor',
                              groupValue: selectPersonEffect,
                              onChanged: (String? value) {
                                setState(() {
                                  selectPersonEffect = value!;
                                  print('Selected Value: $selectPersonEffect');
                                });
                              }),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: RadioListTile(
                              title: const Text('Other'),
                              value: 'Other',
                              groupValue: selectPersonEffect,
                              onChanged: (String? value) {
                                setState(() {
                                  selectPersonEffect = value!;
                                  print('Selected Value: $selectPersonEffect');
                                });
                              }),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextForm(
                      controller: widget.firstName,
                      text: 'First Name',
                      textInputType: TextInputType.name,
                      isEnabled: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the First Name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextForm(
                      controller: widget.lastName,
                      text: 'Last Name',
                      textInputType: TextInputType.name,
                      isEnabled: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the Last Name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextForm(
                      controller: widget.position,
                      text: 'Position',
                      textInputType: TextInputType.name,
                      isEnabled: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the Position';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 7)
                          ]),
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 15),
                            child: Text(
                              DateFormat('dd/MM/yyyy').format(_dateTimeDob),
                              style: GoogleFonts.openSans(
                                  fontSize: 15,
                                  color: Theme.of(context).hintColor),
                            ),
                          ),
                          const SizedBox(
                            width: 150,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: MaterialButton(
                              onPressed: _showDatePicker,
                              child: Text(
                                'Select Date of Birth',
                                style: GoogleFonts.openSans(
                                    fontSize: 15,
                                    color: Theme.of(context).hintColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 7)
                          ]),
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: jsonList == null
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                itemCount: jsonList!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return DropdownMenuItem(
                                    // value: jsonList![index]['site_id'],
                                    child: Text(
                                      '${loginUserProfile['site_name']}',
                                      style: GoogleFonts.openSans(fontSize: 15),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 7)
                          ]),
                      height: 50,
                      child: IntlPhoneField(
                        decoration: const InputDecoration(
                          hintText: 'Phone Number',
                          border: InputBorder.none,
                        ),
                        initialCountryCode: 'AU',
                        controller: widget.contactN,
                        onChanged: (phone) {},
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Incident Details",
                        style: GoogleFonts.openSans(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 7)
                          ]),
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 15),
                            child: Text(
                              DateFormat('dd/MM/yyyy')
                                  .format(_dateTimeIncident),
                              style: GoogleFonts.openSans(
                                  fontSize: 15,
                                  color: Theme.of(context).hintColor),
                            ),
                          ),
                          const SizedBox(
                            width: 150,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: MaterialButton(
                              onPressed: _showDatePickerIncident,
                              child: Text(
                                'Select Date of Incident',
                                style: GoogleFonts.openSans(
                                    fontSize: 15,
                                    color: Theme.of(context).hintColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(6),
                    //       boxShadow: [
                    //         BoxShadow(
                    //             color: Colors.black.withOpacity(0.1),
                    //             blurRadius: 7)
                    //       ]),
                    //   height: 50,
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(left: 20.0),
                    //     child: Row(
                    //       children: [
                    //         Text(
                    //           DateFormat('dd/MM/yyyy')
                    //               .format(_incidentReportDate),
                    //           style: GoogleFonts.openSans(fontSize: 15),
                    //         ),
                    //         const SizedBox(
                    //           width: 180,
                    //         ),
                    //         Text(
                    //           'Report Date',
                    //           style: GoogleFonts.openSans(fontSize: 15),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 7)
                          ]),
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 15),
                            child: Text(
                              DateFormat('dd/MM/yyyy')
                                  .format(_incidentReportDate),
                              style: GoogleFonts.openSans(
                                  fontSize: 15,
                                  color: Theme.of(context).hintColor),
                            ),
                          ),
                          const SizedBox(
                            width: 150,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: MaterialButton(
                              onPressed: _showDatePickerIncidentReport,
                              child: Text(
                                'Report Date',
                                style: GoogleFonts.openSans(
                                    fontSize: 15,
                                    color: Theme.of(context).hintColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 7)
                          ]),
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Row(
                          children: [
                            Text(
                              DateFormat('HH:mm').format(_incidentReportTime),
                              style: GoogleFonts.openSans(fontSize: 15),
                            ),
                            const SizedBox(
                              width: 220,
                            ),
                            Text(
                              'Report Time',
                              style: GoogleFonts.openSans(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 7)
                          ]),
                      height: 50,
                      child: IntlPhoneField(
                        decoration: const InputDecoration(
                          hintText: 'Phone Number',
                          border: InputBorder.none,
                        ),
                        initialCountryCode: 'AU',
                        controller: widget.contactNu,
                        onChanged: (phone) {},
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Type Of Incident",
                        style: GoogleFonts.openSans(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RadioListTile(
                              title: const Text('Notifiable'),
                              value: 'Notifiable',
                              groupValue: selectTypeOfIncident,
                              onChanged: (String? value) {
                                setState(() {
                                  selectTypeOfIncident = value!;
                                  print(
                                      'Selected Value: $selectTypeOfIncident');
                                });
                              }),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: RadioListTile(
                              title: const Text('Significant'),
                              value: 'Significant',
                              groupValue: selectTypeOfIncident,
                              onChanged: (String? value) {
                                setState(() {
                                  selectTypeOfIncident = value!;
                                  print(
                                      'Selected Value: $selectTypeOfIncident');
                                });
                              }),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: RadioListTile(
                              title: const Text('Minor'),
                              value: 'Contractor',
                              groupValue: selectTypeOfIncident,
                              onChanged: (String? value) {
                                setState(() {
                                  selectTypeOfIncident = value!;
                                  print(
                                      'Selected Value: $selectTypeOfIncident');
                                });
                              }),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: RadioListTile(
                              title: const Text('Medical Treatment'),
                              value: 'Medical Treatment',
                              groupValue: selectTypeOfIncident,
                              onChanged: (String? value) {
                                setState(() {
                                  selectTypeOfIncident = value!;
                                  print(
                                      'Selected Value: $selectTypeOfIncident');
                                });
                              }),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: RadioListTile(
                              title: const Text('First Aid'),
                              value: 'First Aid',
                              groupValue: selectTypeOfIncident,
                              onChanged: (String? value) {
                                setState(() {
                                  selectTypeOfIncident = value!;
                                  print(
                                      'Selected Value: $selectTypeOfIncident');
                                });
                              }),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: RadioListTile(
                              title: const Text('Near Miss'),
                              value: 'Near Miss',
                              groupValue: selectTypeOfIncident,
                              onChanged: (String? value) {
                                setState(() {
                                  selectTypeOfIncident = value!;
                                  print(
                                      'Selected Value: $selectTypeOfIncident');
                                });
                              }),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextForm(
                      controller: widget.describe,
                      text: 'Describe Incident',
                      textInputType: TextInputType.text,
                      isEnabled: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Describe the Incident';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextForm(
                      controller: widget.witnessName,
                      text: 'Name of Witness',
                      textInputType: TextInputType.text,
                      isEnabled: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the Witness Name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 7)
                          ]),
                      height: 50,
                      child: IntlPhoneField(
                        decoration: const InputDecoration(
                          hintText: 'Phone Number',
                          border: InputBorder.none,
                        ),
                        initialCountryCode: 'AU',
                        controller: widget.contactNum,
                        onChanged: (phone) {},
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Injury Details",
                        style: GoogleFonts.openSans(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextForm(
                      controller: widget.anyoneInj,
                      text: 'Was anyone injured?',
                      textInputType: TextInputType.text,
                      isEnabled: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the details.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextForm(
                      controller: widget.hospital,
                      text: 'Injured taken to Hospital?',
                      textInputType: TextInputType.text,
                      isEnabled: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the details.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextForm(
                      controller: widget.family,
                      text: 'Has family been notified?',
                      textInputType: TextInputType.text,
                      isEnabled: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the details.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Injury Specifications",
                        style: GoogleFonts.openSans(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DataTable(
                          columnSpacing: 20,
                          dataRowHeight: 60,
                          columns: <DataColumn>[
                            DataColumn(
                                label: SizedBox(
                                    width: 150,
                                    child: Text(
                                      'Nature of Injury',
                                      style: GoogleFonts.openSans(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ))),
                            DataColumn(
                                label: SizedBox(
                                    width: 150,
                                    child: Text('Body Location',
                                        style: GoogleFonts.openSans(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)))),
                            DataColumn(
                                label: SizedBox(
                                    width: 150,
                                    child: Text('Mechanism of Injury',
                                        style: GoogleFonts.openSans(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)))),
                            DataColumn(
                                label: SizedBox(
                                    width: 150,
                                    child: Text('Agency of Injury',
                                        style: GoogleFonts.openSans(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)))),
                          ],
                          rows: <DataRow>[
                            DataRow(
                              cells: [
                                DataCell(CheckBoxForm(
                                  title: 'Fracture/Dislocation',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Eye',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Fall from Height',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Machinery Fixed plant',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(CheckBoxForm(
                                  title: 'Dislocation',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Ear',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Slip/trip/fall',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Mobile Plant',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(CheckBoxForm(
                                  title: 'Sprain/Strain',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Face',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title:
                                      'Physical strike against or by moving object',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Road Transport',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(CheckBoxForm(
                                  title: 'Internal injury',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Head',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Exposure to Noise',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Other Transport',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(CheckBoxForm(
                                  title: 'Amputation',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Neck',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Repetitive Movement',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Powered Equip/Tools',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(CheckBoxForm(
                                  title: 'Laceration / Open Wound',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Lower back',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Use of equipment ',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Non Power Hand Tools',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(CheckBoxForm(
                                  title: 'Contusion/bruising',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Trunk',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Manual task/s',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Non Powered Equip',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(CheckBoxForm(
                                  title: 'Burns',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Shoulders/Arms',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Exposure to Electricity',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Chemicals',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(CheckBoxForm(
                                  title: 'Foreign Body',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Hands/Fingers',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Exposure to Heat/Cold',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Other Material/Substance',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(CheckBoxForm(
                                  title:
                                      'Absorption via inhalation or   digestion',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Hips/Legs',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title:
                                      'Exposure to Hazardous chemicals or Substances',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Outdoor Environment',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(CheckBoxForm(
                                  title: 'Psychological ',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Feet/Toes',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Aggression in workplace',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Indoor Environment',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(CheckBoxForm(
                                  title: 'Multiple Injuries',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Respiratory system',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Ergonomics / workplace design',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Underground Environment',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(CheckBoxForm(
                                  title: 'Other',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Psychological ',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Others',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                                DataCell(CheckBoxForm(
                                  title: 'Others',
                                  onCheckboxSelected: _onCheckboxSelected,
                                )),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Container(
                          height: 50,
                          width: 300,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  callapi();
                                  print("Successfull");
                                } else {
                                  print('Unsuccessfull');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: const Color(0xFF3489CF),
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: Text(
                                'Submit Form',
                                style: GoogleFonts.openSans(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
