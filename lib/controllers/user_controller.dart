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

Future<ApiResponse> getUserDetail() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(userURL),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

    switch(response.statusCode){
      case 200:
        print(jsonDecode(response.body));
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingwentwrong;
        break;
    }
  } 
  catch(e) {
    print('Error: ${e}');
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