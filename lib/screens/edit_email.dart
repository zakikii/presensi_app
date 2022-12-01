import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi_app/constants/color_constant.dart';
import 'package:presensi_app/models/reset.dart';
import 'package:presensi_app/models/user/user_data.dart';
// import 'package:flutter_user_profile/widgets/appbar_widget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:presensi_app/screens/profil_guru.dart';
import 'package:presensi_app/screens/profil_siswa.dart';
import 'package:presensi_app/services/user_service.dart';
import 'package:presensi_app/widgets/sncakbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This class handles the Page to edit the Email Section of the User Profile.
class EditEmailFormPage extends StatefulWidget {
  const EditEmailFormPage({Key key}) : super(key: key);

  @override
  EditEmailFormPageState createState() {
    return EditEmailFormPageState();
  }
}

class EditEmailFormPageState extends State<EditEmailFormPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  var user = UserData.myUser;
  String userName = '';
  int userId = 0;
  String userEmail = '';
  int level = 0;

  @override
  void initState() {
    super.initState();
    getuserData();
  }

  getuserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userName = pref.getString('userName');
      userEmail = pref.getString('userEmail');
      userId = pref.getInt('userId');
      level = pref.getInt('userLevel');
    });
  }

  updateUserEmail(BuildContext context, ResetData user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var _userService = UserService();
    var update = await _userService.updateUserEmail(user);
    var result = jsonDecode(update.body);
    if (result['result'] == true) {
      setState(() {
        pref.setString('userName', result['user']['email']);
      });
      successSnackBar(context, 'berhasil mengubah email');
      const Duration(seconds: 2);
      if (level == 1) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ProfilSiswa()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ProfilGuru()));
      }
    } else {
      errorSnackBar(context, 'tidak dapat mengubah email');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void updateUserValue(String email) {
    user.email = email;
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
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
                    height: 220,
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
                            'Ganti Email',
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
                                              return 'Masukkan email anda';
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                              labelText: 'alamat email anda'),
                                          controller: emailController,
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
                                                    .validate() &&
                                                EmailValidator.validate(
                                                    emailController.text)) {
                                              updateUserValue(
                                                  emailController.text);
                                              var user = ResetData();
                                              user.user_id = userId;
                                              user.email = emailController.text;
                                              updateUserEmail(context, user);
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
                    'pastikan email yang anda masukkan\nsudah benar dan tepat.',
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

//     return Scaffold(
//         // appBar: buildAppBar(context),
//         body: Form(
//       key: _formKey,
//       child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             SizedBox(
//                 width: 320,
//                 child: const Text(
//                   "What's your email?",
//                   style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.left,
//                 )),
//             Padding(
//                 padding: EdgeInsets.only(top: 40),
//                 child: SizedBox(
//                     height: 100,
//                     width: 320,
//                     child: TextFormField(
//                       // Handles Form Validation
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your email.';
//                         }
//                         return null;
//                       },
//                       decoration: const InputDecoration(
//                           labelText: 'Your email address'),
//                       controller: emailController,
//                     ))),
//             Padding(
//                 padding: EdgeInsets.only(top: 150),
//                 child: Align(
//                     alignment: Alignment.bottomCenter,
//                     child: SizedBox(
//                       width: 320,
//                       height: 50,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           // Validate returns true if the form is valid, or false otherwise.
//                           if (_formKey.currentState.validate() &&
//                               EmailValidator.validate(emailController.text)) {
//                             updateUserValue(emailController.text);
//                           }
//                           var user = ResetData();
//                           user.user_id = userId;
//                           user.email = emailController.text;
//                           updateUserEmail(context, user);
//                         },
//                         child: const Text(
//                           'Update',
//                           style: TextStyle(fontSize: 15),
//                         ),
//                       ),
//                     )))
//           ]),
//     ));
//   }
// }
