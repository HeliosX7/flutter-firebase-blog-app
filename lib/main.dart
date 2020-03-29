import 'package:flutter/material.dart';
import 'auth.dart';
import 'linker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      home: Linker(auth: Auth(),),
    );
  }
}

