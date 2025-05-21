part of 'delete_product_bloc.dart';

@freezed
class DeleteProductState with _$DeleteProductState {
  const factory DeleteProductState.initial() = _Initial;
  const factory DeleteProductState.loading() = _Loading;
  const factory DeleteProductState.error(String message) = _Error;
  const factory DeleteProductState.success() = _Success;
}
