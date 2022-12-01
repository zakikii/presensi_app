import 'package:flutter/material.dart';
import 'package:presensi_app/screens/home_guru_screen.dart';

class HomeGuruApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Presensi Online',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.white, foregroundColor: Colors.black),
            textTheme: TextTheme(bodyText2: TextStyle(color: Colors.black))),
        home: HomeGuruScreen());
  }
}
