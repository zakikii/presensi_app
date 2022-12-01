import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:presensi_app/models/reset.dart';
import 'package:presensi_app/screens/change_password.dart';
import 'package:presensi_app/services/user_service.dart';
import 'package:presensi_app/widgets/sncakbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:presensi_app/models/user/user_data.dart';
// import 'package:flutter_user_profile/widgets/appbar_widget.dart';

// This class handles the Page to edit the Name Section of the User Profile.
class SendResetEmailPage extends StatefulWidget {
  const SendResetEmailPage({Key key}) : super(key: key);

  @override
  SendResetEmailPageState createState() {
    return SendResetEmailPageState();
  }
}

class SendResetEmailPageState extends State<SendResetEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final EmailController = TextEditingController();
  // final secondNameController = TextEditingController();
  var user = UserData.myUser;
  String userName = '';
  int userId = 0;
  String userEmail = '';

  @override
  void dispose() {
    EmailController.dispose();
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
    });
  }

  sendResetEmail(BuildContext context, ResetData reset) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var _userService = UserService();
    var update = await _userService.sendResetEmail(reset);
    var result = jsonDecode(update.body);
    if (result['result'] == true) {
      pref.setString('userEmail', result['user']['email']);
      // setState(() {
      //   pref.setString('userName', result['user']['name']);
      // });
      successSnackBar(context, 'email telah terkirim');
      const Duration(seconds: 2);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => ChangePasswordPage()));
    } else {
      errorSnackBar(context, 'email tidak dapat terkirim');
    }
  }

  void updateUserValue(String email) {
    user.email = email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: buildAppBar(context),
        body: Form(
      key: _formKey,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                width: 320,
                child: const Text(
                  "Lupa Password",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                )),
            Padding(
                padding: EdgeInsets.only(top: 40),
                child: SizedBox(
                    height: 100,
                    width: 320,
                    child: TextFormField(
                      // Handles Form Validation
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan email user';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Masukkan Email terkait'),
                      controller: EmailController,
                    ))),
            Padding(
                padding: EdgeInsets.only(top: 20),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 220,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState.validate() &&
                              EmailValidator.validate(EmailController.text)) {
                            updateUserValue(EmailController.text);
                          }
                          var user = ResetData();
                          // user.user_id = userId;
                          user.email = EmailController.text;
                          sendResetEmail(context, user);
                        },
                        child: const Text(
                          'Kirim kode verifikasi',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    )))
          ]),
    ));
  }
}
