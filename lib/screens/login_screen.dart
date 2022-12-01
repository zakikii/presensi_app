import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:presensi_app/constants/color_constant.dart';
import 'package:presensi_app/models/kelas.dart';
import 'package:presensi_app/models/user.dart';
import 'package:presensi_app/screens/enter_class.dart';
import 'package:presensi_app/screens/home_guru_screen.dart';
import 'package:presensi_app/screens/home_screen.dart';
import 'package:presensi_app/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:presensi_app/screens/send_reset_email.dart';
import 'package:presensi_app/services/kelas_service.dart';
import 'package:presensi_app/services/user_service.dart';
import 'package:presensi_app/widgets/sncakbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  String pass = '';
  int idKelas = 0;
  final _formKey = GlobalKey<FormState>();
  String deviceId = '';
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    getIdDevice();
  }

  getIdDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    setState(() {
      deviceId = androidInfo.id.toString();
    });
  }

  _getDataKelas(BuildContext context, Kelas kelas) async {
    print('tes');
    var _kelasService = kelasService();
    var dataKelas = await _kelasService.getDataKelas(kelas);
    var result = jsonDecode(dataKelas.body);

    // if (result['result'] == true) {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('idKelas', result['data']['id']);
    pref.setString('namaGuru', result['nama_guru']);
    pref.setString('namaKelas', result['data']['nama_kelas']);
    pref.setInt('status', result['data']['status']);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => HomeScreen()));
  }

  _login(BuildContext context, User user) async {
    var _userService = UserService();
    var registeredUser = await _userService.login(user);
    var result = jsonDecode(registeredUser.body);
    // print(result['user']['level']);
    print(result['result']);
    if (result['result'] == true) {
      print(result['user']['level']);
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setInt('userId', result['user']['id']);
      _prefs.setString('userName', result['user']['name']);
      _prefs.setString('userEmail', result['user']['email']);
      _prefs.setInt('userLevel', result['user']['level']);
      _prefs.setInt('idKelasSiswa', result['user']['id_kelas']);
      _prefs.setString('pass', pass);
      if (_prefs.getInt('userLevel') == 1) {
        if (_prefs.getInt('idKelasSiswa') == 0) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => EnterClassScreen()));
        } else {
          var kelas = Kelas();
          kelas.id = _prefs.getInt('idKelasSiswa');
          print('tes');
          _getDataKelas(context, kelas);
        }
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeGuruScreen()));
      }
    } else if (result['result'] == false) {
      Dialogs.materialDialog(
        context: context,
        color: Colors.white,
        msg: 'email atau password salah',
        title: 'Tidak Bisa Login',
        lottieBuilder: LottieBuilder.asset(
          'assets/lottie/wrong.json',
          fit: BoxFit.contain,
        ),
      );
    } else {
      if (result['result'] == 'on another device') {
        Dialogs.materialDialog(
          context: context,
          color: Colors.white,
          msg: 'Akun terdeteksi login pada perangkat lain',
          title: 'Tidak Bisa Login',
          lottieBuilder: LottieBuilder.asset(
            'assets/lottie/phone.json',
            fit: BoxFit.contain,
          ),
        );
      } else if (result['result'] == 'wait for 3 days') {
        Dialogs.materialDialog(
          context: context,
          color: Colors.white,
          msg: 'tunggu 3 hari lagi baru bisa login',
          title: 'Tidak Bisa Login',
          lottieBuilder: LottieBuilder.asset(
            'assets/lottie/under-construction.json',
            fit: BoxFit.contain,
          ),
        );
      } else {}
    }
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.blue[50],
    primary: Colors.blue,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
  );

  @override
  Widget build(BuildContext context) {
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
          children: <Widget>[
            SizedBox(height: 80),
            Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "E - Presensi",
                    style: GoogleFonts.inter(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: kWhiteColor),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "bikin presensimu lebih mudah.",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: ListView(
                      children: <Widget>[
                        Column(children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(
                                left: 48.0,
                                top: 14.0,
                                right: 48.0,
                                bottom: 14.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Masukkan email anda';
                                }
                                return null;
                              },
                              controller: email,
                              decoration: InputDecoration(
                                  hintText: 'youremail@example.com',
                                  labelText: 'Masukkan Email'),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 48.0,
                                top: 14.0,
                                right: 48.0,
                                bottom: 14.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Masukkan Password';
                                }
                                return null;
                              },
                              obscureText: _isObscure,
                              controller: password,
                              decoration: InputDecoration(
                                hintText: 'Enter your password',
                                labelText: '******',
                                suffixIcon: IconButton(
                                  icon: Icon(_isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ]),
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: Column(
                            children: <Widget>[
                              ButtonTheme(
                                minWidth: 150,
                                height: 55.0,
                                child: ElevatedButton(
                                  style: raisedButtonStyle,
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      var user = User();
                                      user.email = email.text;
                                      user.password = password.text;
                                      pass = password.text;
                                      user.device_id = deviceId;
                                      _login(context, user);
                                    }
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text('atau'),
                              SizedBox(height: 10),
                              // Text('belum punya akun'),
                              ButtonTheme(
                                minWidth: 150,
                                height: 55.0,
                                child: ElevatedButton(
                                  style: raisedButtonStyle,
                                  // focusColor: Colors.blue[50],
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius:
                                  //         BorderRadius.circular(15.0)),
                                  // color: Colors.blue,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegistrationScreen()));
                                  },
                                  child: FittedBox(
                                      child: Text(
                                    'register',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )),
                                ),
                              ),
                              SizedBox(height: 40),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('lupa password ?'),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    SendResetEmailPage()));
                                      },
                                      child: Text('reset disini')),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
