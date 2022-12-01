import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:presensi_app/constants/color_constant.dart';
import 'package:presensi_app/models/user.dart';
import 'package:presensi_app/screens/enter_class.dart';
import 'package:presensi_app/screens/home_guru_screen.dart';
import 'package:presensi_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:presensi_app/services/user_service.dart';
import 'package:presensi_app/widgets/sncakbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LevelUser { siswa, guru }

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  String pass = '';
  int current = 0;
  int level;
  LevelUser _levelUser = LevelUser.siswa;
  final _formKey = GlobalKey<FormState>();

  // Handle Indicator
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    level = 1;
  }

  _register(BuildContext context, User user) async {
    var _userService = UserService();
    var registeredUser = await _userService.createUser(user);
    var result = jsonDecode(registeredUser.body);
    if (result['result'] == true) {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setInt('userId', result['user']['id']);
      _prefs.setString('userName', result['user']['name']);
      _prefs.setString('userEmail', result['user']['email']);
      _prefs.setInt('level', result['user']['level']);
      // _prefs.setInt('idKelasSiswa', result['user']['id_kelas']);
      _prefs.setString('pass', pass);
      successSnackBar(context, 'Selamat datang' + ' ' + result['user']['name']);
      if (result['user']['level'] == 2) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeGuruScreen()));
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EnterClassScreen()));
      }
    } else {
      Dialogs.materialDialog(
        context: context,
        color: Colors.white,
        msg: 'Email telah terdaftar',
        title: 'Email Terpakai',
        lottieBuilder: LottieBuilder.asset(
          'assets/lottie/wrong.json',
          fit: BoxFit.contain,
        ),
      );
    }
  }

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.blue,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    // overla
    // padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                    "Register",
                    style: GoogleFonts.inter(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: kWhiteColor),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Lets start the journey.",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Form(
                key: _formKey,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      )),
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
                                  return 'Masukkan nama anda';
                                }
                              },
                              controller: name,
                              decoration: InputDecoration(
                                  hintText: 'Alwan Zaki',
                                  labelText: 'Masukkan Nama'),
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
                                  return 'Masukkan nama anda';
                                }
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sebagai :',
                                  style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: kBlackColor),
                                ),
                                ListTile(
                                  title: const Text('Siswa'),
                                  leading: Radio<LevelUser>(
                                    value: LevelUser.siswa,
                                    groupValue: _levelUser,
                                    onChanged: (LevelUser value) {
                                      setState(() {
                                        _levelUser = value;
                                        level = 1;
                                      });
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: const Text('Guru'),
                                  leading: Radio<LevelUser>(
                                    value: LevelUser.guru,
                                    groupValue: _levelUser,
                                    onChanged: (LevelUser value) {
                                      setState(() {
                                        _levelUser = value;
                                        level = 2;
                                      });
                                    },
                                  ),
                                )
                              ],
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
                                  return 'masukkan password';
                                }
                              },
                              controller: password,
                              decoration: InputDecoration(
                                  hintText: '******',
                                  labelText: 'Enter your password'),
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
                                child: TextButton(
                                  style: flatButtonStyle,
                                  // style: ButtonStyle(
                                  //   overlayColor: Colors.blue
                                  // ),
                                  // focusColor: Colors.blue[50],
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      var user = User();
                                      user.name = name.text;
                                      user.email = email.text;
                                      user.level = level;
                                      user.password = password.text;
                                      pass = password.text;
                                      _register(context, user);
                                    }
                                  },
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                            child: FittedBox(child: Text('Log in')),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 65.0, right: 65.0, bottom: 14.0),
                          child: Text(
                            'By signing up you accept the Terms of Service and Privacy Policy',
                            textAlign: TextAlign.center,
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
