import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiManager {
  final String mainUrl = "https://pinthat.eyesome.tw/api/";

  // Method for POST request
  // postData(String endPoint, Map<String, dynamic> data) async {
  //   print(Uri.parse(mainUrl + endPoint));
  //   print("jsonEncode(data)==>${jsonEncode(data)}");
  //   final headers = await _setHeaders(); // Get headers including token
  //   return await http.post(Uri.parse(mainUrl + endPoint),
  //       body: jsonEncode(data), headers: headers);
  // }
  Future<http.Response> postData(
      String endPoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(mainUrl + endPoint),
        body: jsonEncode(data),
        headers: await _setHeaders(), // Ensure you get headers correctly
      );
      return response; // Return http.Response
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }

  // Method for uploading an image
  Future<dynamic> uploadImage(
      String endPoint, String filepath, String userId) async {
    var request = http.MultipartRequest('POST', Uri.parse(mainUrl + endPoint))
      ..fields['user_id'] = userId
      ..files.add(await http.MultipartFile.fromPath('file', filepath));
    request.headers.addAll(await _setHeaders()); // Add headers including token
    var res = await request.send();
    final response = await http.Response.fromStream(res);
    print(response.body);
    return response;
  }

  // Method for GET request
  getData(String endPoint) async {
    final headers = await _setHeaders(); // Get headers including token
    print('Calling GET: $mainUrl$endPoint with headers: $headers');
    return await http.get(Uri.parse(mainUrl + endPoint), headers: headers);
  }

  // Method for PATCH request
  patchData(String endPoint, Map<String, dynamic> data) async {
    final headers = await _setHeaders(); // Get headers including token
    return await http.patch(Uri.parse(mainUrl + endPoint),
        body: jsonEncode(data), headers: headers);
  }

  // Method for DELETE request
  deleteData(String endPoint, Map<String, dynamic> data) async {
    final headers = await _setHeaders(); // Get headers including token
    return await http.delete(Uri.parse(mainUrl + endPoint),
        body: jsonEncode(data), headers: headers);
  }

  // Method for PUT request
  updateData(String endPoint, Map<String, dynamic> data) async {
    final headers = await _setHeaders(); // Get headers including token
    return await http.put(Uri.parse(mainUrl + endPoint),
        body: jsonEncode(data), headers: headers);
  }

  // Private method to set headers including the authorization token
  Future<Map<String, String>> _setHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('token'); // Retrieve token from SharedPreferences

    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": token != null
          ? "Bearer $token"
          : "" // Add token to headers if available
    };
  }
}
