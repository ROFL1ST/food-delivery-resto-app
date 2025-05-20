import 'package:bloc/bloc.dart';
import 'package:food_delivery_resto_app/data/datasources/auth_remote_datasources.dart';
import 'package:food_delivery_resto_app/data/models/response/auth_response_model.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRemoteDataSource authRemoteDataSource;
  LoginBloc(this.authRemoteDataSource) : super(_Initial()) {
    on<_Login>((event, emit) async {
      emit(const _Loading());
      final result = await authRemoteDataSource.login(
        event.email,
        event.password,
      );
      result.fold(
        (failure) {
          emit(_Error(failure));
        },
        (data) {
          emit(_Success(data));
        },
      );
    });
  }
}
