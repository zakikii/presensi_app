import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi_app/constants/color_constant.dart';
import 'package:presensi_app/models/daftar_alpha.dart';
import 'package:presensi_app/models/daftar_hadir.dart';
import 'package:presensi_app/models/daftar_tidak_hadir.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DaftarAlpha extends StatelessWidget {
  List<daftar_tidak_hadir> alpha;
  DaftarAlpha(this.alpha);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromRGBO(30, 30, 30, 1.0),
      body: DaftarAlphaScreen(this.alpha),
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

class DaftarAlphaScreen extends StatefulWidget {
  final List<daftar_tidak_hadir> alpha;
  DaftarAlphaScreen(this.alpha);

  @override
  State<DaftarAlphaScreen> createState() => _DaftarAlphaScreenState();
}

class _DaftarAlphaScreenState extends State<DaftarAlphaScreen> {
  String kelas = '';
  final controller = TextEditingController();
  List<daftar_tidak_hadir> _alpha = List<daftar_tidak_hadir>();

  @override
  void initState() {
    super.initState();
    _alpha.addAll(widget.alpha);
    getNamaKelas();
  }

  getNamaKelas() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      kelas = pref.getString('namaKelas');
    });
  }

  void cariSiswa(String cari) {
    final hasil = widget.alpha.where((alpha) {
      final nama_siswa = alpha.nama_siswa;
      final input = cari.toLowerCase();

      return nama_siswa.contains(input);
    }).toList();

    setState(() => _alpha = hasil);
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
                      'Daftar Presensi Siswa',
                      style: GoogleFonts.inter(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: kWhiteColor),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'daftar siswa alpha ' + kelas,
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
                        onChanged: cariSiswa,
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
                            padding: EdgeInsets.only(left: 16, right: 16),
                            shrinkWrap: true,
                            itemCount: _alpha.length,
                            itemBuilder: (context, index) {
                              final alpha = _alpha[index];
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
                                            Text(
                                              alpha.nama_siswa,
                                              style: GoogleFonts.inter(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: kBlackColor),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                      )))
            ],
          )),
    );
  }
}

//     return Scaffold(
//       body: Stack(children: <Widget>[
//         Container(
//           height: size.height * .35,
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
//                       EdgeInsets.only(left: 16, bottom: 13, top: 29, right: 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         'Daftar Siswa Tanpa Keterangan',
//                         style: GoogleFonts.inter(
//                             fontSize: 30,
//                             fontWeight: FontWeight.w700,
//                             color: kWhiteColor),
//                       ),
//                       // Text(
//                       //   'Kelas : ' + kelas,
//                       //   style: GoogleFonts.inter(
//                       //       fontSize: 18,
//                       //       fontWeight: FontWeight.w700,
//                       //       color: kWhiteColor),
//                       // ),
//                       Container(
//                         margin: EdgeInsets.symmetric(vertical: 30),
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 30, vertical: 5),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(29.5),
//                         ),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             hintText: "Search",
//                             icon: SvgPicture.asset("assets/icons/search.svg"),
//                             border: InputBorder.none,
//                           ),
//                           onChanged: cariSiswa,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 ListView.builder(
//                   padding: EdgeInsets.only(left: 16, right: 16),
//                   shrinkWrap: true,
//                   itemCount: _alpha.length,
//                   itemBuilder: (context, index) {
//                     final alpha = _alpha[index];
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
//                                   Text(
//                                     alpha.nama_siswa,
//                                     style: GoogleFonts.inter(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w700,
//                                         color: kBlackColor),
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
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
