import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextForm extends StatelessWidget {
  const TextForm({
    super.key,
    required this.controller,
    required this.text,
    required this.textInputType,
    this.validator,
    required this.isEnabled,
    this.maxLength,
    this.maxLine,
  });
  final TextEditingController controller;
  final String text;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final bool isEnabled;
  final int? maxLength;
  final int? maxLine;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(
          horizontal: 20), //text box text and border gap
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 7)
          ]),
      child: TextFormField(
        maxLines: maxLine,
        maxLength: maxLength,
        keyboardType: textInputType,
        enabled: true,
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
            hintText: text,
            border: InputBorder.none,
            hintStyle: GoogleFonts.openSans(
              fontSize: 15,
            )),
      ),
    );
  }
}
