import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi_app/constants/color_constant.dart';
import 'package:presensi_app/models/daftar_siswa.dart';
import 'package:presensi_app/models/kick_siswa.dart';
import 'package:presensi_app/screens/enter_class.dart';
import 'package:presensi_app/services/kelas_service.dart';
import 'package:presensi_app/widgets/sncakbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class InfoKelasScreen extends StatefulWidget {
  final List<daftar_siswa> siswa;
  InfoKelasScreen(this.siswa);

  @override
  State<InfoKelasScreen> createState() => _InfoKelasScreenState();
}

class _InfoKelasScreenState extends State<InfoKelasScreen> {
  String kelas = '';
  String guru = '';
  int userId = 0;
  final controller = TextEditingController();
  List<daftar_siswa> _siswa = List<daftar_siswa>();
  int idKelas = 0;

  @override
  void initState() {
    super.initState();
    _siswa.addAll(widget.siswa);
    getUserData();
  }

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      kelas = pref.getString('namaKelas');
      guru = pref.getString('namaGuru');
      userId = pref.getInt('userId');
      idKelas = pref.getInt('idKelasSiswa');
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

  keluarKelas(BuildContext context, kick_siswa out) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    kelasService _kelasService = kelasService();
    var kick_siswa = await _kelasService.kickSiswa(out);
    var result = json.decode(kick_siswa.body);
    if (result['result'] == true) {
      successSnackBar(context, 'Berhasil keluar dari Kelas');
      const Duration(seconds: 2);
      setState(() {
        pref.remove('idKelasSiswa');
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => EnterClassScreen()));
    } else {
      errorSnackBar(context, 'Gagal keluar dari kelas');
    }
  }

  //

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
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        // height: 59,
                        width: 59,
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(20),
                        //   image: DecorationImage(
                        //     image: AssetImage('assets/images/user.png'),
                        //   ),
                        // ),
                      ),
                      GestureDetector(
                          onTap: () {
                            Dialogs.materialDialog(
                              context: context,
                              color: Colors.white,
                              msg: 'Apakah kamu yakin ingin keluar kelas ?',
                              title: 'Keluar Kelas',
                              lottieBuilder: LottieBuilder.asset(
                                'assets/lottie/keluar-kelas.json',
                                fit: BoxFit.contain,
                              ),
                              actions: [
                                IconsButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  text: 'ngga jadi',
                                  iconData: Icons.cancel_outlined,
                                  // color: Colors.blue,
                                  textStyle: TextStyle(color: Colors.grey),
                                  iconColor: Colors.grey,
                                ),
                                IconsButton(
                                  onPressed: () {
                                    var out = new kick_siswa();
                                    out.id_siswa = userId;
                                    out.id_kelas = idKelas;
                                    keluarKelas(context, out);
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                  text: 'Keluar',
                                  iconData: Icons.done,
                                  color: Colors.red,
                                  textStyle: TextStyle(color: Colors.white),
                                  iconColor: Colors.white,
                                ),
                              ],
                            );
                          },
                          // onTap: () {
                          //   Widget cancelButton = FlatButton(
                          //     child: Text("batal"),
                          //     onPressed: () {
                          //       Navigator.of(context, rootNavigator: true)
                          //           .pop();
                          //     },
                          //   );
                          //   Widget continueButton = FlatButton(
                          //     child: Text("keluar"),
                          //     onPressed: () {
                          //       var out = new kick_siswa();
                          //       out.id_siswa = userId;
                          //       keluarKelas(context, out);
                          //       Navigator.of(context, rootNavigator: true)
                          //           .pop();
                          //     },
                          //   );
                          //   AlertDialog alert = AlertDialog(
                          //     title: Text("Logout"),
                          //     content: Text("Apakah kamu yakin ingin keluar ?"),
                          //     actions: [
                          //       cancelButton,
                          //       continueButton,
                          //     ],
                          //   );
                          //   showDialog(
                          //     context: context,
                          //     builder: (BuildContext context) {
                          //       return alert;
                          //     },
                          //   );
                          //   ;
                          // },
                          child: Icon(
                            Icons.exit_to_app_outlined,
                            size: 28,
                            color: Colors.white,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Kelas ' + kelas,
                    style: GoogleFonts.inter(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: kWhiteColor),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'guru : ' + guru,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 40),
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
            // SizedBox(height: 10),
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
                      return GestureDetector(
                        onTap: () {
                          Alert(
                            context: context,
                            style: AlertStyle(
                              animationType: AnimationType.grow,
                              isCloseButton: false,
                              isOverlayTapDismiss: false,
                              descStyle: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 15),
                              descTextAlign: TextAlign.center,
                              animationDuration: Duration(milliseconds: 400),
                              alertBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                side: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              titleStyle: TextStyle(
                                color: Colors.red,
                              ),
                              alertAlignment: Alignment.center,
                            ),
                            title: 'Data siswa',
                            desc: 'Nama : ' +
                                siswa.name +
                                '\nEmail : ' +
                                siswa.email,
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Tutup",
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                                color: Color(0xff36CCCA),
                              ),
                            ],
                          ).show();
                        },
                        child: Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 230,
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
                              // Row(
                              //   children: <Widget>[

                              //   ],
                              // )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
