import 'package:flutter/material.dart';

extension BuildContextExtention on BuildContext {
  void showSnackbar(String message) =>
      ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
}
