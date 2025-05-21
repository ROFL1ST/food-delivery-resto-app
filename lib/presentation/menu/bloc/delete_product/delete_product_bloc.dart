import 'package:bloc/bloc.dart';
import 'package:food_delivery_resto_app/core/extensions/string_ext.dart';
import 'package:food_delivery_resto_app/data/datasources/product_remote_datasources.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_product_event.dart';
part 'delete_product_state.dart';
part 'delete_product_bloc.freezed.dart';

class DeleteProductBloc extends Bloc<DeleteProductEvent, DeleteProductState> {
  final ProductRemoteDatasources productRemoteDatasource;
  DeleteProductBloc(this.productRemoteDatasource) : super(const _Initial()) {
    on<_DeleteProduct>((event, emit) async {
      emit(const _Loading());
      //delete data order by product id.
      final result = await productRemoteDatasource.deleteProduct(event.id);
      result.fold(
        (error) => emit(_Error( error)),
        (_) => emit(const _Success()),
      );
    });
  }
}
