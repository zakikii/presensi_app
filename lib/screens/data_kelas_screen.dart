import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:presensi_app/constants/color_constant.dart';
import 'package:presensi_app/models/daftar_alpha.dart';
import 'package:presensi_app/models/daftar_hadir.dart';
import 'package:presensi_app/models/daftar_kelas.dart';
import 'package:intl/intl.dart';
import 'package:presensi_app/models/daftar_tidak_hadir.dart';
import 'package:presensi_app/screens/daftar_siswa_alpha_screen.dart';
import 'package:presensi_app/screens/daftar_siswa_hadir_screen.dart';
import 'package:presensi_app/screens/daftar_siswa_izin_screen.dart';
import 'package:presensi_app/screens/daftar_siswa_sakit_screen.dart';
import 'package:presensi_app/services/kelas_service.dart';
import 'package:presensi_app/widgets/category_card.dart';
import 'package:presensi_app/widgets/sncakbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class DataKelas extends StatelessWidget {
//   // const name({Key? key}) : super(key: key);
//   final daftarKelas kelas;
//   DataKelas({this.kelas});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       backgroundColor: Color.fromRGBO(30, 30, 30, 1.0),
//       body: DataKelasScreen(
//         kelas: this.kelas,
//       ),
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
//     );
//   }
// }

class DataKelasScreen extends StatefulWidget {
  final daftarKelas kelas;
  DataKelasScreen({this.kelas});

  @override
  State<DataKelasScreen> createState() => _DataKelasScreenState();
}

class _DataKelasScreenState extends State<DataKelasScreen> {
  Future _list;
  DateTime tanggal;
  DateTime _selectedValue;
  String sekarang = '';
  int id_kelas = 0;
  int jumlah_hadir = 0;
  int jumlah_sakit = 0;
  int jumlah_izin = 0;
  int jumlah_alpha = 0;
  String keterangan = "";
  String cari = '';
  // int hadir = 0;
  String kelas = '';
  List<daftar_hadir> listHadir = List<daftar_hadir>();
  List<daftar_tidak_hadir> listSakit = List<daftar_tidak_hadir>();
  List<daftar_tidak_hadir> listIzin = List<daftar_tidak_hadir>();
  List<daftar_tidak_hadir> listAlpha = List<daftar_tidak_hadir>();
  bool libur = false;

  _getDaftarHadir(BuildContext context, daftar_hadir hadir) async {
    jumlah_hadir = 0;
    listHadir.clear();
    kelasService _kelasService = kelasService();
    var daftarhadir = await _kelasService.daftarHadir(hadir);
    var result = json.decode(daftarhadir.body);
    if (result['result'] == true) {
      result['data'].forEach((attendance) {
        var _hadir = daftar_hadir();
        // model.id = attendance['id'];
        _hadir.id_kelas = attendance['id_kelas'];
        _hadir.user_id = attendance['user_id'];
        _hadir.nama_siswa = attendance['nama_siswa'];
        _hadir.lokasi = attendance['lokasi'];
        _hadir.tanggal = attendance['created_at'];
        setState(() {
          listHadir.add(_hadir);
          jumlah_hadir = result['count'];
        });
      });
    }
    return _list;
  }

