import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../const.dart';
import '../models/api_response.dart';
import '../models/user.dart';

Future<ApiResponse> login (String email, String password) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(
      Uri.parse(loginURL),
      headers: { 'Accept' : 'application/json' },
      body: { 
        'email': email,
        'password': password,
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));

        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];

        apiResponse.error = errors[errors.keys.elementAt(0)][0];

        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];

        break;
      case 404:
        apiResponse.error = jsonDecode(response.body)['message'];
      break;
      default:
        apiResponse.error = somethingwentwrong;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

Future<bool> logout () async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  return await pref.remove('token');
}

Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}