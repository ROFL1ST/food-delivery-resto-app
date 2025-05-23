import 'package:bloc/bloc.dart';
import 'package:food_delivery_resto_app/data/datasources/overview_remote_dataresources.dart';
import 'package:food_delivery_resto_app/data/models/response/overview_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_overview_event.dart';
part 'get_overview_state.dart';
part 'get_overview_bloc.freezed.dart';

class GetOverviewBloc extends Bloc<GetOverviewEvent, GetOverviewState> {
  final OverviewRemoteDataresources overviewRemoteDatasource;
  GetOverviewBloc(this.overviewRemoteDatasource) : super(const _Initial()) {
    on<_GetOverview>((event, emit) async {
      emit(const _Loading());
      final result = await overviewRemoteDatasource.getOverview();
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r)),
      );
      // TODO: implement event handler
    });
  }
}
