import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi_app/constants/color_constant.dart';
import 'package:presensi_app/models/daftar_alpha.dart';
import 'package:presensi_app/models/daftar_kelas.dart';
import 'package:presensi_app/models/ketidakhadiran.dart';
import 'package:presensi_app/models/open_close.dart';
import 'package:presensi_app/screens/data_kelas_screen.dart';
import 'package:presensi_app/services/kelas_service.dart';
import 'package:presensi_app/services/presensi_service.dart';
import 'package:presensi_app/widgets/sncakbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class DaftarKelas extends StatelessWidget {
  List<daftarKelas> kelas;
  DaftarKelas(this.kelas);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromRGBO(30, 30, 30, 1.0),
      body: DaftarKelasScreen(this.kelas),
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

class DaftarKelasScreen extends StatefulWidget {
  // final int idGuru;
  final List<daftarKelas> kelas;
  DaftarKelasScreen(this.kelas);

  @override
  State<DaftarKelasScreen> createState() => _DaftarKelasScreenState();
}

class _DaftarKelasScreenState extends State<DaftarKelasScreen> {
  Future listKelas;
  String userName = "";
  int userId;
  int status;
  int idKelas;
  String _status;
  List<daftarKelas> _listdaftarKelas = List<daftarKelas>();
  // List<daftarKelas> _listkelas = List<daftarKelas>();
  List<daftar_alpha> _listaAlpha = List<daftar_alpha>();
  int jumlah_alpha = 0;
  ScrollController _controller = new ScrollController();

