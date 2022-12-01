import 'package:flutter/material.dart';
import 'package:presensi_app/constants/color_constant.dart';
import 'package:presensi_app/screens/data_kelas_screen.dart';

class DataKelasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meditation App',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white, foregroundColor: Colors.black),
          scaffoldBackgroundColor: kBackgroundColor2,
          textTheme:
              const TextTheme(bodyText2: TextStyle(color: Colors.black))),
      home: DataKelasScreen(),
    );
  }
}
