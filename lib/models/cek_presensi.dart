class CekPresensi {
  // int id_kelas;
  int user_id;

  toJson() {
    return {'user_id': user_id.toString()};
  }
}
