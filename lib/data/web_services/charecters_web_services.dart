import 'dart:developer';
import 'package:cubit_rick_and_morty_app/constants/strings.dart';
import 'package:dio/dio.dart';

class CharectersWebServices {
  Dio? dio;
  CharectersWebServices() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    );
    dio = Dio(options);
  }
  Future<Map<String, dynamic>> getAllCharecters() async {
    try {
      Response? response = await dio?.get("character");
      log(
        "character statusCode:${response?.statusCode} response: ${response?.data}",
      );
      return response?.data;
    } catch (e) {
      log("error: $e");
      return {};
    }
  }
}
