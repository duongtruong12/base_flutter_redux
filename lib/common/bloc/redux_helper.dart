import 'package:redux/redux.dart';

import '../network/api_result.dart';
import 'generic_bloc_state.dart';

enum ApiOperation { select, create, update, delete }

mixin ReduxHelper<T, D> {
  ApiOperation operation = ApiOperation.select;

  _checkFailureOrSuccess(ApiResult failureOrSuccess, Store<D> emit) {
    failureOrSuccess.when(
      failure: (String failure) {
        emit.dispatch(GenericBlocState.failure(failure));
      },
      success: (_) {
        emit.dispatch(GenericBlocState.success(null));
      },
    );
  }

  _apiOperationTemplate(Future<ApiResult> apiCallback, Store<D> emit) async {
    emit.dispatch(GenericBlocState.loading());
    ApiResult failureOrSuccess = await apiCallback;
    _checkFailureOrSuccess(failureOrSuccess, emit);
  }

  Future<void> getItems(
      Future<ApiResult<List<T>>> apiCallback, Store<D> emit) async {
    operation = ApiOperation.select;
    emit.dispatch(GenericBlocState.loading());
    ApiResult<List<T>> failureOrSuccess = await apiCallback;

    failureOrSuccess.when(
      failure: (String failure) async {
        emit.dispatch(GenericBlocState.failure(failure));
      },
      success: (List<T> items) async {
        if (items.isEmpty) {
          emit.dispatch(GenericBlocState.empty());
        } else {
          emit.dispatch(GenericBlocState.success(items));
        }
      },
    );
  }

  Future<void> createItem(Future<ApiResult> apiCallback, Store<D> emit) async {
    operation = ApiOperation.create;
    await _apiOperationTemplate(apiCallback, emit);
  }

  Future<void> updateItem(Future<ApiResult> apiCallback, Store<D> emit) async {
    operation = ApiOperation.update;
    await _apiOperationTemplate(apiCallback, emit);
  }

  Future<void> deleteItem(Future<ApiResult> apiCallback, Store<D> emit) async {
    operation = ApiOperation.delete;
    await _apiOperationTemplate(apiCallback, emit);
  }
}
