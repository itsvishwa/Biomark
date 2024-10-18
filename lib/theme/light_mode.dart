import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
      primary: Colors.orange,
      secondary: Colors.grey.shade600,
      background: Colors.grey.shade300,
      inversePrimary: Colors.grey.shade800),
  textTheme: ThemeData.light().textTheme.apply(
        bodyColor: const Color.fromARGB(255, 0, 0, 0),
        displayColor: Colors.black,
      ),
);
