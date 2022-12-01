import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi_app/constants/color_constant.dart';
import 'package:presensi_app/models/reset.dart';
import 'package:presensi_app/screens/profil_guru.dart';
import 'package:presensi_app/screens/profil_siswa.dart';
import 'package:presensi_app/services/user_service.dart';
import 'package:presensi_app/widgets/sncakbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';
import 'package:presensi_app/models/user/user_data.dart';
// import 'package:flutter_user_profile/widgets/appbar_widget.dart';

// This class handles the Page to edit the Name Section of the User Profile.
class EditNameFormPage extends StatefulWidget {
  const EditNameFormPage({Key key}) : super(key: key);

  @override
  EditNameFormPageState createState() {
    return EditNameFormPageState();
  }
}

class EditNameFormPageState extends State<EditNameFormPage> {
  final _formKey = GlobalKey<FormState>();
  final NameController = TextEditingController();
  // final secondNameController = TextEditingController();
  var user = UserData.myUser;
  String userName = '';
  int userId = 0;
  String userEmail = '';
  int level = 0;

  @override
  void dispose() {
    NameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getuserData();
  }
  // void updateUserValue(String name) {
  //   user.name = name;
  // }

  getuserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userName = pref.getString('userName');
      userEmail = pref.getString('userEmail');
      userId = pref.getInt('userId');
      level = pref.getInt('userLevel');
    });
  }

  updateUserName(BuildContext context, ResetData user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var _userService = UserService();
    var update = await _userService.updateUserName(user);
    var result = jsonDecode(update.body);
    if (result['result'] == true) {
      setState(() {
        pref.setString('userName', result['user']['name']);
      });
      successSnackBar(context, 'berhasil mengubah username');
      const Duration(seconds: 2);
      Navigator.pop(context);
    } else {
      errorSnackBar(context, 'tidak dapat mengubah password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [Colors.blue[900], Colors.blue[800], Colors.blue[400]]),
        ),
      ),
      Scaffold(
          appBar: new AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            actions: [],
            // foregroundColor: Colors.black,
            textTheme:
                const TextTheme(bodyText2: TextStyle(color: Colors.black)),
            leading: GestureDetector(
              child: Icon(Icons.arrow_back_ios, color: Colors.white),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
          ),
          backgroundColor: Colors.transparent,
          body: Stack(fit: StackFit.expand, children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                  Colors.blue[900],
                  Colors.blue[800],
                  Colors.blue[400]
                ]),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 230,
                    width: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Ubah Nama',
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: kBlackColor,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Divider(
                            thickness: 2.5,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 300,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: TextFormField(
                                          // Handles Form Validation for First Name
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'nama belum dimasukkan';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              labelText: 'Nama Lengkap'),
                                          controller: NameController,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      SizedBox(
                                        width: 100,
                                        height: 40,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Validate returns true if the form is valid, or false otherwise.
                                            if (_formKey.currentState
                                                .validate()) {
                                              var user = ResetData();
                                              user.user_id = userId;
                                              user.user_name =
                                                  NameController.text;
                                              updateUserName(context, user);
                                            }
                                          },
                                          child: const Text(
                                            'Update',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'pastikan nama yang anda masukkan\nsudah benar dan tepat.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: kWhiteColor,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ]))
    ]);
  }
}
