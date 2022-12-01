class daftar_alpha {
  int id;
  int id_kelas;
  String name;
  String tanggal;

  toJson() {
    return {'id_kelas': id_kelas.toString(), 'tanggal': tanggal};
  }
}
