class pin {
  int user_id;
  int user_pin;

  toJson() {
    return {'user_id': user_id.toString(), 'user_pin': user_pin.toString()};
  }
}
