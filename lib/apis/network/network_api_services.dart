import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:word_bank/apis/app_exception.dart';
import 'package:word_bank/apis/network/base_api_services.dart';

class NetworkApiServices extends BaseApiServices {
  @override
  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
  Future<dynamic> getApi(String, url) async {
    if (kDebugMode) {
      print(url);
    }
    dynamic responseJson;
    try {
      final response =
          http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      responseJson = returnResponse(response as http.Response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    responseJson;
  }

  @override
  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
  Future<dynamic> postApi(var data, String, url) async {
    if (kDebugMode) {
      print(url);
      print(data);
    }
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        return InvalidUrlException;

      default:
        throw FetchDataException(
            'Error occured while communication with server${response.statusCode}');
    }
  }
}
