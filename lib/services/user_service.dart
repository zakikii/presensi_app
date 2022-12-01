import 'package:presensi_app/models/pin.dart';
import 'package:presensi_app/models/reset.dart';
import 'package:presensi_app/models/user.dart';
import 'package:presensi_app/repository/repository.dart';
import 'package:http/http.dart' as http;

class UserService {
  Repository _repository;
  UserService() {
    _repository = Repository();
  }

  createUser(User user) async {
    return await _repository.httpPost('register', user.toJson());
  }

  login(User user) async {
    return await _repository.httpPost('login', user.toJson());
  }

  logout(User user) async {
    return await _repository.httpPost('logout', user.toJson());
  }

  logoutGuru(User user) async {
    return await _repository.httpPost('logout-guru', user.toJson());
  }

  enterClass(User user) async {
    return await _repository.httpPost('enter-class', user.toJson());
  }

  checkAvailablePin(pin pin) async {
    return await _repository.httpPost('check-available-pin', pin.toJson());
  }

  checkUserPin(pin pin) async {
    return await _repository.httpPost('check-pin', pin.toJson());
  }

  setUserPin(pin pin) async {
    return await _repository.httpPost('set-pin', pin.toJson());
  }

  updateUserName(ResetData user) async {
    return await _repository.httpPost('update-user-name', user.toJson());
  }

  updateUserEmail(ResetData user) async {
    return await _repository.httpPost('update-user-email', user.toJson());
  }

  sendResetEmail(ResetData reset) async {
    return await _repository.httpPost('reset-email', reset.toJson());
  }

  setNewPassword(ResetData user) async {
    return await _repository.httpPost('set-new-password', user.toJson());
  }
}
