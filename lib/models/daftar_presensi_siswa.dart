class daftar_presensi_siswa {
  int user_id;
  String keterangan;
  String tanggal;
  String lokasi;
  String url;

  toJson() {
    return {'user_id': user_id.toString()};
  }
}
