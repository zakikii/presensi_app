import 'package:flutter/material.dart';
import 'package:presensi_app/constants/color_constant.dart';
import 'package:presensi_app/models/daftar_tidak_hadir.dart';
import 'package:presensi_app/models/ketidakhadiran.dart';

class TidakHadirDetails extends StatelessWidget {
  daftar_tidak_hadir tidakHadir;
  TidakHadirDetails({this.tidakHadir});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromRGBO(30, 30, 30, 1.0),
      body: TidakHadirDetailsScreen(this.tidakHadir),
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: [],
        // foregroundColor: Colors.black,
        textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.black)),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios, color: Colors.black),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
    );
  }
}

class PreviewImage extends StatelessWidget {
  // const PreviewImage({Key? key}) : super(key: key);
  daftar_tidak_hadir tidakHadir;
  PreviewImage({this.tidakHadir});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'preview image',
            child: Image.network(this.tidakHadir.surat_bukti_url),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class TidakHadirDetailsScreen extends StatefulWidget {
  final daftar_tidak_hadir tidakHadir;
  TidakHadirDetailsScreen(this.tidakHadir);

  @override
  State<TidakHadirDetailsScreen> createState() =>
      _TidakHadirDetailsScreenState();
}

class _TidakHadirDetailsScreenState extends State<TidakHadirDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: <Widget>[
        // Container(
        //   height: size.height * .45,
        //   decoration: BoxDecoration(
        //       gradient: LinearGradient(
        //         colors: [
        //           backgroundColor1,
        //           backgroundColor2,
        //         ],
        //       ),
        //       borderRadius: BorderRadius.only(
        //         bottomLeft: Radius.circular(40),
        //         bottomRight: Radius.circular(40),
        //       )),
        // ),
        Container(
          child: ListView(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 487 / 451,
                child: GestureDetector(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Hero(
                          tag: 'preview image',
                          child:
                              Image.network(widget.tidakHadir.surat_bukti_url)),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PreviewImage(
                                  tidakHadir: this.widget.tidakHadir,
                                )));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  this.widget.tidakHadir.keterangan,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      'lokasi mengisi :' + this.widget.tidakHadir.lokasi,
                      style: TextStyle(
                          backgroundColor: Colors.black12, fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(6.0),
                child: Text(this.widget.tidakHadir.detail),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
