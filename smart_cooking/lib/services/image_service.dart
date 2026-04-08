import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ImageService {
  static Future<String?> uploadImage(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.109.139.146:8000/upload/'), // 🔥 change IP
    );

    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      var res = await http.Response.fromStream(response);
      var data = jsonDecode(res.body);

      return data["image_url"]; // ✅ return only URL
    }

    return null;
  }
}