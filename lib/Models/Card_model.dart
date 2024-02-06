import 'package:intl/intl.dart';

class CardModel {
  int patientId;
  String firstName;
  String lastName;
  int age;
  String dob; // Change the type to String for formatted date
  int phoneNo;
  String patientDesc;
  String? pro_pic; // This field may be nullable

  CardModel({
    required this.patientId,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.dob,
    required this.phoneNo,
    required this.patientDesc,
    required this.pro_pic,
  });
}
