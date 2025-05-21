import 'package:bloc/bloc.dart';
import 'package:food_delivery_resto_app/data/datasources/product_remote_datasources.dart';
import 'package:food_delivery_resto_app/data/models/request/product_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';
part 'add_product_bloc.freezed.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final ProductRemoteDatasources productRemoteDatasources;
  AddProductBloc(this.productRemoteDatasources) : super(_Initial()) {
    on<_AddProduct>((event, emit) async {
      emit(const _Loading());
      final result = await productRemoteDatasources.addProduct(event.data);
      result.fold(
        (failure) {
          emit(_Error(failure));
        },
        (data) {
          emit(const _Success());
        },
      );
    });
  }
}
