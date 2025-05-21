import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:food_delivery_resto_app/core/constants/variables.dart';
import 'package:food_delivery_resto_app/data/datasources/auth_local_datasources.dart';
import 'package:food_delivery_resto_app/data/models/response/order_response_modeld.dart';
import 'package:food_delivery_resto_app/data/models/response/orders_response_model.dart';
import 'package:http/http.dart' as http;

class OrderRemoteDatasource {
  Future<Either<String, OrdersResponseModel>> getOrder(String status) async {
    final authData = await AuthLocalDatasources().getAuthData();
    final header = {
      'Authorization': 'Bearer ${authData!.data?.token}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final url = Uri.parse('${Variables.baseUrl}/api/order/restaurant?status=$status');
    final response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      return Right(OrdersResponseModel.fromJson(response.body));
    } else {
      return Left(response.body);
    }
  }

  Future<Either<String, OrderResponseModel>> getOrderById(int id) async {
    final authData = await AuthLocalDatasources().getAuthData();
    final header = {
      'Authorization' : 'Bearer ${authData!.data?.token}',
      'Accept' : 'application/json',
      'Content-Type' : 'application/json',
    };
    final url = Uri.parse('${Variables.baseUrl}/api/order/$id');
    final response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      final OrderResponseModel model = OrderResponseModel.fromMap(jsonMap); // <--- Gunakan fromMap!
      return Right(model);

    } else {
      return Left(response.body);
    }
  } 
}
