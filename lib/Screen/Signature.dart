import 'dart:io';
import 'dart:typed_data';
import 'package:cleanconnectortab/CleanerLogin.dart';
import 'package:cleanconnectortab/Timer.dart';
import 'package:cleanconnectortab/constants/style.dart';
import 'package:cleanconnectortab/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import '../constants/const_api.dart';
import 'SiteManual.dart';
import 'SiteManual_Admin.dart';
import 'ToolBoxTalk.dart';
import 'package:dio/dio.dart' as dioo;
import 'ToolBoxTalk_cleaner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

File? selectedFile;

class SignaturePad extends StatefulWidget {
  final SignatureController controller;
  final String fromWhere;
  String? manualId;
  String? document;

  SignaturePad({required this.controller, required this.fromWhere,required this.manualId, required this.document});

  @override
  _SignaturePadState createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  
  bool isControllerEmpty = true;
  File? abc;
  late File? _signatureImage;
  bool isLoading = false;
  
  // String extractPdfNameFromUrl(String url) {
  // // Split the URL using '%2F' (URL-encoded '/') to get the file path
  //   List<String> urlParts = url.split('%2F');

  //   // The last part of the URL should contain the file name
  //   String lastPart = urlParts.last;

  //   // Decode the URL-encoded string to get the actual file name
  //   String decodedFileName = Uri.decodeComponent(lastPart);
  //   print("docname $decodedFileName");
  //   // String pdfName = decodedFileName.replaceAll(RegExp(r'\..*'), '');
  //   // Extract the part before the timestamp and file extension
  // String pdfName = decodedFileName.split(RegExp(r'\s+\S*\?'))[0];

  // // Remove everything after the ".pdf" part
  // pdfName = pdfName.split('.pdf')[0] + '.pdf';
  //   print("docname $pdfName");

  //   return pdfName;
  // }

