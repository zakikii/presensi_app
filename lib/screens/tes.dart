import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:presensi_app/constants/color_constant.dart';
// import 'package:presensi_app/models/card_model.dart';
import 'package:presensi_app/models/operation_model.dart';
import 'package:presensi_app/models/transaction_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi_app/screens/login_screen.dart';
import 'package:presensi_app/services/slider_service.dart';
// import 'package:presensi_app/widgets/carousel_slider.dart';
import 'package:presensi_app/widgets/sncakbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeTes extends StatefulWidget {
  @override
  _HomeTesState createState() => _HomeTesState();
}

class _HomeTesState extends State<HomeTes> {
  final SliderService _sliderService = SliderService();
  var item = [];

  @override
  void initState() {
    super.initState();
    _getAllSliders();
    getuserName();
    _isiPresensi();
  }

  String userName = '';

  getuserName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userName = pref.getString('userName');
    });
  }

  Future logOut(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('userName');
    pref.remove('userId');
    pref.remove('userEmail');
    pref.remove('idKelas');
    pref.remove('namaKelas');
    pref.remove('idKelasSiswa');
    pref.remove('namaGuru');
    pref.remove('detail_kelas');

    errorSnackBar(context, 'log out berhasil');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
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

  _isiPresensi() {
    if (current == 1) {
      successSnackBar(context, 'tes');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 8),
          child: ListView(
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              // Custom AppBar
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          logOut(context);
                        },
                        child: SvgPicture.asset('assets/svg/drawer_icon.svg')),
                    Container(
                      height: 59,
                      width: 59,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage('assets/images/user.png'),
                        ),
                      ),
                    )
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
                      'Selamat datang',
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: kBlackColor),
                    ),
                    Text(
                      userName,
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
                          image: DecorationImage(image: item[index])
                          // color: Color(cards[index].cardBackground),
                          ),
                      // child: Stack(
                      //   children: <Widget>[
                      //     Positioned(
                      //       child:
                      //           SvgPicture.asset(cards[index].cardElementTop),
                      //     ),
                      //     Positioned(
                      //       bottom: 0,
                      //       right: 0,
                      //       child: SvgPicture.asset(
                      //           cards[index].cardElementBottom),
                      //     ),
                      //     Positioned(
                      //       left: 29,
                      //       top: 48,
                      //       child: Text(
                      //         'CARD NUMBER',
                      //         style: GoogleFonts.inter(
                      //             fontSize: 14,
                      //             fontWeight: FontWeight.w400,
                      //             color: kWhiteColor),
                      //       ),
                      //     ),
                      //     Positioned(
                      //       left: 29,
                      //       top: 65,
                      //       child: Text(
                      //         cards[index].cardNumber,
                      //         style: GoogleFonts.inter(
                      //             fontSize: 20,
                      //             fontWeight: FontWeight.w700,
                      //             color: kWhiteColor),
                      //       ),
                      //     ),
                      //     Positioned(
                      //       right: 21,
                      //       top: 35,
                      //       child: Image.asset(
                      //         cards[index].cardType,
                      //         width: 27,
                      //         height: 27,
                      //       ),
                      //     ),
                      //     Positioned(
                      //       left: 29,
                      //       bottom: 45,
                      //       child: Text(
                      //         'CARD HOLDERNAME',
                      //         style: GoogleFonts.inter(
                      //             fontSize: 14,
                      //             fontWeight: FontWeight.w400,
                      //             color: kWhiteColor),
                      //       ),
                      //     ),
                      //     Positioned(
                      //       left: 29,
                      //       bottom: 21,
                      //       child: Text(
                      //         cards[index].user,
                      //         style: GoogleFonts.inter(
                      //             fontSize: 20,
                      //             fontWeight: FontWeight.w700,
                      //             color: kWhiteColor),
                      //       ),
                      //     ),
                      //     Positioned(
                      //       left: 202,
                      //       bottom: 45,
                      //       child: Text(
                      //         'EXPIRY DATE',
                      //         style: GoogleFonts.inter(
                      //             fontSize: 14,
                      //             fontWeight: FontWeight.w400,
                      //             color: kWhiteColor),
                      //       ),
                      //     ),
                      //     Positioned(
                      //       left: 202,
                      //       bottom: 21,
                      //       child: Text(
                      //         cards[index].cardExpired,
                      //         style: GoogleFonts.inter(
                      //             fontSize: 20,
                      //             fontWeight: FontWeight.w700,
                      //             color: kWhiteColor),
                      //       ),
                      //     )
                      //   ],
                      // ),
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
                          // if (index == 1) {
                          //   _isiPresensi();
                          // // }
                          // InkWell(
                          //   onTap: index == 1 ? _isiPresensi() : _isiPresensi(),
                          // );
                          // return GestureDetector(
                          //   onTap: () {
                          //     print('Drawer Tapped!');
                          // },
                          // InkWell(
                          //   onTap: () {
                          //     tes();
                          //   },
                          return Container(
                            alignment: Alignment.centerLeft,
                            height: 9,
                            width: 9,
                            margin: EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
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
                        if (current == 1) {
                          _isiPresensi();
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
              Padding(
                padding:
                    EdgeInsets.only(left: 16, bottom: 13, top: 29, right: 10),
                child: Text(
                  'Transaction Histories',
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: kBlackColor),
                ),
              ),
              ListView.builder(
                itemCount: transactions.length,
                padding: EdgeInsets.only(left: 16, right: 16),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    height: 76,
                    margin: EdgeInsets.only(bottom: 13),
                    padding: EdgeInsets.only(
                        left: 24, top: 12, bottom: 12, right: 22),
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: kTenBlackColor,
                          blurRadius: 10,
                          spreadRadius: 5,
                          offset: Offset(8.0, 8.0),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              height: 57,
                              width: 57,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(transactions[index].photo),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 13,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  transactions[index].name,
                                  style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: kBlackColor),
                                ),
                                Text(
                                  transactions[index].date,
                                  style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: kGreyColor),
                                )
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              transactions[index].amount,
                              style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: kBlueColor),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
              )
            ],
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
  _HomeTesState context;

  OperationCard(
      {this.operation,
      this.selectedIcon,
      this.unselectedIcon,
      this.isSelected,
      this.context});

  @override
  _OperationCardState createState() => _OperationCardState();
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
