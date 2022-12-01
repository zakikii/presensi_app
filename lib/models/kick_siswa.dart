class kick_siswa {
  int id_siswa;
  int id_kelas;

  toJson() {
    return {
      'user_id': id_siswa.toString() ?? '',
      'id_kelas': id_kelas.toString() ?? ''
    };
  }
}
