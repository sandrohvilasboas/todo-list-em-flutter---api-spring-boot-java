import 'dart:convert';
import 'package:http/http.dart' as http;

class TodoController {
  static Future Fetch({todo, method}) async {
    final url = Uri.parse(
      'http://10.0.2.2:8080/api/todos/',
    );
    final headers = {"Content-type": "application/json"};

    switch (method) {
      case 'GET':
        var response = await http.get(url);
        return response.body;
      case 'POST':
        await http.post(url, headers: headers, body: json.encode(todo));
        break;
      case 'PUT':
        await http.put(url, headers: headers, body: json.encode(todo));
        break;
      case 'DELETE':
        await http.delete(url, headers: headers, body: json.encode(todo));
        break;
    }
  }
}
