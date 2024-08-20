import 'package:flix_id/presentation/misc/constants.dart';
import 'package:flutter/material.dart';

class FlixtextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;

  const FlixtextField(
      {super.key,
      required this.label,
      required this.controller,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: ghostWhite),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: ghostWhite)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade800))),
    );
  }
}
