class daftar_hadir {
  int id;
  int id_kelas;
  String tanggal;
  int user_id;
  String nama_siswa = '';
  String lokasi = '';

  toJson() {
    return {
      // 'id': id.toString(),
      'id_kelas': id_kelas.toString(),
      'tanggal': tanggal,
      // 'user_id': user_id.toString(),
      // 'nama_siswa': nama_siswa,
      // 'lokasi': lokasi
    };
  }
}
