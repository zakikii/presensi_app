import 'dart:convert';

import 'package:custom_pin_screen/custom_pin_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:presensi_app/constants/color_constant.dart';
import 'package:presensi_app/models/kelas.dart';
import 'package:presensi_app/models/pin.dart';
import 'package:presensi_app/models/user.dart';
import 'package:presensi_app/screens/home_screen.dart';
import 'package:presensi_app/screens/login_screen.dart';
import 'package:presensi_app/screens/make_pin.dart';
import 'package:presensi_app/services/kelas_service.dart';
import 'package:presensi_app/services/user_service.dart';

import 'package:presensi_app/widgets/sncakbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnterClassScreen extends StatefulWidget {
  @override
  _EnterClassScreenState createState() => _EnterClassScreenState();
}

class _EnterClassScreenState extends State<EnterClassScreen> {
  final kodeKelas = TextEditingController();
  String idSiswa = '';
  int user_id = 0;
  String nama_siswa = '';

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      user_id = pref.getInt('userId');
      nama_siswa = pref.getString('userName');
      // id_kelas = pref.getInt('idKelasSiswa');
      // lokasi = controller.address.value;
    });
  }

  _getDataKelas(BuildContext context, Kelas kelas) async {
    var _kelasService = kelasService();
    var dataKelas = await _kelasService.getDataKelas(kelas);
    var result = jsonDecode(dataKelas.body);

    if (result['result'] == true) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('namaKelas', result['data']['nama_kelas']);
      pref.setInt('idKelas', result['data']['id']);
      pref.setString('namaGuru', result['nama_guru']);
      pref.setString('namaKelas', result['data']['nama_kelas']);
      pref.setInt('status', result['data']['status']);
      var _pin = pin();
      _pin.user_id = user_id;
      checkAvailablePin(context, _pin);
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => HomeApp()));
    }
  }

  _cheklogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      idSiswa = pref.getInt('idKelasSiswa').toString();
    });
    if (idSiswa == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } else {
      errorSnackBar(context, 'kamu belum terdaftar');
    }
  }

  _enterClass(BuildContext context, User user) async {
    var _userService = UserService();
    var loginUser = await _userService.enterClass(user);
    var result = jsonDecode(loginUser.body);
    if (result['result'] == true) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setInt('idKelasSiswa', result['user']['id_kelas']);
      setState(() {
        idKelas = pref.getInt('idKelasSiswa');
      });
      successSnackBar(context, 'sukses terdaftar dalam kelas');
    } else {
      errorSnackBar(context, 'gagal terdaftar');
    }
  }

  String pass = '';
  String userEmail = '';
  int idKelas = 0;

  getUserEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userEmail = pref.getString('userEmail');
    });
  }

  getUserPass() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pass = pref.getString('pass');
    });
  }

  setUserPin(BuildContext context, pin _pin) async {
    var _userService = UserService();
    var set = await _userService.setUserPin(_pin);
    var result = jsonDecode(set.body);

    if (result['result'] == true) {
      successSnackBar(context, 'pin berhasil disimpan');
      var model = pin();
      model.user_id = user_id;
      checkAvailablePin(context, model);
    }
  }

  checkAvailablePin(BuildContext context, pin _pin) async {
    var _userService = UserService();
    var check = await _userService.checkAvailablePin(_pin);
    var result = jsonDecode(check.body);

    if (result['result'] == true) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => MakePin()));
    }
  }

  @override
  void initState() {
    getUserEmail();
    getUserPass();
    _cheklogin();
    getUserData();
  }

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.redAccent,

    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    // color: Colors.redAccent,
  );

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: currentWidth,
          height: currentHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blue[900], Colors.blue[400], Colors.blue[200]],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: currentWidth / 2.9,
                height: currentHeight / 11,
                child: Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    "E Presensi",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: mainColor,
                        fontSize: 23,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 50),
                  child: Container(
                    width: currentWidth,
                    height: currentHeight / 3.5,
                    child: Image(
                      image: AssetImage('assets/images/bag.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Expanded(child: SizedBox()),
              Expanded(
                child: Container(
                    width: currentWidth,
                    height: currentHeight / 2.2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                        color: mainColor),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: ListView(children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30.0, right: 30.0, bottom: 50.0),
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Daftar Kelas dulu baru bisa masuk :)",
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20),
                                TextField(
                                  controller: kodeKelas,
                                  decoration: InputDecoration(
                                      hintText: 'your class code',
                                      labelText: 'Masukkan Kode Kelas'),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ButtonTheme(
                                  minWidth: 320,
                                  height: 45.0,
                                  child: TextButton(
                                    style: flatButtonStyle,
                                    onPressed: () {
                                      var user = User();
                                      var kelas = Kelas();
                                      user.email = userEmail;
                                      user.password = pass;
                                      user.kode_kelas = kodeKelas.text;
                                      _enterClass(context, user);
                                      kelas.id = idKelas;
                                      _getDataKelas(context, kelas);
                                    },
                                    child: Text(
                                      idKelas == 0
                                          ? 'masuk kelas'
                                          : 'kuy, isi presensi !',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()));
                                  },
                                  child: FittedBox(
                                      child:
                                          Text('Login with different account')),
                                ),
                              ],
                            ),
                          ),
                        )
                      ]),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
