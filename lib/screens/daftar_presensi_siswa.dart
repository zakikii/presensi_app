import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi_app/constants/color_constant.dart';
import 'package:presensi_app/models/daftar_presensi_siswa.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class PreviewImage extends StatelessWidget {
  // const PreviewImage({Key? key}) : super(key: key);
  PreviewImage(this.user);
  daftar_presensi_siswa user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'preview image',
            child: Image.network(this.user.url),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class DaftarPresensiSiswaScreen extends StatefulWidget {
  final List<daftar_presensi_siswa> presensi;
  DaftarPresensiSiswaScreen(this.presensi);

  @override
  State<DaftarPresensiSiswaScreen> createState() =>
      _DaftarPresensiSiswaScreenState();
}

class _DaftarPresensiSiswaScreenState extends State<DaftarPresensiSiswaScreen> {
  String kelas = '';
  final controller = TextEditingController();
  List<daftar_presensi_siswa> _presensi = List<daftar_presensi_siswa>();
  String nama_siswa = "";
  String tanggal = "";
  String tanggal_presensi = "";

  @override
  void initState() {
    super.initState();
    _presensi.addAll(widget.presensi);
    getNamaKelas();
  }

  getNamaKelas() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      kelas = pref.getString('namaKelas');
      nama_siswa = pref.getString('userName');
    });
  }

  void cariSiswa(String cari) {
    final hasil = widget.presensi.where((presensi) {
      final nama_siswa = presensi.keterangan.toLowerCase();
      final lokasi = presensi.tanggal.toLowerCase();
      final input = cari.toLowerCase();

      return nama_siswa.contains(input) || lokasi.contains(cari);
    }).toList();

    setState(() => _presensi = hasil);
  }

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
                    'Daftar Presensi Siswa',
                    style: GoogleFonts.inter(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: kWhiteColor),
                  ),
                  SizedBox(height: 10),
                  Text(
                    nama_siswa + ', ' + kelas,
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
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    padding: EdgeInsets.only(left: 16, right: 16),
                    shrinkWrap: true,
                    itemCount: _presensi.length,
                    itemBuilder: (context, index) {
                      final presensi = _presensi[index];
                      tanggal = presensi.tanggal;
                      var date = new DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                          .parseUTC(tanggal)
                          .toLocal();
                      var dateFormatter = DateFormat('HH:mm, dd-MM-yyyy ');
                      String formattedDate = dateFormatter.format(date);
                      // print(formattedDate);

                      // var dateObj = DateFormat('yyyy-MM-dd').parse(tanggal);
                      // tanggal_presensi = dateObj.toString();
                      return InkWell(
                        onTap: presensi.keterangan == 'sakit'
                            ? () {
                                Alert(
                                    style: AlertStyle(
                                      animationType: AnimationType.grow,
                                      isCloseButton: false,
                                      isOverlayTapDismiss: false,
                                      descStyle: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                      descTextAlign: TextAlign.center,
                                      animationDuration:
                                          Duration(milliseconds: 400),
                                      alertBorder: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        side: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      titleStyle: TextStyle(
                                        color: Colors.red,
                                      ),
                                      alertAlignment: Alignment.center,
                                    ),
                                    title: presensi.keterangan,
                                    desc: 'Waktu : ' +
                                        formattedDate +
                                        '\nLokasi : ' +
                                        presensi.lokasi,
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "Tutup",
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        color: Color(0xff36CCCA),
                                      ),
                                    ],
                                    context: context,
                                    image: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PreviewImage(presensi)));
                                      },
                                      child: Hero(
                                          tag: 'preview',
                                          child: Image.network(presensi.url)),
                                    )).show();
                              }
                            : presensi.keterangan == 'izin'
                                ? () {
                                    Alert(
                                        style: AlertStyle(
                                          animationType: AnimationType.grow,
                                          isCloseButton: false,
                                          isOverlayTapDismiss: false,
                                          descStyle: TextStyle(
                                              // fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                          descTextAlign: TextAlign.center,
                                          animationDuration:
                                              Duration(milliseconds: 400),
                                          alertBorder: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            side: BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          titleStyle: TextStyle(
                                            color: Colors.red,
                                          ),
                                          alertAlignment: Alignment.center,
                                        ),
                                        title: presensi.keterangan,
                                        desc: 'Waktu : ' +
                                            formattedDate +
                                            '\nLokasi : ' +
                                            presensi.lokasi,
                                        buttons: [
                                          DialogButton(
                                            child: Text(
                                              "Tutup",
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            color: Color(0xff36CCCA),
                                          ),
                                        ],
                                        context: context,
                                        image: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PreviewImage(
                                                            presensi)));
                                          },
                                          child: Hero(
                                              tag: 'preview',
                                              child:
                                                  Image.network(presensi.url)),
                                        )).show();
                                  }
                                : () {
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
                                        animationDuration:
                                            Duration(milliseconds: 400),
                                        alertBorder: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          side: BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        titleStyle: TextStyle(
                                          color: Colors.red,
                                        ),
                                        alertAlignment: Alignment.center,
                                      ),
                                      title: presensi.keterangan,
                                      desc: presensi.lokasi != null
                                          ? 'Waktu : ' +
                                              formattedDate +
                                              '\nLokasi : ' +
                                              presensi.lokasi
                                          : 'Waktu : ' +
                                              formattedDate +
                                              '\nLokasi : - ',
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "Tutup",
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
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
                                  color: presensi.keterangan == 'hadir'
                                      ? Colors.green[200]
                                      : (presensi.keterangan == 'alpha'
                                          ? Colors.red[200]
                                          : Colors.yellow[200]),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                  offset: Offset(0.0, 0.0),
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      height: 57,
                                      width: 57,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: AssetImage(presensi
                                                      .keterangan ==
                                                  'hadir'
                                              ? 'assets/images/checked.png'
                                              : (presensi.keterangan == 'alpha'
                                                  ? 'assets/images/unchecked.png'
                                                  : 'assets/images/complain.png')),
                                        ),
                                      ),
                                    ),
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
                                          presensi.keterangan,
                                          style: GoogleFonts.inter(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: kBlackColor),
                                        ),
                                        Text(
                                          formattedDate,
                                          style: GoogleFonts.inter(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: kGreyColor),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            )),
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
