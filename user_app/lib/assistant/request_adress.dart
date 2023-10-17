import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAddress {
  static Future receiveRequest(String url) async {
    http.Response httpResponse = await http.get(Uri.parse(url));
    try {
      if (httpResponse.statusCode == 200) {
        var responsData = jsonDecode(httpResponse.body);
        return responsData;
      } else {
        return 'خطا در دریافت اطلاعات';
      }
    } catch (e) {
      return "خطا در دریافت اطلاعات";
    }
  }
}
