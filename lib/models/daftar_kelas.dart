class daftarKelas {
  int id;
  String nama_kelas;
  int id_guru;
  int jumlah_siswa;
  String detail_kelas;
  int status;
  String kode_kelas;
  String CreatedAt;

  toJson() {
    return {
      'id_guru': id_guru.toString(),
    };
  }
}
