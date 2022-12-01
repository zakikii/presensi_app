import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:presensi_app/constants/color_constant.dart';
import 'package:presensi_app/models/ketidakhadiran.dart';
import 'package:presensi_app/models/pin.dart';
import 'package:presensi_app/models/presensi.dart';
import 'package:presensi_app/screens/home_screen.dart';
import 'package:presensi_app/screens/verification_pin_hadir.dart';
import 'package:presensi_app/screens/verification_pin_tidakhadir.dart';
import 'package:presensi_app/services/presensi_service.dart';
import 'package:presensi_app/services/user_service.dart';
import 'package:presensi_app/widgets/sncakbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:presensi_app/services/location_controller.dart';
import 'package:presensi_app/widgets/constants.dart';
import 'package:custom_pin_screen/custom_pin_screen.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'dart:math';

class PresensiScreen extends StatefulWidget {
  @override
  State<PresensiScreen> createState() => _PresensiScreenState();
}

class _PresensiScreenState extends State<PresensiScreen> {
  final controller = Get.put(LocationController());
  String lokasi = '';
  String _chosenValue;
  String keterangan;
  bool cekhadir = false;
  bool cektdkhadir = false;
  int user_id = 0;
  int id_kelas = 0;
  String nama_siswa = '';
  String kehadiran = '';
  LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometric;
  List<BiometricType> _availableBiometric;
  String authorized = "Not autherized";
  bool authenticated = false;
  bool hadir = false;
  final detail = TextEditingController();
  Service service = Service();
  final _addFormKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  File _image;
  final picker = ImagePicker();
  double lat1 = -4.3622316;
  double long1 = 104.3532345;
  double jarak = 0.0;
  // final _formKey = GlobalKey<FormState>();

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      user_id = pref.getInt('userId');
      nama_siswa = pref.getString('userName');
      id_kelas = pref.getInt('idKelasSiswa');
      // lokasi = controller.address.value;
    });
  }


  // ambil jarak
  getDistance() {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((double.parse(controller.latitude.value) - lat1) * p) / 2 +
        cos(lat1 * p) *
            cos(double.parse(controller.latitude.value) * p) *
            (1 - cos((double.parse(controller.longitude.value) - long1) * p)) /
            2;

    var distance = 12742 * asin(sqrt(a));
    print(distance);
    setState(() {
      jarak = distance;
    });
  }

  saveLocation() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setString('lokasi', controller.address.value);
      lokasi = pref.getString('lokasi');
    });
  }

  Future getSuratIzin() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        dangerSnackBar(context, 'tidak ada gambar yang dipilih');
      }
    });
  }

  Widget buildImage() {
    if (_image == null) {
      return Padding(
        padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
        child: Icon(Icons.add, color: Colors.grey),
      );
    } else {
      return Text(_image.path);
    }
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

  presensiTidakHadir(
      BuildContext context, KetidakHadiran ketidakHadiran) async {
    var _presensiService = presensiService();
    var tidakHadir = await _presensiService.tidakHadir(ketidakHadiran);
    var result = jsonDecode(tidakHadir.body);
    if (result['result'] == true) {
      successSnackBar(context, 'data ketidakberangkatan berhasil tersimpan');
    } else {
      errorSnackBar(context, 'data tidak tersimpan');
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
        if (hadir == true) {
          var presensi = Presensi();
          presensi.id_kelas = id_kelas;
          presensi.user_id = user_id;
          presensi.nama_siswa = nama_siswa;
          presensi.lokasi = controller.address.value;
          presensiHadir(context, presensi);
        } else {
          Map<String, String> body = {
            'id_kelas': id_kelas.toString(),
            'user_id': user_id.toString(),
            'nama_siswa': nama_siswa,
            'keterangan': keterangan,
            'detail': detail.text,
            'surat_bukti': '',
            'lokasi': controller.address.value
          };
          presensiService().addSuratKeterangan(body, _image.path);
          successSnackBar(context, 'data kehadiran berhasil disimpan');
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
          Widget confirmButton = TextButton(
            child: Text("ashiap"),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          );
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
      }
    });
  }

  checkPin(BuildContext context, pin pin) async {
    var _userService = UserService();
    var check = await _userService.checkUserPin(pin);
    var result = jsonDecode(check.body);

    if (result['result'] == true) {
      successSnackBar(context, 'pin benar');
      if (hadir == true) {
        var presensi = Presensi();
        presensi.id_kelas = id_kelas;
        presensi.user_id = user_id;
        presensi.nama_siswa = nama_siswa;
        presensi.lokasi = controller.address.value;
        presensiHadir(context, presensi);
      } else {
        Map<String, String> body = {
          'id_kelas': id_kelas.toString(),
          'user_id': user_id.toString(),
          'nama_siswa': nama_siswa,
          'keterangan': keterangan,
          'detail': detail.text,
          'surat_bukti': '',
          'lokasi': controller.address.value
        };
        presensiService().addSuratKeterangan(body, _image.path);
        successSnackBar(context, 'data kehadiran berhasil disimpan');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
        Widget confirmButton = TextButton(
          child: Text("ashiap"),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        );
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
    } else {
      errorSnackBar(context, 'pin salah, silahkan coba lagi');
    }
  }

  checkAvailblePin(BuildContext context, pin _pin) async {
    saveLocation();
    SharedPreferences pref = await SharedPreferences.getInstance();
    var _userService = UserService();
    var check = await _userService.checkAvailablePin(_pin);
    var result = jsonDecode(check.body);

    if (result['result'] == true) {
      if (hadir == false) {
        if (_image == null) {
          Dialogs.materialDialog(
            context: context,
            color: Colors.white,
            // msg:
            title: 'Surat sakit atau izin belum dipilih',
            lottieBuilder: LottieBuilder.asset(
              'assets/lottie/wrong.json',
              fit: BoxFit.contain,
            ),
          );
        } else {
          pref.setString('keterangan', keterangan);
          pref.setString('detail', detail.text);
          pref.setString('lokasi', controller.address.value);
          pref.setString('path', _image.path);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => VerificationPinTidakhadir()),
          );
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => VerificationPinHadir()),
        );
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PinAuthentication(
            action: 'Buat Pin Baru',
            onChanged: (s) {
              if (kDebugMode) {
                print(s);
              }
            },
            onCompleted: (v) {
              if (kDebugMode) {
                successSnackBar(context, 'penuh');
                var model = pin();
                model.user_id = user_id;
                model.user_pin = int.parse(v);
                setUserPin(context, model);
              }
            },
            onSpecialKeyTap: () {
              hadir = true;
              _authenticate();
            },
            specialKey: const SizedBox(),
            useFingerprint: true,
            onbuttonClick: () {
              // successSnackBar(context, print(v))
            },
            submitLabel: const Text(
              'Submit',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      );
    }
  }

  setUserPin(BuildContext context, pin _pin) async {
    var _userService = UserService();
    var set = await _userService.setUserPin(_pin);
    var result = jsonDecode(set.body);

    if (result['result'] == true) {
      successSnackBar(context, 'pin berhasil disimpan');
      var model = pin();
      model.user_id = user_id;
      checkAvailblePin(context, model);
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    _checkBiometric();
    _getAvailableBiometric();
    saveLocation();
  }

  Widget buildPinPut() {
    return Pinput(
      onCompleted: (pin) => print(pin),
    );
  }

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    //  onPrimary: Colors.blue[50],
    primary: Colors.blue,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
  );

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
                    'Isi Presensi.',
                    style: GoogleFonts.inter(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "hadir atau ngga ya hari ini ?",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  // Image.asset('assets/images/student.png')
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
                  // padding: EdgeInsets.all(5),
                  padding: EdgeInsets.all(20),
                  child: ListView(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 48.0, right: 48.0, bottom: 14.0),
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton<String>(
                          value: _chosenValue,
                          isExpanded: true,
                          // elevation: 5,
                          style: TextStyle(color: Colors.black),
                          items: <String>['Hadir', 'Tidak Hadir']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: kBlackColor),
                              ),
                            );
                          }).toList(),
                          hint: Text(
                            'Hadir atau tidak hadir',
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: kBlackColor),
                          ),
                          onChanged: (String value) {
                            if (value == 'Hadir') {
                              cekhadir = true;
                              cektdkhadir = false;
                            } else if (value == 'Tidak Hadir') {
                              cektdkhadir = true;
                              cekhadir = false;
                            }
                            setState(() {
                              _chosenValue = value;
                            });
                          },
                        ),
                      ),
                    ),
                    if (cekhadir) Hadir(),
                    if (cektdkhadir) tidakHadir()
                  ])),
            ))
          ],
        ),
      ),
    );
  }

  Container Hadir() {
    return Container(
        child: Padding(
      padding: EdgeInsets.symmetric(vertical: defaultPadding),
      child: Container(
        padding: const EdgeInsets.only(left: 48.0, right: 48.0, bottom: 14.0),
        child: Column(children: [
          Text(
            'lokasi :',
            style: GoogleFonts.inter(
                fontSize: 14, fontWeight: FontWeight.w700, color: kBlackColor),
            textAlign: TextAlign.center,
          ),
          Obx(
            () => Text(
              controller.address.value,
              textAlign: TextAlign.start,
              style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: kBlackColor),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ButtonTheme(
            minWidth: 250,
            height: 45.0,
            child: TextButton(
              style: flatButtonStyle,
              onPressed: () {
                if (controller.address.value == 'Mendapatkan Lokasi..') {
                  Dialogs.materialDialog(
                    context: context,
                    color: Colors.white,
                    msg: 'tunggu sebentar, sedang mendapatkan lokasi',
                    title: 'Lokasi belum ditemukan',
                    lottieBuilder: LottieBuilder.asset(
                      'assets/lottie/under-construction.json',
                      fit: BoxFit.contain,
                    ),
                    actions: [
                      IconsButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        text: 'tutup',
                        // color: Colors.blue,
                        textStyle: TextStyle(color: Colors.grey),
                        iconColor: Colors.grey,
                      ),
                    ],
                  );
                } else {
                  hadir = true;
                  var _pin = new pin();
                  _pin.user_id = user_id;
                  getDistance();
                  if (jarak >= 2.00) {
                    Dialogs.materialDialog(
                      context: context,
                      color: Colors.white,
                      msg: 'lokasi anda terlalu jauh',
                      title: 'tidak dapat presensi',
                      lottieBuilder: LottieBuilder.asset(
                        'assets/lottie/wrong.json',
                        fit: BoxFit.contain,
                      ),
                    );
                  } else {
                    checkAvailblePin(context, _pin);
                  }
                }
              },
              child: Text(
                'isi presensi',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
        ]),
      ),
    ));
  }

  Container tidakHadir() {
    return Container(
        child: Padding(
      padding: EdgeInsets.symmetric(vertical: defaultPadding),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 48.0, right: 48.0, bottom: 14.0),
          child: Form(
            key: _addFormKey,
            child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'lokasi :',
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: kBlackColor),
                    textAlign: TextAlign.center,
                  ),
                  Obx(
                    () => Text(
                      controller.address.value,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: kBlackColor),
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    // isExpanded: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'keterangan belum dipilih !';
                      }
                      return null;
                    },
                    value: keterangan,
                    style: TextStyle(color: Colors.black),
                    items: <String>['sakit', 'izin']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: kBlackColor),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      'sakit atau izin                                    ',
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: kBlackColor),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        keterangan = value;
                      });
                    },
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'detail belum diinput !';
                      }
                      return null;
                    },
                    controller: detail,
                    decoration: InputDecoration(
                        hintText: '.....',
                        labelText: 'Detail dari sakit atau izin'),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: OutlinedButton(
                      onPressed: getSuratIzin,
                      child: buildImage(),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ButtonTheme(
                    minWidth: 250,
                    height: 45.0,
                    child: TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        if (_addFormKey.currentState.validate()) {
                          if (controller.address.value ==
                              'Mendapatkan Lokasi..') {
                            Dialogs.materialDialog(
                              context: context,
                              color: Colors.white,
                              msg: 'tunggu sebentar, sedang mendapatkan lokasi',
                              title: 'Lokasi belum ditemukan',
                              lottieBuilder: LottieBuilder.asset(
                                'assets/lottie/under-construction.json',
                                fit: BoxFit.contain,
                              ),
                              actions: [
                                IconsButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  text: 'tutup',
                                  // color: Colors.blue,
                                  textStyle: TextStyle(color: Colors.grey),
                                  iconColor: Colors.grey,
                                ),
                              ],
                            );
                          } else {
                            hadir = false;
                            var _pin = pin();
                            _pin.user_id = user_id;
                            checkAvailblePin(context, _pin);
                          }
                        }
                      },
                      child: Text(
                        'isi presensi',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    ));
  }
}
