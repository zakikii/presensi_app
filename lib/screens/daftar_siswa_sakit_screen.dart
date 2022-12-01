import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi_app/constants/color_constant.dart';
import 'package:presensi_app/models/daftar_tidak_hadir.dart';
import 'package:presensi_app/screens/ketidakhadiran_details.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class PreviewImage extends StatelessWidget {
  // const PreviewImage({Key? key}) : super(key: key);
  PreviewImage(this.user);
  daftar_tidak_hadir user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'preview image',
            child: Image.network(this.user.surat_bukti_url),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class DaftarSakit extends StatelessWidget {
  List<daftar_tidak_hadir> sakit;
  DaftarSakit(this.sakit);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromRGBO(30, 30, 30, 1.0),
      body: DaftarSiswaSakitScreen(this.sakit),
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

class DaftarSiswaSakitScreen extends StatefulWidget {
  final List<daftar_tidak_hadir> sakit;
  DaftarSiswaSakitScreen(this.sakit);

  @override
  State<DaftarSiswaSakitScreen> createState() => _DaftarSiswaSakitScreenState();
}

class _DaftarSiswaSakitScreenState extends State<DaftarSiswaSakitScreen> {
  String kelas = '';
  final controller = TextEditingController();
  List<daftar_tidak_hadir> _sakit = List<daftar_tidak_hadir>();
  String tanggal = '';

  @override
  void initState() {
    super.initState();
    _sakit.addAll(widget.sakit);
    getNamaKelas();
  }

  getNamaKelas() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      kelas = pref.getString('namaKelas');
    });
  }

  void cariSiswa(String cari) {
    final hasil = widget.sakit.where((sakit) {
      final nama_siswa = sakit.nama_siswa.toLowerCase();
      final lokasi = sakit.lokasi.toLowerCase();
      final input = cari.toLowerCase();

      return nama_siswa.contains(input) || lokasi.contains(cari);
    }).toList();

    setState(() => _sakit = hasil);
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
                      'daftar siswa sakit ' + kelas,
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
                            physics: BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            padding: EdgeInsets.only(left: 16, right: 16),
                            shrinkWrap: true,
                            itemCount: _sakit.length,
                            itemBuilder: (context, index) {
                              final sakit = _sakit[index];
                              tanggal = sakit.tanggal;
                              var date = new DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                                  .parseUTC(tanggal)
                                  .toLocal();
                              var dateFormatter =
                                  DateFormat('HH:mm, dd-MM-yyyy ');
                              String formattedDate = dateFormatter.format(date);
                              return InkWell(
                                onTap: () {
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
                                      title: 'Izin',
                                      desc: 'Waktu : ' +
                                          formattedDate +
                                          '\nLokasi : ' +
                                          sakit.lokasi,
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
                                                      PreviewImage(sakit)));
                                        },
                                        child: Hero(
                                            tag: 'preview',
                                            child: Image.network(
                                                sakit.surat_bukti_url)),
                                      )).show();
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
                                                sakit.nama_siswa,
                                                style: GoogleFonts.inter(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                    color: kBlackColor),
                                              ),
                                              SizedBox(
                                                width: 250,
                                                child: Text(
                                                  'waktu : ' + formattedDate,
                                                  // maxLines: 1,
                                                  overflow: TextOverflow.fade,
                                                  softWrap: false,
                                                  style: GoogleFonts.inter(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kGreyColor),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      )))
            ],
          )),
    );
  }
}
