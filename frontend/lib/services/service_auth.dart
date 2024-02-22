import 'dart:io';

import 'package:caroby/caroby.dart';
import 'package:dio/dio.dart';
import 'package:frontend/core/extensions/ext_dio_response.dart';
import 'package:frontend/core/sp.dart';
import 'package:frontend/models/m_user.dart';
import 'package:frontend/services/base_service.dart';

final class ServiceAuth {
  const ServiceAuth._();

  static Dio get _dio => BaseService.dio;

  static MUser? _me;
  static String? _jwt;

  MUser? get me => _me;
  String? get jwt => _jwt;

  static Future<int> init() async {
    _jwt = SP.get<String>("jwt");
    if (_jwt.isEmptyOrNull) return HttpStatus.unauthorized;

    return await fetchMe();
  }

  static Future<(int, String)> login(
    String identifier,
    String password,
  ) async {
    final result = await _dio.post("/auth/local", data: {
      "identifier": identifier,
      "password": password,
    });

    if (!result.isOK) {
      return (
        result.statusCode ?? 500,
        (result.data?['error']?['message'] as String?) ?? ""
      );
    }

    _saveJwt(result);

    await fetchMe();

    return (200, "");
  }

  static Future<(int, String)> signup(
    String email,
    String username,
    String password,
  ) async {
    final result = await _dio.post("/auth/local/register", data: {
      "email": email,
      "username": username,
      "password": password,
    });

    if (!result.isOK) {
      return (
        result.statusCode ?? 500,
        (result.data?['error']?['message'] as String?) ?? ""
      );
    }

    _saveJwt(result);

    await fetchMe();

    return (200, "");
  }

  static Future<int> fetchMe() async {
    final r =
        await _dio.get("/users/me?populate=*", options: optionsWithBearer);

    if (!r.isOK) {
      return r.statusCode ?? 500;
    }

    _me = MUser.fromJson(r.data);

    return r.statusCode ?? 500;
  }

  static void _saveJwt(Response<dynamic> result) {
    _jwt = result.data['jwt'];
    SP.set<String>("jwt", _jwt ?? "");
  }

  static Options get optionsWithBearer {
    return Options(
      headers: {
        "Authorization": "Bearer $_jwt",
      },
    );
  }
}
