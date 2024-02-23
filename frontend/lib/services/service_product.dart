import 'package:dio/dio.dart';
import 'package:frontend/core/extensions/ext_dio_response.dart';
import 'package:frontend/env.dart';
import 'package:frontend/models/m_product.dart';
import 'package:frontend/services/service_auth.dart';
import 'package:path_provider/path_provider.dart';

import 'base_service.dart';

final class ServiceProduct {
  const ServiceProduct._();

  static Dio get _dio => BaseService.dio;

  ///[addProduct] will create new product
  ///but if [productId] is given then it will update the product with id
  static Future<(int, MProduct?)> addProduct(
    String name,
    double price,
    String description, {
    int? productId,
  }) async {
    bool isUpdate = productId != null;

    final body = {
      "name": name,
      "price": price,
      "description": description,
    };

    String path = "/products";

    if (productId != null) {
      path += "/$productId";
    }

    final result = await _dio.request(
      path,
      options: ServiceAuth.optionsWithBearer
          .copyWith(method: isUpdate ? "PUT" : "POST"),
      data: body,
    );

    if (!result.isOK) {
      return (result.statusCode!, null);
    }

    return (200, MProduct.fromJson(result.data));
  }

  static Future<int> deleteProduct(int id) async {
    final r = await _dio.delete("/products/$id",
        options: ServiceAuth.optionsWithBearer);

    return r.statusCode ?? 500;
  }

  static Future<(int, String)> uploadImage(String path, int productId) async {
    final data = FormData.fromMap({
      "refId": productId,
      "ref": "api::product.product",
      "field": "image",
      "files": await MultipartFile.fromFile(path)
    });

    final r = await _dio.post("/upload",
        data: data, options: ServiceAuth.optionsWithBearer);

    if (!r.isOK) {
      return (r.statusCode!, "");
    }

    String url = BASE_URL + r.data[0]["url"];

    return (200, url);
  }

  static Future<void> downloadCSV() async {
    final dir = await getApplicationDocumentsDirectory();

    await _dio.download("/products-csv", "${dir.path}/products.csv",
        options: ServiceAuth.optionsWithBearer);
  }

  ///[fetchProducts] will return (statusCode) and List of Products
  ///if you want a specific product then pass an id
  ///if id is 0 current user's all products will be returned
  ///if id is null then all products will be returned
  static Future<(int, List<MProduct>?)> fetchProducts([int? id]) async {
    String path = "/products";
    if (id != null) {
      path += "/$id";
    }

    final r = await _dio.get(path, options: ServiceAuth.optionsWithBearer);

    if (!r.isOK) {
      return (r.statusCode!, null);
    }

    List<MProduct> products =
        r.data.map((e) => MProduct.fromJson(e)).toList().cast<MProduct>();

    return (200, products);
  }
}
