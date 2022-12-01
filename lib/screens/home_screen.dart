import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi_app/constants/color_constant.dart';
import 'package:presensi_app/models/cek_presensi.dart';
import 'package:presensi_app/models/daftar_presensi_siswa.dart';
import 'package:presensi_app/models/operation_model.dart';
import 'package:presensi_app/models/user.dart';
import 'package:presensi_app/screens/daftar_presensi_siswa.dart';
import 'package:presensi_app/screens/login_screen.dart';
import 'package:presensi_app/screens/presensi_screen.dart';
import 'package:presensi_app/services/presensi_service.dart';
import 'package:presensi_app/services/slider_service.dart';
import 'package:presensi_app/services/user_service.dart';
import 'package:presensi_app/widgets/navbar_siswa.dart';
import 'package:presensi_app/widgets/sncakbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SliderService _sliderService = SliderService();
  var item = [];
  String userName = '';
  String userKelas = '';
  int userId = 0;
  int status = null;
  String userEmail = '';
  String userStatus = '';
  List<daftar_presensi_siswa> _presensi = List<daftar_presensi_siswa>();
  DateTime currentBackPressTime;

  @override
  void initState() {
    super.initState();
    _getAllSliders();
    getuserData();
    _isiPresensi();
  }

  getuserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userName = pref.getString('userName');
      userKelas = pref.getString('namaKelas');
      userEmail = pref.getString('userEmail');
      userId = pref.getInt('userId');
      status = pref.getInt('status');
      if (status == 1) {
        userStatus = 'siswa';
      } else {
        userStatus = 'guru';
      }
    });
  }

  Future logOut(BuildContext context, User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();

    var userservice = UserService();
    var logout = await userservice.logout(user);
    var result = jsonDecode(logout.body);
    print(result);
    if (result['result'] == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  _getAllSliders() async {
    var sliders = await _sliderService.getSliders();
    var result = jsonDecode(sliders.body);
    result['data'].forEach((data) {
      setState(() {
        item.add(NetworkImage(data['gambar_slider']));
      });
    });
    print(result);
  }

  _cekPresensi(BuildContext context, CekPresensi presensi) async {
    var _cekhadir = presensiService();
    var cek = await _cekhadir.cekPresensi(presensi);
    var result = jsonDecode(cek.body);
    if (result['result'] == true) {
      successSnackBar(context, 'kamu bisa mengisi presensi :)');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PresensiScreen()));
    } else {
      Dialogs.materialDialog(
        context: context,
        color: Colors.white,
        msg: 'Kamu telah mengisi presensi.',
        title: 'Sudah Presensi',
        lottieBuilder: LottieBuilder.asset(
          'assets/lottie/success.json',
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
    }
  }

  _isiPresensi() {
    if (current == 1) {
      successSnackBar(context, 'tes');
    }
  }

  getDataPresensi(BuildContext context, daftar_presensi_siswa presensi) async {
    _presensi.clear();
    var _presensiService = presensiService();
    var daftarPresensi = await _presensiService.daftarPresensiSiswa(presensi);
    var result = json.decode(daftarPresensi.body);
    if (result['result'] == true) {
      result['presensi'].forEach((hadir) {
        var presensi = daftar_presensi_siswa();
        presensi.keterangan = hadir['keterangan'];
        presensi.tanggal = hadir['created_at'];
        presensi.lokasi = hadir['lokasi'];
        presensi.url = hadir['surat_bukti_url'];
        setState(() {
          _presensi.add(presensi);
        });
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DaftarPresensiSiswaScreen(_presensi)));
    }
  }

  // Current selected
  int current = 0;

  // Handle Indicator
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'tap sekali lagi untuk keluar');
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: mainColor,
        appBar: new AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          actions: [],
          textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.black)),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                icon: Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
              );
            },
          ),
          centerTitle: true,
        ),
        drawer: NavBarSiswa(userName, userStatus),
        body: SafeArea(
          child: Container(
            // margin: EdgeInsets.only(top: 8),
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16, top: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        // height: 59,
                        width: 59,
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(20),
                        //   image: DecorationImage(
                        //     image: AssetImage('assets/images/user.png'),
                        //   ),
                        // ),
                      ),
                      GestureDetector(
                          onTap: () {
                            Dialogs.materialDialog(
                              context: context,
                              color: Colors.white,
                              msg: 'Apakah kamu yakin ingin Logout ?',
                              title: 'Logout',
                              lottieBuilder: LottieBuilder.asset(
                                'assets/lottie/keluar-kelas.json',
                                fit: BoxFit.contain,
                              ),
                              actions: [
                                IconsButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  text: 'batal',
                                  iconData: Icons.cancel_outlined,
                                  // color: Colors.blue,
                                  textStyle: TextStyle(color: Colors.grey),
                                  iconColor: Colors.grey,
                                ),
                                IconsButton(
                                  onPressed: () {
                                    var user = new User();
                                    user.id = userId;
                                    logOut(context, user);
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                  text: 'Logout',
                                  iconData: Icons.done,
                                  color: Colors.red,
                                  textStyle: TextStyle(color: Colors.white),
                                  iconColor: Colors.white,
                                ),
                              ],
                            );
                          },
                          child: Image.asset('assets/images/power-off.png')),
                    ],
                  ),
                ),

                // Card Section
                SizedBox(
                  height: 25,
                ),

                Padding(
                  padding: EdgeInsets.only(left: 16, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Selamat datang ' + userName,
                        style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: kBlackColor),
                      ),
                      Text(
                        'di kelas, ' + userKelas,
                        style: GoogleFonts.inter(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: kBlackColor),
                      )
                    ],
                  ),
                ),

                Container(
                  height: 199,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(left: 16, right: 6),
                    itemCount: item.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(right: 10),
                        height: 199,
                        width: 344,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            image: DecorationImage(image: item[index])),
                      );
                    },
                  ),
                ),

                // Operation Section
                Padding(
                  padding:
                      EdgeInsets.only(left: 16, bottom: 13, top: 29, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Menu',
                        style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: kBlackColor),
                      ),
                      Row(
                        children: map<Widget>(
                          datas,
                          (index, selected) {
                            return Container(
                              alignment: Alignment.centerLeft,
                              height: 9,
                              width: 9,
                              margin: EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: current == index
                                      ? kBlueColor
                                      : kTwentyBlueColor),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),

                Container(
                  height: 123,
                  child: ListView.builder(
                    itemCount: datas.length,
                    padding: EdgeInsets.only(left: 16),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            current = index;
                          });
                          if (current == 0) {
                            if (status == 0) {
                              Dialogs.materialDialog(
                                context: context,
                                color: Colors.white,
                                msg: 'Kelas belum dibuka sob.',
                                title: 'Kelas tutup',
                                lottieBuilder: LottieBuilder.asset(
                                  'assets/lottie/bycicle.json',
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
                              var cek = CekPresensi();
                              cek.user_id = userId;
                              _cekPresensi(context, cek);
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => PresensiApp()));
                            }

                            ;
                          }
                          if (current == 1) {
                            var presensi = daftar_presensi_siswa();
                            presensi.user_id = userId;
                            getDataPresensi(context, presensi);
                          }
                          if (current == 2) {
                            Dialogs.materialDialog(
                              context: context,
                              color: Colors.white,
                              msg: 'Fitur sedang dalam pengembangan',
                              title: 'Kalender Akademik',
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
                          }
                        },
                        child: OperationCard(
                            operation: datas[index].name,
                            selectedIcon: datas[index].selectedIcon,
                            unselectedIcon: datas[index].unselectedIcon,
                            isSelected: current == index,
                            context: this),
                      );
                    },
                  ),
                ),

                // Transaction Section
                // Padding(
                //   padding:
                //       EdgeInsets.only(left: 16, bottom: 13, top: 29, right: 10),
                //   child: Text(
                //     'Riwayat Presensi',
                //     style: GoogleFonts.inter(
                //         fontSize: 18,
                //         fontWeight: FontWeight.w700,
                //         color: kBlackColor),
                //   ),
                // ),
                // ListView.builder(
                //   itemCount: transactions.length,
                //   padding: EdgeInsets.only(left: 16, right: 16),
                //   shrinkWrap: true,
                //   itemBuilder: (context, index) {
                //     return Container(
                //       height: 76,
                //       margin: EdgeInsets.only(bottom: 13),
                //       padding: EdgeInsets.only(
                //           left: 24, top: 12, bottom: 12, right: 22),
                //       decoration: BoxDecoration(
                //         color: kWhiteColor,
                //         borderRadius: BorderRadius.circular(15),
                //         boxShadow: [
                //           BoxShadow(
                //             color: kTenBlackColor,
                //             blurRadius: 10,
                //             spreadRadius: 5,
                //             offset: Offset(8.0, 8.0),
                //           )
                //         ],
                //       ),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: <Widget>[
                //           Row(
                //             children: <Widget>[
                //               Container(
                //                 height: 57,
                //                 width: 57,
                //                 decoration: BoxDecoration(
                //                   shape: BoxShape.circle,
                //                   image: DecorationImage(
                //                     image: AssetImage(transactions[index].photo),
                //                   ),
                //                 ),
                //               ),
                //               SizedBox(
                //                 width: 13,
                //               ),
                //               Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: <Widget>[
                //                   Text(
                //                     transactions[index].name,
                //                     style: GoogleFonts.inter(
                //                         fontSize: 18,
                //                         fontWeight: FontWeight.w700,
                //                         color: kBlackColor),
                //                   ),
                //                   Text(
                //                     transactions[index].date,
                //                     style: GoogleFonts.inter(
                //                         fontSize: 15,
                //                         fontWeight: FontWeight.w400,
                //                         color: kGreyColor),
                //                   )
                //                 ],
                //               )
                //             ],
                //           ),
                //           Row(
                //             children: <Widget>[
                //               Text(
                //                 transactions[index].amount,
                //                 style: GoogleFonts.inter(
                //                     fontSize: 15,
                //                     fontWeight: FontWeight.w700,
                //                     color: kBlueColor),
                //               )
                //             ],
                //           )
                //         ],
                //       ),
                //     );
                //   },
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OperationCard extends StatefulWidget {
  final String operation;
  final String selectedIcon;
  final String unselectedIcon;
  final bool isSelected;
  _HomeScreenState context;

  OperationCard(
      {this.operation,
      this.selectedIcon,
      this.unselectedIcon,
      this.isSelected,
      this.context});

  @override
  _OperationCardState createState() => _OperationCardState();
}

showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("batal"),
    onPressed: () {},
  );
  Widget continueButton = TextButton(
    child: Text("keluar"),
    onPressed: () {},
  );
  // set up the AlertDialog
  // show the dialog
}

class _OperationCardState extends State<OperationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      width: 123,
      height: 123,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: kTenBlackColor,
              blurRadius: 10,
              spreadRadius: 5,
              offset: Offset(8.0, 8.0),
            )
          ],
          borderRadius: BorderRadius.circular(15),
          color: widget.isSelected ? kBlueColor : kWhiteColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
              widget.isSelected ? widget.selectedIcon : widget.unselectedIcon),
          SizedBox(
            height: 9,
          ),
          Text(
            widget.operation,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: widget.isSelected ? kWhiteColor : kBlueColor),
          )
        ],
      ),
    );
  }
}
