import 'package:presensi_app/models/cek_presensi.dart';
import 'package:presensi_app/models/daftar_presensi_siswa.dart';
import 'package:presensi_app/models/ketidakhadiran.dart';
import 'package:presensi_app/models/presensi.dart';
import 'package:presensi_app/repository/repository.dart';
import 'package:http/http.dart' as http;

class presensiService {
  Repository _repository;
  presensiService() {
    _repository = Repository();
  }

  presensiHadir(Presensi presensi) async {
    return await _repository.httpPost('presensi', presensi.toJson());
  }

  tidakHadir(KetidakHadiran tidakHadir) async {
    return await _repository.httpPost('tidak-hadir', tidakHadir.toJson());
  }

  Future<bool> addSuratKeterangan(
      Map<String, String> body, String filepath) async {
    String addSuratKeterangan =
        'https://presensi-app.zaki-alwan.xyz/api/tidak-hadir';
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };

    var request = http.MultipartRequest('POST', Uri.parse(addSuratKeterangan))
      ..fields.addAll(body)
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('image', filepath));

    var response = await request.send();
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  cekPresensi(CekPresensi presensi) async {
    return await _repository.httpPost('cek-presensi', presensi.toJson());
  }

  daftarPresensiSiswa(daftar_presensi_siswa presensi) async {
    return await _repository.httpPost('daftar-presensi', presensi.toJson());
  }
}
