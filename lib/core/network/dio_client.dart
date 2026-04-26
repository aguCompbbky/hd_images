import 'package:dio/dio.dart';
import 'package:hd_images/core/network/dio_interceptor.dart';

class DioClient {

  DioClient() {
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    )..interceptors.add(CustomInterceptor());
  }
  late final Dio dio;
}
