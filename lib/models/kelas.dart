class Kelas {
  int id;
  String bulan;
  String kategori;
  String tahun_ganjil;
  String tahun_genap;
  // String nama_kelas;

  toJson() {
    return {
      'id_kelas': id.toString(),
      'bulan': bulan ?? '',
      'kategori': kategori ?? '',
      'tahun_ganjil': tahun_ganjil ?? '',
      'tahun_genap': tahun_genap ?? ''
    };
  }
}
