import 'package:flutter/material.dart';

class MaquinasScreen extends StatelessWidget {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
        useMaterial3: true,
        brightness: isDark ? Brightness.dark : Brightness.light);

    return Padding(
       padding: EdgeInsets.all(5),
    );
  }
}
