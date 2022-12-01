class ResetData {
  int user_id;
  String user_name;
  String email;
  String password;
  String code;

  toJson() {
    return {
      'user_id': user_id.toString(),
      'user_name': user_name ?? '',
      'user_email': email ?? '',
      'password': password ?? '',
      'code': code ?? ''
    };
  }
}
