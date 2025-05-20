import 'package:bloc/bloc.dart';
import 'package:food_delivery_resto_app/data/datasources/auth_remote_datasources.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'logout_event.dart';
part 'logout_state.dart';
part 'logout_bloc.freezed.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthRemoteDataSource authRemoteDataSource;
  LogoutBloc(this.authRemoteDataSource) : super(const _Initial()) {
    on<_Logout>((event, emit) async {
      emit(const _Loading());
      final result = await authRemoteDataSource.logout();
      result.fold(
        (error) => emit(_Error(error)),
        (_) => emit(const _Success()),
      );
    });
  }
}
