import 'package:flutter/material.dart';

const baseURL = 'http://192.168.0.109:8080/api';
const loginURL = '$baseURL/login';
const logoutURL = '$baseURL/v1/logout';
const getDeliveryURL = '$baseURL/v1/delivery';

const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingwentwrong = 'Something went wrong!';