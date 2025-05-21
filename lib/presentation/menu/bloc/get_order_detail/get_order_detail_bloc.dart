import 'package:bloc/bloc.dart';
import 'package:food_delivery_resto_app/data/datasources/order_remote_datasource.dart';
import 'package:food_delivery_resto_app/data/models/response/order_response_modeld.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_order_detail_event.dart';
part 'get_order_detail_state.dart';
part 'get_order_detail_bloc.freezed.dart';

class GetOrderDetailBloc extends Bloc<GetOrderDetailEvent, GetOrderDetailState> {
  final OrderRemoteDatasource orderRemoteDatasource;
  GetOrderDetailBloc(this.orderRemoteDatasource) : super(const _Initial()) {
    on<_GetOrderDetail>((event, emit) async {
      emit(const _Loading());
      final result = await orderRemoteDatasource.getOrderById(event.id);
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r.data)),
      );
    });
  }
  
}