  getuserName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userName = pref.getString('userName');
      userId = pref.getInt('userId');
      status = pref.getInt('status');
    });
  }

  // getDaftarKelas() async {
  //   kelasService _kelasService = kelasService();
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   var kelas = daftarKelas();
  //   kelas.id_guru = pref.getInt('userId');
  //   var dataKelas = await _kelasService.getDaftarKelas(kelas);
  //   var result = json.decode(dataKelas.body);
  //   result['data'].forEach((data) {
  //     var model = daftarKelas();
  //     model.id = data['id'];
  //     model.nama_kelas = data['nama_kelas'];
  //     model.id_guru = data['id_guru'];
  //     model.jumlah_siswa = data['jumlah_siswa'];
  //     model.detail_kelas = data['detail_kelas'];
  //     model.status = data['status'];
  //     model.CreatedAt = data['created_at'];
  //     setState(() {
  //       _listdaftarKelas.add(model);
  //       // pref.setString('namakelas', data['nama_kelas']);
  //     });
  //   });
  // }

  openKelas(BuildContext context, openClose openclass) async {
    var _kelasService = kelasService();
    var open = await _kelasService.openKelas(openclass, idKelas.toString());
    var result = jsonDecode(open.body);
    if (result['result'] == true) {
      successSnackBar(context, 'success opened');
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
    } else {
      errorSnackBar(context, 'failed');
    }
  }

  closeKelas(BuildContext context, openClose openclass) async {
    var _kelasService = kelasService();
    var open = await _kelasService.openKelas(openclass, idKelas.toString());
    var result = jsonDecode(open.body);
    if (result['result'] == true) {
      successSnackBar(context, 'success opened');
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
    } else {
      errorSnackBar(context, 'failed');
    }
  }

  _getDaftarAlpha(BuildContext context, daftar_alpha alpha) async {
    jumlah_alpha = 0;
    kelasService _kelasService = kelasService();
    var daftarAlpha = await _kelasService.tanpaKeterangan(alpha);
    var result = jsonDecode(daftarAlpha.body);
    if (result['result'] == true) {
      result['data'].forEach((alpha) {
        var _alpha = daftar_alpha();
        _alpha.id = alpha['id'];
        _alpha.name = alpha['name'];
        _alpha.id_kelas = alpha['id_kelas'];

        setState(() {
          _listaAlpha.add(_alpha);
          jumlah_alpha = result['count'];
        });
      });
      var tidakHadir = KetidakHadiran();
      for (int i = 0; i < _listaAlpha.length; i++) {
        tidakHadir.id_kelas = _listaAlpha[i].id_kelas;
        tidakHadir.user_id = _listaAlpha[i].id;
        tidakHadir.nama_siswa = _listaAlpha[i].name;
        tidakHadir.keterangan = "alpha";
        tidakHadir.detail = "";
        tidakHadir.surat_bukti_url = "";
        tidakHadir.lokasi = "";
        _postAlpha(context, tidakHadir);
      }
    }
  }

  void cariKelas(String cari) {
    final hasil = widget.kelas.where((kelas) {
      final nama_kelas = kelas.nama_kelas.toLowerCase();

      final input = cari.toLowerCase();

      return nama_kelas.contains(input);
    }).toList();

    setState(() => _listdaftarKelas = hasil);
  }

  _postAlpha(BuildContext context, KetidakHadiran ketidakHadiran) async {
    var _presensiService = presensiService();
    var tidakHadir = await _presensiService.tidakHadir(ketidakHadiran);
    var result = jsonDecode(tidakHadir.body);
    if (result['result'] == true) {
      successSnackBar(context, 'data alpha berhasil tersimpan');
    } else {
      errorSnackBar(context, 'data tidak tersimpan');
    }
  }

  @override
  void initState() {
    var kelas = daftarKelas();
    kelas.id = userId;
    // TODO: implement initState
    super.initState();
    _listdaftarKelas.addAll(widget.kelas);
    getuserName();
    // getDaftarKelas();
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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
                                        left: 24,
                                        top: 12,
                                        bottom: 12,
                                        right: 22),
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
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  DataKelasScreen(
                                                                    kelas:
                                                                        daftarkelas,
                                                                  )));
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
                                          Row(
                                            children: <Widget>[
                                              TextButton(
                                                child: Text(
                                                  daftarkelas.status == 0
                                                      ? 'closed'
                                                      : 'open',
                                                  style: GoogleFonts.inter(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          daftarkelas.status ==
                                                                  0
                                                              ? kGreyColor
                                                              : kBlueColor),
                                                ),
                                                onPressed: () {
                                                  idKelas = daftarkelas.id;
                                                  var _open = new openClose();
                                                  if (daftarkelas.status == 0) {
                                                    _open.status = 1;
                                                    openKelas(context, _open);
                                                  } else {
                                                    Widget cancelButton =
                                                        TextButton(
                                                      child:
                                                          Text("nanti aja deh"),
                                                      onPressed: () {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                      },
                                                    );
                                                    Widget continueButton =
                                                        TextButton(
                                                      child: Text("tutup"),
                                                      onPressed: () {
                                                        var now =
                                                            new DateTime.now();
                                                        var formatter =
                                                            new DateFormat(
                                                                'yyyy-MM-dd');
                                                        String formattedDate =
                                                            formatter
                                                                .format(now);
                                                        var alpha =
                                                            daftar_alpha();
                                                        alpha.id_kelas =
                                                            idKelas;
                                                        alpha.tanggal =
                                                            formattedDate;
                                                        _getDaftarAlpha(
                                                            context, alpha);

                                                        _open.status = 0;
                                                        openKelas(
                                                            context, _open);
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                      },
                                                    );
                                                    AlertDialog alert =
                                                        AlertDialog(
                                                      title:
                                                          Text("Tutup Kelas"),
                                                      content: Text(
                                                          "Dengan menutup kelas berarti siswa tidak dapat mengisi presensi lagi, apakah kamu yakin ingin menutup kelas ?"),
                                                      actions: [
                                                        cancelButton,
                                                        continueButton,
                                                      ],
                                                    );
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return alert;
                                                      },
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ]));
                              }))))
            ],
          )),
    );
  }
}

//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       backgroundColor: mainColor,
//       appBar: new AppBar(
//         elevation: 0.0,
//         backgroundColor: Colors.transparent,
//         actions: [],
//         // foregroundColor: Colors.black,
//         textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.black)),
//         leading: GestureDetector(
//           child: Icon(Icons.arrow_back_ios, color: Colors.white),
//           onTap: () {
//             Navigator.pop(context);
//           },
//         ),
//         centerTitle: true,
//       ),
//       body: Stack(children: [
//         Container(
//           height: size.height * .60 / 2,
//           decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   backgroundColor1,
//                   backgroundColor2,
//                 ],
//               ),
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(40),
//                 bottomRight: Radius.circular(40),
//               )),
//         ),
//         SafeArea(
//           child: Container(
//             margin: EdgeInsets.only(top: 8),
//             child: ListView(
//               physics: ClampingScrollPhysics(),
//               children: <Widget>[
//                 Padding(
//                   padding:
//                       EdgeInsets.only(left: 16, bottom: 13, top: 10, right: 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         'Daftar Kelas',
//                         style: GoogleFonts.inter(
//                             fontSize: 30,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.white),
//                       ),
//                       Text(
//                         'nama guru : ' + userName,
//                         style: GoogleFonts.inter(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.white),
//                       )
//                     ],
//                   ),

