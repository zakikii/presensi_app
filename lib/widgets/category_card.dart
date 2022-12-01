import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi_app/constants/color_constant.dart';

class CategoryCard extends StatelessWidget {
  final String svgSrc;
  final String title;
  final Function press;
  final Color warna;

  const CategoryCard({Key key, this.svgSrc, this.title, this.press, this.warna})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: warna,
            blurRadius: 2,
            spreadRadius: 2,
            offset: Offset(0.0, 0.0),
          )
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(11),
        clipBehavior: Clip.hardEdge,
        color: kWhiteColor,
        child: InkWell(
          onTap: press,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                Spacer(),
                Image.asset(svgSrc),
                Spacer(),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: kBlackColor),
                  // style: Theme.of(context)
                  //     .textTheme
                  //     .headline1
                  //     .copyWith(fontSize: 15),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
