import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:pinput/pinput.dart';
import 'package:presensi_app/models/pin.dart';
import 'package:presensi_app/models/presensi.dart';
import 'package:presensi_app/screens/home_screen.dart';
import 'package:presensi_app/services/presensi_service.dart';
import 'package:presensi_app/services/user_service.dart';
import 'package:presensi_app/widgets/sncakbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificationPinTidakhadir extends StatefulWidget {
  const VerificationPinTidakhadir({Key key}) : super(key: key);

  @override
  State<VerificationPinTidakhadir> createState() =>
      _VerificationPinTidakhadirState();
}

class _VerificationPinTidakhadirState extends State<VerificationPinTidakhadir> {
  int user_id = 0;
  int id_kelas = 0;
  String nama_siswa = '';
  String kehadiran = '';
  String lokasi = '';
  String path = '';
  String keterangan = '';
  String detail = '';
  bool _canCheckBiometric;
  LocalAuthentication auth = LocalAuthentication();
  List<BiometricType> _availableBiometric;
  bool authenticated = false;
  String authorized = "Not autherized";

  @override
  void initState() {
    super.initState();
    getUserData();
    _checkBiometric();
    _getAvailableBiometric();
  }

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      user_id = pref.getInt('userId');
      nama_siswa = pref.getString('userName');
      id_kelas = pref.getInt('idKelasSiswa');
      lokasi = pref.getString('lokasi');
      keterangan = pref.getString('keterangan');
      path = pref.getString('path');
      detail = pref.getString('detail');
    });
  }

  presensiHadir(BuildContext context, Presensi presensi) async {
    var _presensiService = presensiService();
    var hadir = await _presensiService.presensiHadir(presensi);
    var result = jsonDecode(hadir.body);
    if (result['result'] == true) {
      successSnackBar(context, 'data kehadiran berhasil disimpan');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomeScreen()));
      Dialogs.materialDialog(
        context: context,
        color: Colors.white,
        msg: 'Presensi anda telah berhasil disimpan.',
        title: 'Presensi Sukses',
        lottieBuilder: LottieBuilder.asset(
          'assets/lottie/success.json',
          fit: BoxFit.contain,
        ),
      );
    } else {
      errorSnackBar(context, 'data kehadiran tidak tersimpan');
    }
  }

  _checkBiometric() async {
    bool canCheckBiometric;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      errorSnackBar(context, 'Fingerprint belum dapat digunakan');
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  _getAvailableBiometric() async {
    List<BiometricType> availableBiometric;
    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      errorSnackBar(context, 'Fingerprint belum dapat digunakan');
      print(e);
    }
    setState(() {
      _availableBiometric = availableBiometric;
    });
  }

  _authenticate() async {
    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: "pindai sidik jari untuk autentikasi",
          stickyAuth: false);
    } on PlatformException catch (e) {
      errorSnackBar(context, 'Fingerprint belum dapat digunakan');
      print(e);
    }
    if (!mounted) return;
    setState(() {
      authorized =
          authenticated ? "Autherized success" : "Failed to authenticate";
      if (authenticated) {
        Map<String, String> body = {
          'id_kelas': id_kelas.toString(),
          'user_id': user_id.toString(),
          'nama_siswa': nama_siswa,
          'keterangan': keterangan,
          'detail': detail,
          'surat_bukti': '',
          'lokasi': lokasi
        };
        presensiService().addSuratKeterangan(body, path);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
        Dialogs.materialDialog(
          context: context,
          color: Colors.white,
          msg: 'Presensi anda telah berhasil disimpan.',
          title: 'Presensi Sukses',
          lottieBuilder: LottieBuilder.asset(
            'assets/lottie/success.json',
            fit: BoxFit.contain,
          ),
        );
      }
    });
  }

  checkPin(BuildContext context, pin pin) async {
    var _userService = UserService();
    var check = await _userService.checkUserPin(pin);
    var result = jsonDecode(check.body);

    if (result['result'] == true) {
      Map<String, String> body = {
        'id_kelas': id_kelas.toString(),
        'user_id': user_id.toString(),
        'nama_siswa': nama_siswa,
        'keterangan': keterangan,
        'detail': detail,
        'surat_bukti': '',
        'lokasi': lokasi
      };
      presensiService().addSuratKeterangan(body, path);
      Dialogs.materialDialog(
        context: context,
        color: Colors.white,
        msg: 'Presensi anda telah berhasil disimpan.',
        title: 'Presensi Sukses',
        lottieBuilder: LottieBuilder.asset(
          'assets/lottie/success.json',
          fit: BoxFit.contain,
        ),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } else {
      Dialogs.materialDialog(
        context: context,
        color: Colors.white,
        msg: 'Pin yang anda masukkan belum benar',
        title: 'Pin Salah',
        lottieBuilder: LottieBuilder.asset(
          'assets/lottie/wrong.json',
          fit: BoxFit.contain,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
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
      // backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.blue[900],
              Colors.blue[800],
              Colors.blue[400],
              Colors.white
            ])),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.1,
              ),
              Text(
                'Verifikasi Pin',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 32.0,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Masukkan Pin anda untuk dapat mengisi presensi',
                      style: GoogleFonts.inter(
                        fontSize: 14.0,
                        color: Colors.white54,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.1,
              ),

              /// pinput package we will use here
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: SizedBox(
                  width: width,
                  child: Pinput(
                    onCompleted: (code) {
                      var model = pin();
                      model.user_id = user_id;
                      model.user_pin = int.parse(code);
                      checkPin(context, model);
                      successSnackBar(context, 'tes');
                    },
                    length: 4,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    pinContentAlignment: Alignment.center,
                    defaultPinTheme: PinTheme(
                      height: 60.0,
                      width: 60.0,
                      textStyle: GoogleFonts.urbanist(
                        fontSize: 24.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 3.0,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent,
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      height: 60.0,
                      width: 60.0,
                      textStyle: GoogleFonts.urbanist(
                        fontSize: 24.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.blue,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 20.0,
              ),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'atau dengan menggunakan',
                    style: GoogleFonts.inter(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              InkWell(
                  onTap: _authenticate,
                  child: Text(
                    'Fingerprint',
                    style: GoogleFonts.inter(
                      fontSize: 14.0,
                      color: Colors.orange,
                      fontWeight: FontWeight.w700,
                    ),
                  )),

              /// Continue Button

              const SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
