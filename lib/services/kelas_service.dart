import 'package:presensi_app/models/daftar_alpha.dart';
import 'package:presensi_app/models/daftar_hadir.dart';
import 'package:presensi_app/models/daftar_kelas.dart';
import 'package:presensi_app/models/daftar_siswa.dart';
import 'package:presensi_app/models/daftar_tidak_hadir.dart';
import 'package:presensi_app/models/kelas.dart';
import 'package:presensi_app/models/ketidakhadiran.dart';
import 'package:presensi_app/models/kick_siswa.dart';
import 'package:presensi_app/models/open_close.dart';
import 'package:presensi_app/models/presensi.dart';
import 'package:presensi_app/repository/repository.dart';

class kelasService {
  Repository _repository;
  kelasService() {
    _repository = Repository();
  }

  getDataKelas(Kelas kelas) async {
    return await _repository.httpPost('data-kelas', kelas.toJson());
  }

  getDaftarKelas(daftarKelas daftarkelas) async {
    return await _repository.httpPost('daftar-kelas', daftarkelas.toJson());
  }

  openKelas(openClose open, $id) async {
    return await _repository.httpPost('open-kelas/' + $id, open.toJson());
  }

  daftarHadir(daftar_hadir hadir) async {
    return await _repository.httpPost('daftar-hadir', hadir.toJson());
  }

  daftarTidakHadir(daftar_tidak_hadir tidakhadir) async {
    return await _repository.httpPost(
        'daftar-tidak-hadir', tidakhadir.toJson());
  }

  tanpaKeterangan(daftar_alpha alpha) async {
    return await _repository.httpPost('daftar-alpha', alpha.toJson());
  }

  daftarSiswa(daftar_siswa daftarSiswa) async {
    return await _repository.httpPost('daftar-siswa', daftarSiswa.toJson());
  }

  cekRekapBulan(Kelas kelas) async {
    return await _repository.httpPost('cek-rekap-bulan', kelas.toJson());
  }

  cekRekapSemester(Kelas kelas) async {
    return await _repository.httpPost('cek-rekap-semester', kelas.toJson());
  }

  kickSiswa(kick_siswa kick) async {
    return await _repository.httpPost('kick-siswa', kick.toJson());
  }
}
