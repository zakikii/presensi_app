class Presensi {
  int id;
  int id_kelas;
  int user_id;
  String nama_siswa;
  String lokasi;

  toJson() {
    return {
      'id': id.toString(),
      'id_kelas': id_kelas.toString(),
      'user_id': user_id.toString(),
      'nama_siswa': nama_siswa,
      'lokasi': lokasi,
    };
  }
}
