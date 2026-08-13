import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final int? maxLines;
  final String hintText;
  final String labelText;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final bool obsecureText;
  final String? Function(String?)? validator;
  const AppTextFormField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.obsecureText = false,
    this.validator,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
