import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:food_delivery_resto_app/data/datasources/auth_remote_datasources.dart';
import 'package:food_delivery_resto_app/data/models/request/register_request_model.dart';
import 'package:food_delivery_resto_app/data/models/response/register_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_bloc.freezed.dart';
part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRemoteDataSource datasource;
  RegisterBloc(
    this.datasource,
  ) : super(const _Initial()) {
    on<_Register>((event, emit) async {
      emit(const _Loading());
      final result = await datasource.register(event.requestModel);
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Success(r)),
      );
    });
  }
}