  setNamaKelas() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // kelas = widget.kelas.nama_kelas;
    pref.setString('namaKelas', widget.kelas.nama_kelas);
  }

  _getDaftarTidakHadir(
      BuildContext context, daftar_tidak_hadir tidakhadir) async {
    jumlah_sakit = 0;
    jumlah_izin = 0;
    jumlah_alpha = 0;
    listAlpha.clear();
    listIzin.clear();
    listSakit.clear();
    kelasService _kelasService = kelasService();
    var daftarTidakHadir = await _kelasService.daftarTidakHadir(tidakhadir);
    var result = jsonDecode(daftarTidakHadir.body);
    if (result['result'] == true) {
      result['data'].forEach((tidak_hadir) {
        var _tidak_hadir = daftar_tidak_hadir();
        _tidak_hadir.id_kelas = tidak_hadir['id_kelas'];
        _tidak_hadir.user_id = tidak_hadir['user_id'];
        _tidak_hadir.nama_siswa = tidak_hadir['nama_siswa'];
        _tidak_hadir.keterangan = tidak_hadir['keterangan'];
        _tidak_hadir.detail = tidak_hadir['detail'];
        _tidak_hadir.surat_bukti_url = tidak_hadir['surat_bukti_url'];
        _tidak_hadir.lokasi = tidak_hadir['lokasi'];
        _tidak_hadir.tanggal = tidak_hadir['created_at'];
        setState(() {
          if (_tidak_hadir.keterangan == 'sakit') {
            listSakit.add(_tidak_hadir);
            jumlah_sakit = result['count'];
          }
          if (_tidak_hadir.keterangan == 'alpha') {
            listAlpha.add(_tidak_hadir);
            jumlah_alpha = result['count'];
          }
          if (_tidak_hadir.keterangan == 'izin') {
            listIzin.add(_tidak_hadir);
            jumlah_izin = result['count'];
          }
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
    setNamaKelas();
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
        body: Stack(
          children: <Widget>[
            Container(
              height: size.height * .45,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        alignment: Alignment.center,
                        height: 52,
                        width: 52,
                      ),
                    ),
                    Text(
                      'Kelas ' + widget.kelas.nama_kelas,
                      style: GoogleFonts.inter(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: kWhiteColor),
                    ),
                    Text(
                      'Jumlah siswa  : ' + widget.kelas.jumlah_siswa.toString(),
                      style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: kWhiteColor),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 50),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: Center(
                        child: InkWell(
                          child: Text(
                            'tanggal : ' + sekarang,
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: kWhiteColor,
                                backgroundColor: libur
                                    ? Colors.redAccent[100]
                                    : backgroundColor2),
                          ),
                          onTap: () async {
                            tanggal = await showDatePicker(
                                context: context,
                                initialDate:
                                    tanggal == null ? DateTime.now() : tanggal,
                                firstDate: DateTime(2022),
                                lastDate: DateTime.now());
                            if (DateFormat('EEE').format(tanggal) == 'Sun') {
                              Dialogs.materialDialog(
                                context: context,
                                color: Colors.white,
                                msg:
                                    'Tanggal yang anda pilih adalah hari minggu',
                                title: 'Liburr Gaes',
                                lottieBuilder: LottieBuilder.asset(
                                  'assets/lottie/fishing.json',
                                  fit: BoxFit.contain,
                                ),
                              );
                              libur = true;
                            } else {
                              libur = false;
                            }
                            setState(() {
                              sekarang =
                                  DateFormat('EEE, dd-MM-yyyy').format(tanggal);
                              cari = DateFormat('yyyy-MM-dd').format(tanggal);
                              if (libur == true) {
                                errorSnackBar(
                                    context, 'tidak ada data presensi');
                              } else {
                                id_kelas = widget.kelas.id;
                                var hadir = daftar_hadir();
                                var sakit = daftar_tidak_hadir();
                                var izin = daftar_tidak_hadir();
                                var alpha = daftar_tidak_hadir();
                                hadir.id_kelas = id_kelas;
                                hadir.tanggal = cari;
                                sakit.id_kelas = id_kelas;
                                sakit.tanggal = cari;
                                sakit.keterangan = 'sakit';
                                hadir.id_kelas = id_kelas;
                                hadir.tanggal = cari;
                                izin.id_kelas = id_kelas;
                                izin.tanggal = cari;
                                izin.keterangan = 'izin';
                                alpha.id_kelas = id_kelas;
                                alpha.tanggal = cari;
                                alpha.keterangan = 'alpha';
                                _getDaftarTidakHadir(context, sakit);
                                _getDaftarHadir(context, hadir);
                                _getDaftarTidakHadir(context, izin);
                                _getDaftarTidakHadir(context, alpha);
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        // childAspectRatio: .85,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CategoryCard(
                              title: "Hadir : " + jumlah_hadir.toString(),
                              svgSrc: "assets/images/hadir.png",
                              warna: Colors.green[200],
                              press: () {
                                if (cari != '') {
                                  if (jumlah_hadir == 0) {
                                    errorSnackBar(
                                        context, 'data hadir tidak ditemukan');
                                  } else {
                                    var hadir = daftar_hadir();
                                    Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (_) =>
                                              new DaftarHadir(listHadir)),
                                    );
                                  }
                                } else {
                                  errorSnackBar(context, 'tanggal belum diisi');
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CategoryCard(
                              title: "Sakit : " + jumlah_sakit.toString(),
                              svgSrc: "assets/images/sakit.png",
                              warna: Colors.yellow[200],
                              press: () {
                                if (cari != '') {
                                  if (jumlah_sakit == 0) {
                                    errorSnackBar(
                                        context, 'data hadir tidak ditemukan');
                                  } else {
                                    var hadir = daftar_hadir();
                                    Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (_) =>
                                              new DaftarSakit(listSakit)),
                                    );
                                  }
                                } else {
                                  errorSnackBar(context, 'tanggal belum diisi');
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CategoryCard(
                              title: "Izin : " + jumlah_izin.toString(),
                              svgSrc: "assets/images/izin.png",
                              warna: Colors.yellow[200],
                              press: () {
                                if (cari != '') {
                                  if (jumlah_izin == 0) {
                                    errorSnackBar(
                                        context, 'data hadir tidak ditemukan');
                                  } else {
                                    var hadir = daftar_hadir();
                                    Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (_) =>
                                              new DaftarIzin(listIzin)),
                                    );
                                  }
                                } else {
                                  errorSnackBar(context, 'tanggal belum diisi');
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CategoryCard(
                              title: "Alpha : " + jumlah_alpha.toString(),
                              svgSrc: "assets/images/alpha.png",
                              warna: Colors.red[200],
                              press: () {
                                if (cari != '') {
                                  if (jumlah_alpha == 0) {
                                    errorSnackBar(
                                        context, 'data hadir tidak ditemukan');
                                  } else {
                                    var hadir = daftar_hadir();
                                    Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (_) =>
                                              new DaftarAlpha(listAlpha)),
                                    );
                                  }
                                } else {
                                  errorSnackBar(context, 'tanggal belum diisi');
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // DaftarKehadiran()
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
