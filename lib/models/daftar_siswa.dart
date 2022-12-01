class daftar_siswa {
  int id;
  int id_kelas;
  String name;
  String email;

  toJson() {
    return {'id_kelas': id_kelas.toString()};
  }
}
