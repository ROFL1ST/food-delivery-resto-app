import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:food_delivery_resto_app/core/constants/variables.dart';
import 'package:food_delivery_resto_app/data/datasources/auth_local_datasources.dart';
import 'package:food_delivery_resto_app/data/models/request/register_request_model.dart';
import 'package:food_delivery_resto_app/data/models/response/auth_response_model.dart';

import 'package:food_delivery_resto_app/data/models/response/register_response_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthRemoteDataSource {
  Future<Either<String, RegisterResponseModel>> register(
    RegisterRequestModel requestModel,
  ) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var url = Uri.parse('${Variables.baseUrl}/api/restaurant/register');
    var request = http.MultipartRequest("POST", url);
    request.files.add(
      await http.MultipartFile.fromPath('photo', requestModel.photo!.path),
    );
    request.fields.addAll(requestModel.toMap());
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final String body = await response.stream.bytesToString();
    if (response.statusCode == 201) {
      return Right(
        RegisterResponseModel.fromJson(
          jsonDecode(body) as Map<String, dynamic>,
        ),
      );
    } else {
      return Left(body);
    }
  }

  Future<Either<String, AuthResponseModel>> login(
    String email,
    String password,
  ) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var url = Uri.parse('${Variables.baseUrl}/api/login');
    var body = jsonEncode({'email': email, 'password': password});
    var response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      return Right(AuthResponseModel.fromJson(response.body));
    } else {
      return Left(response.body);
    }
  }

  Future<Either<String, String>> logout() async {
    final authData = await AuthLocalDatasources().getAuthData();
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData!.data!.token}',
    };
    var url = Uri.parse('${Variables.baseUrl}/api/logout');
    var response = await http.post(url, headers: headers);
    if (response.statusCode == 200) {
      return Right('Logout Success');
    } else {
      return Left(response.body);
    }
  }
}
