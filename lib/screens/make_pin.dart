import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:pinput/pinput.dart';
import 'package:presensi_app/models/pin.dart';
import 'package:presensi_app/models/presensi.dart';
import 'package:presensi_app/screens/home_screen.dart';
import 'package:presensi_app/services/presensi_service.dart';
import 'package:presensi_app/services/user_service.dart';
import 'package:presensi_app/widgets/sncakbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MakePin extends StatefulWidget {
  const MakePin({Key key}) : super(key: key);

  @override
  State<MakePin> createState() => _MakePinState();
}

class _MakePinState extends State<MakePin> {
  int user_id = 0;
  int id_kelas = 0;
  String nama_siswa = '';
  String kehadiran = '';
  String lokasi = '';

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      user_id = pref.getInt('userId');
      nama_siswa = pref.getString('userName');
      id_kelas = pref.getInt('idKelasSiswa');
      lokasi = pref.getString('lokasi');
    });
  }

  setUserPin(BuildContext context, pin _pin) async {
    var _userService = UserService();
    var set = await _userService.setUserPin(_pin);
    var result = jsonDecode(set.body);

    if (result['result'] == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomeScreen()));
      Dialogs.materialDialog(
        context: context,
        color: Colors.white,
        msg: 'Jangan Kasih tau pin kamu ke siapapun ya :)',
        title: 'Pin Disimpan',
        lottieBuilder: LottieBuilder.asset(
          'assets/lottie/success.json',
          fit: BoxFit.contain,
        ),
      );
    } else {}
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
                'Buat Pin',
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
                      var user_pin = new pin();
                      user_pin.user_id = user_id;
                      user_pin.user_pin = int.parse(code);
                      setUserPin(context, user_pin);
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
                    'Jangan kasih tau pin pada siapapun yaa.',
                    style: GoogleFonts.inter(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

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
