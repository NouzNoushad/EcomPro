import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecom_pro/features/models/response/get_products.dart';
import 'package:ecom_pro/features/models/response/login_response.dart';
import 'package:ecom_pro/features/models/user_model.dart';
import 'package:http_parser/http_parser.dart';

import '../../features/models/response/create_account.dart';
import '../utils/constants.dart';
import 'status_code.dart';

class BaseClient {
  static final dio = Dio()
    ..options = BaseOptions(
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
    )
    ..interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        responseBody: true,
        requestBody: true));

  // get products
  static Future<GetProductResponse?> getProducts(String url) async {
    var response = await dio.get(url);
    if (response.statusCode == StatusCode.ok) {
      return GetProductResponse.fromJson(response.data);
    } else {
      Handler.handleResponse(response);
    }
    return null;
  }

  // set account
  static Future<FormData> setUserAccount(UserModel userModel) async {
    var formData = FormData.fromMap({
      'full_name': userModel.name,
      'email': userModel.email,
      'phone': userModel.phone,
      'password': userModel.password,
      'role': 'customer',
    });

    if (userModel.image != null) {
      final filePath = userModel.image?.imagePath ?? '';
      final file = File(filePath);

      if (await file.exists()) {
        formData.files.add(MapEntry(
            'image',
            await MultipartFile.fromFile(filePath,
                contentType: MediaType('image', 'jpg'))));
        logger('////////// file exists: $filePath');
      } else {
        logger('////////// file doesnot exists: $filePath');
      }
    }
    return formData;
  }

  // create account
  static Future<CreateAccountResponse?> createAccount(
      String url, UserModel userModel) async {
    try {
      var formData = await setUserAccount(userModel);
      var response = await dio.post(url,
          data: formData, options: Options(contentType: 'multipart/form-data'));
      if (response.statusCode == StatusCode.ok ||
          response.statusCode == StatusCode.created) {
        logger('////////////// response: ${response.data}');
        return CreateAccountResponse.fromJson(response.data);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw Exception('Network error');
      } else {
        throw Exception('Error: ${e.message}');
      }
    }
    return null;
  }

  // login account
  static Future<LoginResponse?> loginAccount(
      String url, LoginModel loginModel) async {
    try {
      var formData = FormData.fromMap({
        'email': loginModel.email,
        'password': loginModel.password,
      });
      var response = await dio.post(url,
          data: formData, options: Options(contentType: 'multipart/form-data'));
      if (response.statusCode == StatusCode.ok ||
          response.statusCode == StatusCode.created) {
        logger('////////////// response: ${response.data}');
        return LoginResponse.fromJson(response.data);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw Exception('Network error');
      } else {
        throw Exception('Error: ${e.message}');
      }
    }
    return null;
  }
}

class Handler {
  static void handleResponse(Response response) {
    switch (response.statusCode) {
      case StatusCode.badRequest:
        throw Exception("Bad request");
      case StatusCode.notFound:
        throw Exception("Not found");
      case StatusCode.invalidRequest:
        throw Exception("Invalid request");
      case StatusCode.internalServerError:
        throw Exception("Internal server error");
      default:
        throw Exception("Unable to fetch data");
    }
  }
}
