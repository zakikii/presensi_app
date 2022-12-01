import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi_app/constants/color_constant.dart';
import 'package:presensi_app/models/daftar_kelas.dart';
import 'package:presensi_app/models/daftar_siswa.dart';
import 'package:presensi_app/screens/daftar_siswa.dart';
import 'package:presensi_app/services/kelas_service.dart';
import 'package:presensi_app/widgets/sncakbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class DaftarKelasToDaftarSiswa extends StatelessWidget {
  List<daftarKelas> kelas;
  DaftarKelasToDaftarSiswa(this.kelas);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromRGBO(30, 30, 30, 1.0),
      body: DaftarKelasScreens(this.kelas),
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
    );
  }
}

class DaftarKelasScreens extends StatefulWidget {
  final List<daftarKelas> kelas;
  DaftarKelasScreens(this.kelas);

  @override
  State<DaftarKelasScreens> createState() => _DaftarKelasScreensState();
}

class _DaftarKelasScreensState extends State<DaftarKelasScreens> {
  Future listKelas;
  String userName = "";
  int userId;
  int status;
  int idKelas;
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
      status = pref.getInt('status');
    });
  }

  void cariKelas(String cari) {
    final hasil = widget.kelas.where((kelas) {
      final nama_kelas = kelas.nama_kelas.toLowerCase();

      final input = cari.toLowerCase();

      return nama_kelas.contains(input);
    }).toList();

    setState(() => _listdaftarKelas = hasil);
  }

  getDaftarSiswa(BuildContext context, daftar_siswa daftarSiswa) async {
    var daftarsiswa = await _kelasService.daftarSiswa(daftarSiswa);
    var result = jsonDecode(daftarsiswa.body);
    // var siswa = new daftar_siswa();
    if (result['result'] == true) {
      result['data'].forEach((data) {
        var model = daftar_siswa();
        model.id = data['id'];
        model.id_kelas = data['id_kelas'];
        model.name = data['name'];
        setState(() {
          _listdaftarSiswa.add(model);
        });
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => DaftarSiswaKelasScreen(_listdaftarSiswa)));
    }
  }

  @override
  void initState() {
    var kelas = daftarKelas();
    kelas.id = userId;
    // TODO: implement initState
    super.initState();
    getuserName();
    _listdaftarKelas.addAll(widget.kelas);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
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
            SizedBox(height: 60),
            Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Daftar Kelas',
                    style: GoogleFonts.inter(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: kWhiteColor),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'guru : ' + userName,
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
                      onChanged: cariKelas,
                    ),
                  ),
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
                        padding: EdgeInsets.all(5),
                        child: ListView.builder(
                            controller: _controller,
                            physics: BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            itemCount: _listdaftarKelas.length,
                            padding: EdgeInsets.only(left: 16, right: 16),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final daftarkelas = _listdaftarKelas[index];
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 13,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  child: Text(
                                                    daftarkelas.nama_kelas,
                                                    style: GoogleFonts.inter(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: kBlackColor),
                                                  ),
                                                  onTap: () {
                                                    var siswa = daftar_siswa();
                                                    siswa.id_kelas =
                                                        daftarkelas.id;
                                                    getDaftarSiswa(
                                                        context, siswa);
                                                  },
                                                ),
                                                Text(
                                                  'jumlah siswa : ' +
                                                      daftarkelas.jumlah_siswa
                                                          .toString(),
                                                  style: GoogleFonts.inter(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kGreyColor),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        GestureDetector(
                                          child: Row(children: <Widget>[
                                            Text(
                                              daftarkelas.kode_kelas == null
                                                  ? ''
                                                  : daftarkelas.kode_kelas,
                                              style: GoogleFonts.inter(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                  color: kGreyColor),
                                            ),
                                          ]),
                                          onTap: () {
                                            Clipboard.setData(ClipboardData(
                                              text: daftarkelas.kode_kelas,
                                            ));
                                            successSnackBar(context,
                                                'kode kelas berhasil dicopy');
                                          },
                                        ),
                                      ]));
                            }
                            // Expanded(
                            //     child: Container(
                            //         decoration: BoxDecoration(
                            //             color: kWhiteColor,
                            //             borderRadius: BorderRadius.only(
                            //               topLeft: Radius.circular(40),
                            //               topRight: Radius.circular(40),
                            //             )),
                            //         child: Padding(
                            //             padding: EdgeInsets.all(5),
                            //             child: ListView.builder(
                            //               shrinkWrap: true,
                            //               controller: _controller,
                            //               itemCount: _listdaftarKelas.length,
                            //               padding: EdgeInsets.only(left: 16, right: 16),
                            //               physics: BouncingScrollPhysics(
                            //                   parent: AlwaysScrollableScrollPhysics()),
                            //               itemBuilder: (context, index) {
                            //                 final daftarkelas = _listdaftarKelas[index];
                            //                 return Container(
                            //                   height: 76,
                            //                   margin: EdgeInsets.only(bottom: 13),
                            //                   padding: EdgeInsets.only(
                            //                       left: 24, top: 12, bottom: 12, right: 22),
                            //                   decoration: BoxDecoration(
                            //                     color: kWhiteColor,
                            //                     borderRadius: BorderRadius.circular(15),
                            //                     boxShadow: [
                            //                       BoxShadow(
                            //                         color: kTenBlackColor,
                            //                         blurRadius: 10,
                            //                         spreadRadius: 5,
                            //                         offset: Offset(8.0, 8.0),
                            //                       )
                            //                     ],
                            //                   ),
                            //                   child: Row(
                            //                     mainAxisAlignment:
                            //                         MainAxisAlignment.spaceBetween,
                            //                     children: <Widget>[
                            //                       Row(
                            //                         children: <Widget>[
                            //                           SizedBox(
                            //                             width: 13,
                            //                           ),
                            //                           Column(
                            //                             crossAxisAlignment:
                            //                                 CrossAxisAlignment.start,
                            //                             mainAxisAlignment:
                            //                                 MainAxisAlignment.center,
                            //                             children: <Widget>[
                            //                               InkWell(
                            //                                 child: Text(
                            //                                   daftarkelas.nama_kelas,
                            //                                   style: GoogleFonts.inter(
                            //                                       fontSize: 18,
                            //                                       fontWeight: FontWeight.w700,
                            //                                       color: kBlackColor),
                            //                                 ),
                            //                                 onTap: () {
                            //                                   var siswa = daftar_siswa();
                            //                                   siswa.id_kelas = daftarkelas.id;
                            //                                   getDaftarSiswa(context, siswa);
                            //                                 },
                            //                               ),
                            //                               Text(
                            //                                 'jumlah siswa : ' +
                            //                                     daftarkelas.jumlah_siswa
                            //                                         .toString(),
                            //                                 style: GoogleFonts.inter(
                            //                                     fontSize: 15,
                            //                                     fontWeight: FontWeight.w400,
                            //                                     color: kGreyColor),
                            //                               ),
                            //                             ],
                            //                           )
                            //                         ],
                            //                       ),
                            //                       GestureDetector(
                            //                         child: Row(children: <Widget>[
                            //                           Text(
                            //                             daftarkelas.kode_kelas,
                            //                             style: GoogleFonts.inter(
                            //                                 fontSize: 15,
                            //                                 fontWeight: FontWeight.w400,
                            //                                 color: kGreyColor),
                            //                           ),
                            //                         ]),
                            //                         onTap: () {
                            //                           Clipboard.setData(ClipboardData(
                            //                             text: daftarkelas.kode_kelas,
                            //                           ));
                            //                           successSnackBar(context,
                            //                               'kode kelas berhasil dicopy');
                            //                         },
                            //                       ),
                            //                     ],
                            //                   ),
                            //                 );
                            //               },
                            //             ))))
                            ))))
          ],
        ),
      ),
    );
  }
}
