import 'package:bloc/bloc.dart';
import 'package:food_delivery_resto_app/data/datasources/overview_remote_dataresources.dart';
import 'package:food_delivery_resto_app/data/models/response/pupular_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_popular_menu_event.dart';
part 'get_popular_menu_state.dart';
part 'get_popular_menu_bloc.freezed.dart';

class GetPopularMenuBloc extends Bloc<GetPopularMenuEvent, GetPopularMenuState> {
  final OverviewRemoteDataresources overviewRemoteDatasource;
  GetPopularMenuBloc(this.overviewRemoteDatasource) : super(const _Initial()) {
    on<_GetPopularMenu>((event, emit) async {
      emit(const _Loading());
      final result = await overviewRemoteDatasource.getPopular();
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r.data ?? [])),
      );
      // TODO: implement event handler
    });
  }
}