  Future signDocToolBox() async {
    print("SignDoc ${widget.manualId}");
    
    String imageName = _signatureImage!.path.split('/').last;

    print("SignDoc $imageName");
    print("SignDoc document ${widget.document}");

    String? docPath = widget.document;
    String? pdfPath;
    String? pdfName;

    final response = await http.get(Uri.parse(docPath!));
    // pdfName = extractPdfNameFromUrl(docPath);
    print("File Upload File name *** $pdfName");

    // print("ImageFile ${}");

    // if (response.statusCode == 200) {
      
    //   final Uint8List bytes = response.bodyBytes;
    //   final tempDir = await getTemporaryDirectory();
    //   final file = File('${tempDir.path}/document.pdf');
    //   print("File Upload File path *** ${file.path}");
    //   pdfPath = file.path;
      
    // } else {
    //   throw Exception('Failed to load image');
    // }

    
    dioo.FormData data = dioo.FormData.fromMap({
      'user_id': loginCleanerData['id'],
      // 'user_id':'fe631626-b254-48c4-b7d6-182db9f3a27e',
      'site_id': loginSiteData['id'],
      'document_id': widget.manualId,
      'signature': await dioo.MultipartFile.fromFile(_signatureImage!.path, filename: imageName, contentType: MediaType.parse('image/png')),
      // 'doc': await dioo.MultipartFile.fromFile(pdfPath!, filename: pdfName, contentType: MediaType.parse('application/pdf')),
    });
    
    try {
      print("xxxx");
      var response = await Dio().post('${BASE_API2}toolbox-talk/add-cleaner-toolbox-talk',
          data: data,
          options: Options(headers: {
            "Authorization": "Bearer " + loginSiteData['accessToken']
          }));
      
      print("SignDoc !!!!!!!!!!$response");
      print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;                        
        });
        print('SignDoc User ID *************');
        showSuccessDialog();
      } else {
        setState(() {
          isLoading = false;                        
        });
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Something went wrong. Please try again'),
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
      } 
    } on DioException catch (e) {
      var code = e.response?.statusCode;
      
      if (code == 400) {
        setState(() {
          isLoading = false;                        
        });
        Navigator.of(context).pop();
        print("Bad Error");
        print(e.response?.data);
        
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Something went wrong. Please try again'),
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

      } if (code == 409){
          setState(() {
          isLoading = false;                        
        });
        Navigator.of(context).pop();
        print("Bad Error");
        print(e.response?.data['message']);
        
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('cleaner has alredy read and acknowledged the document in this site'),
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

      }
      else {
        
        setState(() {
          isLoading = false;                        
        });
        Navigator.of(context).pop();
        print("Bad Error");
        print(e.response?.data);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Something went wrong. Please try again'),
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

      }

      print(e.toString());
      print(e);
    }
  }

  Future signDocSiteManual() async {
    print("SignDoc Site Manual ${widget.manualId}");

    String imageName = _signatureImage!.path.split('/').last;
    print("SignDoc $imageName");

    dioo.FormData data = dioo.FormData.fromMap({
      'user': loginCleanerData['id'],
      // 'user':'fe631626-b254-48c4-b7d6-182db9f3a27e',
      'manual_id': widget.manualId,
      'image': await dioo.MultipartFile.fromFile(_signatureImage!.path, filename: imageName, contentType: MediaType.parse('image/png')),
    });
    try {
      print("xxxx");
      var response = await Dio().post('${BASE_API2}user/site-manual-refer',
          data: data);
      print("SignDoc !!!!!!!!!!$response");
      print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;                        
        });
        print('SignDoc User ID *************');
        showSuccessDialog();
      } else {
        
        setState(() {
          isLoading = false;                        
        });
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Something went wrong. Please try again'),
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
      } 
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        
        setState(() {
          isLoading = false;                        
        });
        Navigator.of(context).pop();
        print("Bad Error");
        print(e.response?.data);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Something went wrong. Please try again'),
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

      }
      if (e.response?.statusCode == 409){
          setState(() {
          isLoading = false;                        
        });
        Navigator.of(context).pop();
        print("Bad Error");
        print(e.response?.data['message']);
        
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('cleaner has alredy read and acknowledged the document in this site'),
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

      }
      else {
        
        setState(() {
          isLoading = false;                        
        });
        Navigator.of(context).pop();
        print("Bad Error");
        print(e.response?.data);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Something went wrong. Please try again'),
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

      }
      print(e.toString());
      print(e);
    }
  }

  // Future signDoc() async {
  //   dioo.FormData data = dioo.FormData.fromMap({
  //     'user': "fe631626-b254-48c4-b7d6-182db9f3a27e",
  //     'manual_id': "28e7cf7e-8e8e-11ee-a235-0a616426a2b7",
  //     'image': abc
  //   });
  //   try {
  //     print("xxxx");
  //     var response = await Dio().post('http://ec2-3-144-155-224.us-east-2.compute.amazonaws.com:8000/user/site-manual-refer',
  //         data: dioo.FormData.fromMap({
  //           'user': "fe631626-b254-48c4-b7d6-182db9f3a27e",
  //           'manual_id': "28e7cf7e-8e8e-11ee-a235-0a616426a2b7",
  //           'image': abc
  //         }));
  //     print("!!!!!!!!!!$response");
  //     print(response.statusCode);
  //     if (response.statusCode == 200) {
  //       print('User ID *************');
  //       setState(() {
  //         //isLoading = false;
  //       });
  //       showSuccessDialog();
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: const Text('Something went wrong. Please try again'),
  //           backgroundColor: Colors.black,
  //           behavior: SnackBarBehavior.floating,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(15),
  //           ),
  //           margin: EdgeInsets.only(
  //               bottom: MediaQuery.of(context).size.height - 100,
  //               right: 5,
  //               left: 5),
  //         ));
  //       } } on DioException catch (e) {
  //     if (e.response?.statusCode == 400) {
  //       print("Bad Error");
  //       print(e.response?.data);
  //       if (e.response?.data["message"] == "Cleaner Password is incorrect") {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text("Invalid Password."),
  //           ),
  //         );
  //       }
  //       if (e.response?.data["message"] == "User email not exist") {
  //       } else if (e.response?.data["message"] ==
  //           "No any registered user for this email") {}
  //     }
  //     print(e.toString());
  //     print(e);
  //   }
  // }

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Signature saved successfully!"),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kiconColor,
              ),
              onPressed: () {
                print("0");
                Navigator.of(context).pop();
                print("1");
                Navigator.of(context).pop();
                print("2");
                widget.fromWhere == "Site Manual"
                    ? Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SiteManual()))
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ToolBoxtTalk())); // Close th
                print("3"); // e dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      print("signdocument ${widget.document}");
      setState(() {
        isControllerEmpty = widget.controller.isEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(0),
      title: Container(
          height: 50,
          color: kiconColor,
          child: Center(
              child: Text(
            'Digital Signature',
            style: TextStyle(
              color: Colors.white,
            ),
          ))),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.65,
        width: MediaQuery.of(context).size.height *
            0.6, // Adjust the height as needed
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Signature(
                controller: widget.controller,
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.height * 0.6,
                backgroundColor: Colors.white,
              ),
            ),
            Divider(
              color: kcardBackgroundColor,
              thickness: 3,
            ),
            SizedBox(height: 10),
            Expanded(
              child: Center(
                child: isLoading
                  ? Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: SpinKitDualRing(
                        color: kiconColor,
                        size: 30,
                      ),
                    )
                  : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kiconColor,
                  ),
                  onPressed:  isControllerEmpty
                    ? null // Disable the button if the controller is empty
                    :  () async {

                      setState(() {
                        isLoading = true;                        
                      });

                      // 1. Get the signature as an image byte array
                      // final signatureBytes = widget.controller.toPngBytes();
                      final Uint8List? signatureBytes = await widget.controller.toPngBytes();

                      // 2. Convert the byte array to a File

                      if (signatureBytes != null) {
                        // Get the temporary directory
                        final tempDir = await getTemporaryDirectory();

                        // Generate a unique filename, for example using current timestamp
                        String fileName = 'signature_${loginCleanerData['id']}.jpg';

                        // Create a File object with the desired path
                        final file = File('${tempDir.path}/$fileName');

                        // Write the bytes to the file
                        await file.writeAsBytes(signatureBytes);

                        // Print the file path
                        print("ImageFile: '${file.path}'");
                        setState(() {
                        _signatureImage = file;
                        // final signatureBytes = widget.controller.toPngBytes();
                      });
                      } else {
                        // Handle the case where signatureBytes is null
                        print("Error: Signature bytes are null");
                      }
                      (widget.fromWhere == 'Tool Box') ? signDocToolBox() : signDocSiteManual();
                    
                      
                    },
                  child: Text('Save Signature'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
