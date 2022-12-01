class daftar_tidak_hadir {
  int id;
  int id_kelas;
  int user_id;
  String nama_siswa;
  String keterangan;
  String detail;
  String surat_bukti_url;
  String tanggal;
  String lokasi;

  toJson() {
    return {
      'id_kelas': id_kelas.toString(),
      'tanggal': tanggal,
      'keterangan': keterangan
    };
  }
}
