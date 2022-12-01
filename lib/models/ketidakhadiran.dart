class KetidakHadiran {
  int id;
  int id_kelas;
  int user_id;
  String nama_siswa;
  String keterangan;
  String detail;
  String surat_bukti_url;
  String lokasi = '';

  toJson() {
    return {
      'id': id.toString(),
      'id_kelas': id_kelas.toString(),
      'user_id': user_id.toString(),
      'nama_siswa': nama_siswa,
      'keterangan': keterangan,
      'detail': detail,
      'surat_bukti_url': surat_bukti_url,
      'lokasi': lokasi
    };
  }
}
