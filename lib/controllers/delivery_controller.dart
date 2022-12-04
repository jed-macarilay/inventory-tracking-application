import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/api_response.dart';
import '../models/delivery.dart';
import './user_controller.dart';
import 'package:http/http.dart' as http;
import '../const.dart';

Future<ApiResponse> getDeliveries() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(getDeliveryURL),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['deliveries'].map((data) => DeliveryModel.fromJson(data)).toList();
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingwentwrong;
        break;
    }
  }
  catch (e){
    apiResponse.error = serverError;
    print(e);
  }

  return apiResponse;
}

Future<ApiResponse> getDelivery(deliveryId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response = await http.get(Uri.parse('${getDeliveryURL}/${deliveryId}'),
    headers: {
      'Accept': 'application/json',
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    });

    apiResponse.data = DeliveryModel.fromJson(jsonDecode(response.body)['delivery']);
  } catch(e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<ApiResponse> setStatus(int deliveryId, String status) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
     final response = await http.put(Uri.parse('$getDeliveryURL/$deliveryId/setStatus'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      }, body: {
        'status': status,
      });

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingwentwrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

Future<int> getDeliveryId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('deliveryId') ?? 0;
}