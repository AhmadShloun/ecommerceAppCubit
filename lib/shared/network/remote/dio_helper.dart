import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

// baseUrl: 'https://newsapi.org/',
class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

//
  static Future<Response> getData({
    @required String? url,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio!.options.headers = {
      'lang': lang,
      'Content-Type': 'application/json',
      'Authorization': token ?? '',
    };
    return await dio!.get(
      url!,
      queryParameters: query ?? null,
    );
  }

  static Future<Response> postData({
    @required String? url, //path /login
    @required Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio!.options.headers = {
      'lang': lang,
      'Authorization': token,
      'Content-Type': 'application/json',
    };
    return await dio!.post(
      url!,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> putData({
    @required String? url, //path /login
    @required Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio!.options.headers = {
      'lang': lang,
      'Authorization': token ?? '',
      'Content-Type': 'application/json',
    };
    return await dio!.put(
      url!,
      queryParameters: query,
      data: data,
    );
  }

}
