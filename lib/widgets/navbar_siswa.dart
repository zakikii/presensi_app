import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:presensi_app/constants/color_constant.dart';
import 'package:presensi_app/models/daftar_siswa.dart';
import 'package:presensi_app/screens/info_kelas.dart';
import 'package:presensi_app/screens/profil_siswa.dart';
import 'package:presensi_app/services/kelas_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBarSiswa extends StatefulWidget {
  String userName;
  String userStatus;
  NavBarSiswa(this.userName, this.userStatus);

  @override
  State<NavBarSiswa> createState() => _NavBarSiswaState();
}

class _NavBarSiswaState extends State<NavBarSiswa> {
  List<daftar_siswa> _listdaftarSiswa = List<daftar_siswa>();
  String userName = '';
  String userKelas = '';
  int idKelas = 0;

  @override
  void initState() {
    super.initState();
    getuserData();
  }

  getuserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userName = pref.getString('userName');
      userKelas = pref.getString('namaKelas');
      idKelas = pref.getInt('idKelasSiswa');
    });
  }

  getDaftarSiswa(BuildContext context, daftar_siswa daftarSiswa) async {
    _listdaftarSiswa.clear();
    var _kelasService = new kelasService();
    var daftarsiswa = await _kelasService.daftarSiswa(daftarSiswa);
    var result = jsonDecode(daftarsiswa.body);
    // var siswa = new daftar_siswa();
    if (result['result'] == true) {
      result['data'].forEach((data) {
        var model = daftar_siswa();
        model.id = data['id'];
        model.id_kelas = data['id_kelas'];
        model.name = data['name'];
        model.email = data['email'];
        setState(() {
          _listdaftarSiswa.add(model);
        });
      });
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => InfoKelasScreen(_listdaftarSiswa)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(widget.userName),
            accountEmail: Text('status : ' + widget.userStatus),
            currentAccountPicture: CircleAvatar(
              backgroundColor: mainColor,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/murid.png',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                Colors.blue[900],
                Colors.blue[800],
                Colors.blue[400]
              ]),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person_pin_circle_outlined),
            title: Text('Profil'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ProfilSiswa()));
            },
          ),
          ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Info kelas'),
              onTap: () {
                var siswa = daftar_siswa();
                siswa.id_kelas = idKelas;
                getDaftarSiswa(context, siswa);
              }),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('keluar aplikasi'),
            onTap: () => exit(0),
          ),
        ],
      ),
    );
  }
}
