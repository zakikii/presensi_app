import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:presensi_app/constants/color_constant.dart';
import 'package:presensi_app/models/kelas.dart';
import 'package:presensi_app/screens/pdf_view.dart';
import 'package:presensi_app/services/kelas_service.dart';
import 'package:presensi_app/widgets/sncakbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:presensi_app/widgets/constants.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RekapitulasiPresensi extends StatefulWidget {
  @override
  State<RekapitulasiPresensi> createState() => _RekapitulasiPresensiState();
}

class _RekapitulasiPresensiState extends State<RekapitulasiPresensi> {
  int id_kelas = 0;
  String nama_kelas = '';
  String _choosenvalue;
  bool perbulan = false;
  bool persemester = false;
  String bulan;
  String semester;
  static final DateTime now = DateTime.now();
  static final DateFormat year = DateFormat('yyyy');
  static final DateFormat month = DateFormat('M');
  String tahun_sekarang = year.format(now);
  String bulan_sekarang = month.format(now);
  String tahun_ganjil = '';
  String tahun_genap = '';
  String final_ganjil = '';
  String final_genap = '';
  String kategori = '';
  String final_url = '';
  bool _isLoading = true;

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id_kelas = pref.getInt('idKelas');
      nama_kelas = pref.getString('namaKelas');
    });
  }

  getTahunGanjilGenap() {
    if (int.parse(bulan_sekarang) >= 6) {
      setState(() {
        tahun_genap = (int.parse(tahun_sekarang) + 1).toString();
        tahun_ganjil = tahun_sekarang;
      });
    } else {
      tahun_genap = (int.parse(tahun_sekarang) - 1).toString();
      tahun_ganjil = tahun_sekarang.toString();
    }
  }

  // print(formatted);

  cekRekapBulan(BuildContext context, Kelas kelas) async {
    var _kelas = kelasService();
    var cek = await _kelas.cekRekapBulan(kelas);
    var result = jsonDecode(cek.body);
    if (result['result'] == true) {
      const url = "https://presensi-app.zaki-alwan.xyz/download-rekap/bulan";
      final_url = url + '/' + id_kelas.toString() + '/' + bulan;
      if (await canLaunch(final_url)) {
        print(final_url);
        launch("https://docs.google.com/viewer?url=" + final_url);
      }
    } else {
      errorSnackBar(context, result['data']);
    }
  }

  cekRekapSemester(BuildContext context, Kelas kelas) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var _kelas = kelasService();
    var cek = await _kelas.cekRekapSemester(kelas);
    var result = jsonDecode(cek.body);

    if (result['result'] == true) {
      const url = "https://presensi-app.zaki-alwan.xyz/download-rekap/semester";
      final_url = url +
          '/' +
          id_kelas.toString() +
          '/' +
          kategori +
          '/' +
          final_ganjil +
          '/' +
          final_genap;
      // print(final_url);
      if (await canLaunch(final_url)) {
        print(final_url);
        await launch("https://docs.google.com/viewer?url=" + final_url);
        print(final_url);
      }
      // setState(() {
      //   pref.set
      // });
      // Navigator.push(context, MaterialPageRoute(builder: (_) => LihatPDF()));
      // else
      //   // can't launch url, there is some error
      //   throw "Could not launch $url";
      //   setState(() {
      //     pref.setString('url', final_url);
      //   });
      //   print(final_url);
      //   Navigator.push(context, MaterialPageRoute(builder: (_) => LihatPDF()));
      // }
    } else {
      print(final_url);
      errorSnackBar(context, 'data presensi tidak ditemukan');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    getTahunGanjilGenap();
  }

  void pdfView() async {
    try {
      await launchUrlString(final_url);
    } catch (e) {
      errorSnackBar(context, 'sesuatu error');
    }
  }

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: kBlueColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: mainColor,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.blue[900],
          Colors.blue[800],
          Colors.blue[400]
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80),
            Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Rekap Presensi',
                    style: GoogleFonts.inter(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: kWhiteColor),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Rekapitulasi perbulan/persemester",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  // Image.asset('assets/images/student.png')
                ],
              ),
            ),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  )),
              child: Padding(
                  // padding: EdgeInsets.all(5),
                  padding: EdgeInsets.all(20),
                  child: ListView(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 48.0, right: 48.0, bottom: 14.0),
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton<String>(
                          value: _choosenvalue,
                          isExpanded: true,
                          // elevation: 5,
                          style: TextStyle(color: Colors.black),
                          items: <String>['Perbulan', 'Persemester']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: kBlackColor),
                              ),
                            );
                          }).toList(),
                          hint: Text(
                            'Rekapitulasi Presensi',
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: kBlackColor),
                          ),
                          onChanged: (String value) {
                            if (value == 'Perbulan') {
                              perbulan = true;
                              persemester = false;
                            } else if (value == 'Persemester') {
                              persemester = true;
                              perbulan = false;
                            }
                            setState(() {
                              _choosenvalue = value;
                            });
                          },
                        ),
                      ),
                    ),
                    if (perbulan) Bulan(),
                    if (persemester) Semester()
                  ])),
            ))
          ],
        ),
      ),
    );
  }

  Container Bulan() {
    return Container(
        child: Padding(
      padding: EdgeInsets.symmetric(vertical: defaultPadding),
      child: Container(
        child: Column(children: [
          DropdownButton<String>(
            // isExpanded: true,
            value: bulan,
            style: TextStyle(color: Colors.black),
            items: <String>[
              '1',
              '2',
              '3',
              '4',
              '5',
              '6',
              '7',
              '8',
              '9',
              '10',
              '11',
              '12'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: kBlackColor),
                ),
              );
            }).toList(),
            hint: Text(
              'bulan (1-12)',
              style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: kBlackColor),
            ),
            onChanged: (String value) {
              setState(() {
                bulan = value;
              });
            },
          ),
          SizedBox(
            height: 30,
          ),
          ButtonTheme(
            minWidth: 250,
            height: 45.0,
            child: TextButton(
              style: flatButtonStyle,
              onPressed: () async {
                var kelas = Kelas();
                kelas.id = id_kelas;
                kelas.bulan = bulan;
                cekRekapBulan(context, kelas);
              },
              child: Text(
                'download rekap presensi',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ]),
      ),
    ));
  }

  Container Semester() {
    return Container(
        child: Padding(
      padding: EdgeInsets.symmetric(vertical: defaultPadding),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 48.0, right: 48.0, bottom: 14.0),
          child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DropdownButton<String>(
                  // isExpanded: true,
                  value: semester,
                  style: TextStyle(color: Colors.black),
                  items: <String>[
                    'ganjil ' + tahun_ganjil + ' ' + tahun_genap,
                    'genap ' + tahun_ganjil + ' ' + tahun_genap,
                    'ganjil ' +
                        (int.parse(tahun_ganjil) - 1).toString() +
                        ' ' +
                        (int.parse(tahun_genap) - 1).toString(),
                    'genap ' +
                        (int.parse(tahun_ganjil) - 1).toString() +
                        ' ' +
                        (int.parse(tahun_genap) - 1).toString(),
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: kBlackColor),
                      ),
                    );
                  }).toList(),
                  hint: Text(
                    'semester',
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: kBlackColor),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      semester = value;
                    });
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                ButtonTheme(
                  minWidth: 250,
                  height: 45.0,
                  child: TextButton(
                    style: flatButtonStyle,
                    onPressed: () {
                      String data_semester = semester;
                      final pieces = data_semester.split(' ');
                      var kelas = Kelas();
                      kelas.id = id_kelas;
                      kelas.kategori = pieces[0];
                      kelas.tahun_ganjil = pieces[1];
                      kelas.tahun_genap = pieces[2];
                      setState(() {
                        final_ganjil = pieces[1];
                        final_genap = pieces[2];
                        kategori = pieces[0];
                      });
                      cekRekapSemester(context, kelas);
                    },
                    child: Text(
                      'download rekap presensi',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    ));
  }
}
