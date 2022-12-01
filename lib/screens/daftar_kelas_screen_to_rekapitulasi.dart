import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi_app/constants/color_constant.dart';
import 'package:presensi_app/models/daftar_kelas.dart';
import 'package:presensi_app/models/daftar_siswa.dart';
import 'package:presensi_app/models/kelas.dart';
import 'package:presensi_app/screens/daftar_siswa.dart';
import 'package:presensi_app/screens/rekapitulasi_presensi.dart';
import 'package:presensi_app/services/kelas_service.dart';
import 'package:presensi_app/widgets/sncakbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class DaftarKelasScreenRekapitulasi extends StatefulWidget {
  // final int idGuru;

  // DaftarKelasScreenRekapitulasi({this.idGuru});

  @override
  State<DaftarKelasScreenRekapitulasi> createState() =>
      _DaftarKelasScreenRekapitulasiState();
}

class _DaftarKelasScreenRekapitulasiState
    extends State<DaftarKelasScreenRekapitulasi> {
  String semester;
  String bulan;
  Future listKelas;
  String userName = "";
  int userId;
  int status;
  int idKelas;
  DateTime sekarang = DateTime.now();
  String _status;
  List<daftarKelas> _listdaftarKelas = List<daftarKelas>();
  List<daftar_siswa> _listdaftarSiswa = List<daftar_siswa>();
  var _kelasService = kelasService();
  ScrollController _controller = new ScrollController();

  getuserName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userName = pref.getString('userName');
      userId = pref.getInt('userId');
      // status = pref.getInt('status');
    });
  }

  getDaftarKelas() async {
    kelasService _kelasService = kelasService();
    SharedPreferences pref = await SharedPreferences.getInstance();
    var kelas = daftarKelas();
    kelas.id_guru = pref.getInt('userId');
    var dataKelas = await _kelasService.getDaftarKelas(kelas);
    var result = json.decode(dataKelas.body);
    result['data'].forEach((data) {
      var model = daftarKelas();
      model.id = data['id'];
      model.nama_kelas = data['nama_kelas'];
      model.id_guru = data['id_guru'];
      model.jumlah_siswa = data['jumlah_siswa'];
      model.detail_kelas = data['detail_kelas'];
      model.status = data['status'];
      model.kode_kelas = data['kode_kelas'];
      model.CreatedAt = data['created_at'];

      setState(() {
        _listdaftarKelas.add(model);
        pref.setString('namaKelas', data['nama_kelas']);
      });
    });
  }

  getDataKelas(BuildContext context, Kelas kelas) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var dataKelas = await _kelasService.getDataKelas(kelas);
    var result = jsonDecode(dataKelas.body);
    // var siswa = new daftar_siswa();
    if (result['result'] == true) {
      setState(() {
        // _listdaftarSiswa.add(model);
        pref.setString('namaKelas', result['data']['nama_kelas']);
        pref.setInt('idKelas', result['data']['id']);
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => RekapitulasiPresensi()));
    }
  }

  @override
  void initState() {
    var kelas = daftarKelas();
    kelas.id = userId;
    // TODO: implement initState
    super.initState();
    getuserName();
    getDaftarKelas();
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
      body: Stack(children: <Widget>[
        Container(
          height: size.height * .60 / 2,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  backgroundColor1,
                  backgroundColor2,
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              )),
        ),
        SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 8),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(left: 16, bottom: 13, top: 0, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Rekapitulasi ',
                        style: GoogleFonts.inter(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: kWhiteColor),
                      ),
                      Text(
                        'guru : ' + userName,
                        style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: kWhiteColor),
                      )
                    ],
                  ),

                  //
                ),
                SizedBox(
                  height: 20,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  controller: _controller,
                  itemCount: _listdaftarKelas.length,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemBuilder: (context, index) {
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
                                  InkWell(
                                    child: Text(
                                      _listdaftarKelas[index].nama_kelas,
                                      style: GoogleFonts.inter(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: kBlackColor),
                                    ),
                                    onTap: () {
                                      var kelas = Kelas();
                                      kelas.id = _listdaftarKelas[index].id;
                                      getDataKelas(context, kelas);
                                    },
                                  ),
                                  Text(
                                    'jumlah siswa : ' +
                                        _listdaftarKelas[index]
                                            .jumlah_siswa
                                            .toString(),
                                    style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: kGreyColor),
                                  ),
                                ],
                              )
                            ],
                          ),
                          // DropdownButton<String>(
                          //   // isExpanded: true,
                          //   value: bulan,
                          //   style: TextStyle(color: Colors.black),
                          //   items: <String>[
                          //     '1',
                          //     '2',
                          //     '3',
                          //     '4',
                          //     '5',
                          //     '6',
                          //     '7',
                          //     '8',
                          //     '9',
                          //     '10',
                          //     '11',
                          //     '12'
                          //   ].map<DropdownMenuItem<String>>((String value) {
                          //     return DropdownMenuItem<String>(
                          //       value: value,
                          //       child: Text(
                          //         value,
                          //         style: GoogleFonts.inter(
                          //             fontSize: 14,
                          //             fontWeight: FontWeight.w700,
                          //             color: kBlackColor),
                          //       ),
                          //     );
                          //   }).toList(),
                          //   hint: Text(
                          //     'bulan',
                          //     style: GoogleFonts.inter(
                          //         fontSize: 14,
                          //         fontWeight: FontWeight.w700,
                          //         color: kBlackColor),
                          //   ),
                          //   onChanged: (String value) {
                          //     setState(() {
                          //       bulan = value;
                          //     });
                          //   },
                          // ),
                          // DropdownButton<String>(
                          //   alignment: Alignment.center,
                          //   // isExpanded: true,
                          //   value: semester,
                          //   style: TextStyle(color: Colors.black),
                          //   items: <String>[
                          //     sekarang.year.toString(),
                          //   ].map<DropdownMenuItem<String>>((String value) {
                          //     return DropdownMenuItem<String>(
                          //       value: value,
                          //       child: Text(
                          //         value,
                          //         style: GoogleFonts.inter(
                          //             fontSize: 14,
                          //             fontWeight: FontWeight.w700,
                          //             color: kBlackColor),
                          //       ),
                          //     );
                          //   }).toList(),
                          //   hint: Text(
                          //     'semester',
                          //     style: GoogleFonts.inter(
                          //         fontSize: 14,
                          //         fontWeight: FontWeight.w700,
                          //         color: kBlackColor),
                          //   ),
                          //   onChanged: (String value) {
                          //     setState(() {
                          //       semester = value;
                          //     });
                          //   },
                          // ),
                          // GestureDetector(
                          //   child: Row(children: <Widget>[
                          //     Text(
                          //       _listdaftarKelas[index].kode_kelas,
                          //       style: GoogleFonts.inter(
                          //           fontSize: 15,
                          //           fontWeight: FontWeight.w400,
                          //           color: kGreyColor),
                          //     ),
                          //   ]),
                          //   onTap: () {
                          //     Clipboard.setData(ClipboardData(
                          //       text: _listdaftarKelas[index].kode_kelas,
                          //     ));
                          //     successSnackBar(
                          //         context, 'kode kelas berhasil dicopy');
                          //   },
                          // ),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