//                   //
//                 ),
//                 ListView.builder(
//                   controller: _controller,
//                   physics: BouncingScrollPhysics(
//                       parent: AlwaysScrollableScrollPhysics()),
//                   itemCount: _listdaftarKelas.length,
//                   padding: EdgeInsets.only(left: 16, right: 16),
//                   shrinkWrap: true,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       height: 76,
//                       margin: EdgeInsets.only(bottom: 13),
//                       padding: EdgeInsets.only(
//                           left: 24, top: 12, bottom: 12, right: 22),
//                       decoration: BoxDecoration(
//                         color: kWhiteColor,
//                         borderRadius: BorderRadius.circular(15),
//                         boxShadow: [
//                           BoxShadow(
//                             color: kTenBlackColor,
//                             blurRadius: 10,
//                             spreadRadius: 5,
//                             offset: Offset(8.0, 8.0),
//                           )
//                         ],
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Row(
//                             children: <Widget>[
//                               SizedBox(
//                                 width: 13,
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//                                   InkWell(
//                                     child: Text(
//                                       _listdaftarKelas[index].nama_kelas,
//                                       style: GoogleFonts.inter(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w700,
//                                           color: kBlackColor),
//                                     ),
//                                     onTap: () {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (_) => DataKelasScreen(
//                                                     kelas:
//                                                         _listdaftarKelas[index],
//                                                   )));
//                                     },
//                                   ),
//                                   Text(
//                                     'jumlah siswa : ' +
//                                         _listdaftarKelas[index]
//                                             .jumlah_siswa
//                                             .toString(),
//                                     style: GoogleFonts.inter(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w400,
//                                         color: kGreyColor),
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                           Row(
//                             children: <Widget>[
//                               FlatButton(
//                                 child: Text(
//                                   _listdaftarKelas[index].status == 0
//                                       ? 'closed'
//                                       : 'open',
//                                   style: GoogleFonts.inter(
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w700,
//                                       color: _listdaftarKelas[index].status == 0
//                                           ? kGreyColor
//                                           : kBlueColor),
//                                 ),
//                                 onPressed: () {
//                                   idKelas = _listdaftarKelas[index].id;
//                                   var _open = new openClose();
//                                   if (_listdaftarKelas[index].status == 0) {
//                                     _open.status = 1;
//                                     openKelas(context, _open);
//                                   } else {
//                                     Widget cancelButton = FlatButton(
//                                       child: Text("nanti aja deh"),
//                                       onPressed: () {
//                                         Navigator.of(context,
//                                                 rootNavigator: true)
//                                             .pop();
//                                       },
//                                     );
//                                     Widget continueButton = FlatButton(
//                                       child: Text("tutup"),
//                                       onPressed: () {
//                                         var now = new DateTime.now();
//                                         var formatter =
//                                             new DateFormat('yyyy-MM-dd');
//                                         String formattedDate =
//                                             formatter.format(now);
//                                         var alpha = daftar_alpha();
//                                         alpha.id_kelas = idKelas;
//                                         alpha.tanggal = formattedDate;
//                                         _getDaftarAlpha(context, alpha);

//                                         _open.status = 0;
//                                         openKelas(context, _open);
//                                         Navigator.of(context,
//                                                 rootNavigator: true)
//                                             .pop();
//                                       },
//                                     );
//                                     AlertDialog alert = AlertDialog(
//                                       title: Text("Tutup Kelas"),
//                                       content: Text(
//                                           "Dengan menutup kelas berarti siswa tidak dapat mengisi presensi lagi, apakah kamu yakin ingin menutup kelas ?"),
//                                       actions: [
//                                         cancelButton,
//                                         continueButton,
//                                       ],
//                                     );
//                                     showDialog(
//                                       context: context,
//                                       builder: (BuildContext context) {
//                                         return alert;
//                                       },
//                                     );
//                                   }
//                                 },
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     );
//                   },
//                 )
//               ],
//             ),
//           ),
//         ),
//       ]),
//     );
//   }
// }
