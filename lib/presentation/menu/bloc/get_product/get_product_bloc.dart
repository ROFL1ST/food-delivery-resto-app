import 'package:bloc/bloc.dart';
import 'package:food_delivery_resto_app/data/datasources/product_remote_datasources.dart';
import 'package:food_delivery_resto_app/data/models/response/product_response_modeld.dart';
import 'package:freezed_annotation/freezed_annotation.dart';


part 'get_product_bloc.freezed.dart';
part 'get_product_event.dart';
part 'get_product_state.dart';

class GetProductBloc extends Bloc<GetProductEvent, GetProductState> {
  final ProductRemoteDatasources productRemoteDatasource;
  GetProductBloc(
    this.productRemoteDatasource,
  ) : super(const _Initial()) {
    on<_GetProducts>((event, emit) async{
      emit(const _Loading());
      final result = await productRemoteDatasource.getProducts();
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r.data ?? [])),
      );
    });
  }
}
