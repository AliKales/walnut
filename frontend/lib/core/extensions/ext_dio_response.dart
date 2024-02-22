import 'package:dio/dio.dart';

extension ExtDioResponse on Response {
  bool get isOK => statusCode == 200;
}
