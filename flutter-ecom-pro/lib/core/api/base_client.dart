import 'package:dio/dio.dart';
import 'package:ecom_pro/features/models/response/get_products.dart';

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
