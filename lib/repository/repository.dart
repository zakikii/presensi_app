import 'package:http/http.dart' as http;

String _baseUrl = "https://smkmugad.my.id/api";
var _headers = {
  "Content-type": "application/x-www-form-urlencoded",
  "Accept": "application/json"
};

class Repository {
  httpGet(String api) async {
    return await http.get(Uri.parse(_baseUrl + "/" + api));
  }

  httpPost(String api, data) async {
    print(data);
    return await http.post(Uri.parse(_baseUrl + "/" + api),
        body: data, headers: _headers);
  }
}
