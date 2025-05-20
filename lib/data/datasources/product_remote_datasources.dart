import 'package:dartz/dartz.dart';
import 'package:food_delivery_resto_app/core/constants/variables.dart';
import 'package:food_delivery_resto_app/data/datasources/auth_local_datasources.dart';
import 'package:food_delivery_resto_app/data/models/request/product_request_model.dart';
import 'package:food_delivery_resto_app/data/models/response/product_response_modeld.dart';
import 'package:food_delivery_resto_app/data/models/response/products_response_model.dart';
import 'package:http/http.dart' as http;

class ProductRemoteDatasources {
  Future<Either<String, ProductResponseModel>> addProduct(
    ProductRequestModel data,
  ) async {
    final authData = await AuthLocalDatasources().getAuthData();
    final header = {
      'Authorization': 'Bearer ${authData!.data?.token}',
      'Accept': 'application/json',
    };

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${Variables.baseUrl}/api/products'),
    );

    request.fields.addAll(data.toMap());
    request.files.add(
      await http.MultipartFile.fromPath('image', data.image!.path),
    );
    request.headers.addAll(header);

    http.StreamedResponse response = await request.send();

    final String body = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return Right(ProductResponseModel.fromJson(body));
    } else {
      return Left(body);
    }
  }

  Future<Either<String, ProductsResponseModel>> getProducts() async {
    final authData = await AuthLocalDatasources().getAuthData();
    final header = {
      'Authorization': 'Bearer ${authData!.data?.token}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final url = Uri.parse('${Variables.baseUrl}/api/products');
    final response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      return Right(ProductsResponseModel.fromJson(response.body));
    } else {
      return Left(response.body);
    }
  }
}
