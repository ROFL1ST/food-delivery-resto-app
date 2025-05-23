import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:food_delivery_resto_app/core/constants/variables.dart';
import 'package:food_delivery_resto_app/data/datasources/auth_local_datasources.dart';
import 'package:food_delivery_resto_app/data/models/response/overview_response_model.dart';
import 'package:food_delivery_resto_app/data/models/response/pupular_response_model.dart';
import 'package:http/http.dart' as http;

class OverviewRemoteDataresources {
  Future<Either<String, OverviewResponse>> getOverview() async {
    final authData = await AuthLocalDatasources().getAuthData();
    final header = {
      "Authorization" :  'Bearer ${authData!.data?.token}',
      "Accept" : 'application/json',
      "Content-Type" : 'application/json',
    };
    final url = Uri.parse('${Variables.baseUrl}/api/overview/restaurant');
    final response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      return Right(OverviewResponse.fromJson(jsonMap));

    } else {
      return Left(response.body);
    }
  }

  Future<Either<String, PopularResponseModel>> getPopular() async {
    final authData = await AuthLocalDatasources().getAuthData();
    final header = {
      "Authorization" :  'Bearer ${authData!.data?.token}',
      "Accept" : 'application/json',
      "Content-Type" : 'application/json',
    };
    final url = Uri.parse('${Variables.baseUrl}/api/overview/popular-menu-items');
    final response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      return Right(PopularResponseModel.fromJson(jsonMap));

    } else {
      return Left(response.body);
    }
  }
}