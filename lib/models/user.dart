class User {
  int id;
  int id_kelas;
  String kode_kelas;
  String name;
  String email;
  int level;
  String password;
  String device_id;

  toJson() {
    return {
      'id': id.toString(),
      'name': name.toString() ?? '',
      'kode_kelas': kode_kelas ?? '',
      'id_kelas': id_kelas.toString(),
      'email': email ?? '',
      'level': level.toString(),
      'password': password ?? '',
      'device_id': device_id ?? '',
    };
  }
}
