import 'package:bloc/bloc.dart';
import 'package:food_delivery_resto_app/data/datasources/product_remote_datasources.dart';
import 'package:food_delivery_resto_app/data/models/request/product_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_product_event.dart';
part 'update_product_state.dart';
part 'update_product_bloc.freezed.dart';

class UpdateProductBloc extends Bloc<UpdateProductEvent, UpdateProductState> {
  final ProductRemoteDatasources productRemoteDatasources;
  UpdateProductBloc(this.productRemoteDatasources) : super(const _Initial()) {
    on<_UpdateProduct>((event, emit) async {
      emit(const _Loading());
      final result = await productRemoteDatasources.updateProduct(
        event.id,
        event.productRequestModel,
      );
      result.fold((message) => emit(_Error(message)), (_) {
        emit(const _Success());
      });
      // TODO: implement event handler
    });
  }
}
