import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi_app/constants/color_constant.dart';
import 'package:presensi_app/models/daftar_siswa.dart';
import 'package:presensi_app/models/kick_siswa.dart';
import 'package:presensi_app/services/kelas_service.dart';
import 'package:presensi_app/widgets/sncakbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DaftarSiswaKelasScreen extends StatefulWidget {
  final List<daftar_siswa> siswa;
  DaftarSiswaKelasScreen(this.siswa);

  @override
  State<DaftarSiswaKelasScreen> createState() => _DaftarSiswaKelasScreenState();
}

class _DaftarSiswaKelasScreenState extends State<DaftarSiswaKelasScreen> {
  String kelas = '';
  final controller = TextEditingController();
  List<daftar_siswa> _siswa = List<daftar_siswa>();

  @override
  void initState() {
    super.initState();
    _siswa.addAll(widget.siswa);
    getNamaKelas();
  }

  getNamaKelas() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      kelas = pref.getString('namaKelas');
    });
  }

  void cariSiswa(String cari) {
    final hasil = widget.siswa.where((siswa) {
      final nama_siswa = siswa.name;
      final input = cari.toLowerCase();

      return nama_siswa.contains(input);
    }).toList();

    setState(() => _siswa = hasil);
  }

  kickSiswa(BuildContext context, kick_siswa kick) async {
    kelasService _kelasService = kelasService();
    var kick_siswa = await _kelasService.kickSiswa(kick);
    var result = json.decode(kick_siswa.body);
    if (result['result'] == true) {
      successSnackBar(context, 'siswa berhasil dikeluarkan');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: mainColor,
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: [],
        // foregroundColor: Colors.black,
        textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.black)),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios, color: Colors.white),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
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
          children: [
            SizedBox(height: 80),
            Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Daftar Siswa',
                    style: GoogleFonts.inter(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: kWhiteColor),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'kelas,' + kelas,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(29.5),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        icon: SvgPicture.asset("assets/icons/search.svg"),
                        border: InputBorder.none,
                      ),
                      onChanged: cariSiswa,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  )),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: ListView.builder(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    shrinkWrap: true,
                    itemCount: _siswa.length,
                    itemBuilder: (context, index) {
                      final siswa = _siswa[index];
                      return Container(
                        height: 76,
                        margin: EdgeInsets.only(bottom: 13),
                        padding: EdgeInsets.only(
                            left: 24, top: 12, bottom: 12, right: 22),
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: kTenBlackColor,
                              blurRadius: 10,
                              spreadRadius: 5,
                              offset: Offset(8.0, 8.0),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 13,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                        siswa.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        style: GoogleFonts.inter(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: kBlackColor),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                TextButton(
                                    child: Text(
                                      'keluarkan',
                                      style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.redAccent[100]),
                                    ),
                                    onPressed: () {
                                      Widget cancelButton = TextButton(
                                        child: Text("tidak jadi"),
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                      );
                                      Widget continueButton = TextButton(
                                        child: Text("keluarkan"),
                                        onPressed: () {
                                          var kick = kick_siswa();
                                          kick.id_siswa = siswa.id;
                                          kickSiswa(context, kick);
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                      );
                                      AlertDialog alert = AlertDialog(
                                        title: Text("Keluarkan Siswa"),
                                        content: Text(
                                            "Dengan mengeluarkan siswa berarti siswa tidak dapat mengisi presensi lagi, apakah kamu yakin ingin menutup kelas ?"),
                                        actions: [
                                          cancelButton,
                                          continueButton,
                                        ],
                                      );
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alert;
                                        },
                                      );
                                    }),
                              ],
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ))
          ],
        ),
      ),
      // body: Stack(children: <Widget>[
      //   Container(
      //     height: size.height * .35,
      //     decoration: BoxDecoration(
      //         gradient: LinearGradient(
      //           colors: [
      //             backgroundColor1,
      //             backgroundColor2,
      //           ],
      //         ),
      //         borderRadius: BorderRadius.only(
      //           bottomLeft: Radius.circular(40),
      //           bottomRight: Radius.circular(40),
      //         )),
      //   ),
      //   SafeArea(
      //     child: Container(
      //       margin: EdgeInsets.only(top: 8),
      //       child: ListView(
      //         physics: ClampingScrollPhysics(),
      //         children: <Widget>[
      //           Padding(
      //             padding:
      //                 EdgeInsets.only(left: 16, bottom: 13, top: 29, right: 10),
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: <Widget>[
      //                 Text(
      //                   'Daftar Siswa Kelas',
      //                   style: GoogleFonts.inter(
      //                       fontSize: 30,
      //                       fontWeight: FontWeight.w700,
      //                       color: kWhiteColor),
      //                 ),
      //                 // Text(
      //                 //   'Kelas : ' + kelas,
      //                 //   style: GoogleFonts.inter(
      //                 //       fontSize: 18,
      //                 //       fontWeight: FontWeight.w700,
      //                 //       color: kWhiteColor),
      //                 // ),
      //                 Container(
      //                   margin: EdgeInsets.symmetric(vertical: 30),
      //                   padding:
      //                       EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      //                   decoration: BoxDecoration(
      //                     color: Colors.white,
      //                     borderRadius: BorderRadius.circular(29.5),
      //                   ),
      //                   child: TextField(
      //                     decoration: InputDecoration(
      //                       hintText: "Search",
      //                       icon: SvgPicture.asset("assets/icons/search.svg"),
      //                       border: InputBorder.none,
      //                     ),
      //                     onChanged: cariSiswa,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //           ListView.builder(
      //             padding: EdgeInsets.only(left: 16, right: 16),
      //             shrinkWrap: true,
      //             itemCount: _siswa.length,
      //             itemBuilder: (context, index) {
      //               final siswa = _siswa[index];
      //               return Container(
      //                 height: 76,
      //                 margin: EdgeInsets.only(bottom: 13),
      //                 padding: EdgeInsets.only(
      //                     left: 24, top: 12, bottom: 12, right: 22),
      //                 decoration: BoxDecoration(
      //                   color: kWhiteColor,
      //                   borderRadius: BorderRadius.circular(15),
      //                   boxShadow: [
      //                     BoxShadow(
      //                       color: kTenBlackColor,
      //                       blurRadius: 10,
      //                       spreadRadius: 5,
      //                       offset: Offset(8.0, 8.0),
      //                     )
      //                   ],
      //                 ),
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: <Widget>[
      //                     Row(
      //                       children: <Widget>[
      //                         SizedBox(
      //                           width: 13,
      //                         ),
      //                         Column(
      //                           crossAxisAlignment: CrossAxisAlignment.start,
      //                           mainAxisAlignment: MainAxisAlignment.center,
      //                           children: <Widget>[
      //                             SizedBox(
      //                               width: 150,
      //                               child: Text(
      //                                 siswa.name,
      //                                 maxLines: 1,
      //                                 overflow: TextOverflow.fade,
      //                                 softWrap: false,
      //                                 style: GoogleFonts.inter(
      //                                     fontSize: 18,
      //                                     fontWeight: FontWeight.w700,
      //                                     color: kBlackColor),
      //                               ),
      //                             ),
      //                           ],
      //                         )
      //                       ],
      //                     ),
      //                     Row(
      //                       children: <Widget>[
      //                         FlatButton(
      //                             child: Text(
      //                               'keluarkan',
      //                               style: GoogleFonts.inter(
      //                                   fontSize: 15,
      //                                   fontWeight: FontWeight.w700,
      //                                   color: Colors.redAccent[100]),
      //                             ),
      //                             onPressed: () {
      //                               Widget cancelButton = FlatButton(
      //                                 child: Text("tidak jadi"),
      //                                 onPressed: () {
      //                                   Navigator.of(context,
      //                                           rootNavigator: true)
      //                                       .pop();
      //                                 },
      //                               );
      //                               Widget continueButton = FlatButton(
      //                                 child: Text("keluarkan"),
      //                                 onPressed: () {
      //                                   var kick = kick_siswa();
      //                                   kick.id_siswa = siswa.id;
      //                                   kickSiswa(context, kick);
      //                                   Navigator.of(context,
      //                                           rootNavigator: true)
      //                                       .pop();
      //                                 },
      //                               );
      //                               AlertDialog alert = AlertDialog(
      //                                 title: Text("Keluarkan Siswa"),
      //                                 content: Text(
      //                                     "Dengan mengeluarkan siswa berarti siswa tidak dapat mengisi presensi lagi, apakah kamu yakin ingin menutup kelas ?"),
      //                                 actions: [
      //                                   cancelButton,
      //                                   continueButton,
      //                                 ],
      //                               );
      //                               showDialog(
      //                                 context: context,
      //                                 builder: (BuildContext context) {
      //                                   return alert;
      //                                 },
      //                               );
      //                             }),
      //                       ],
      //                     )
      //                   ],
      //                 ),
      //               );
      //             },
      //           )
      //         ],
      //       ),
      //     ),
      //   ),
      // ]),
    );
  }
}
