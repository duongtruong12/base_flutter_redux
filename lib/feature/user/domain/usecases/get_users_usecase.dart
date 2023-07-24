import 'package:base_flutter_redux/feature/user/domain/entities/user_entity.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:base_flutter_redux/common/network/api_result.dart';
import 'package:base_flutter_redux/common/usecase/usecase.dart';
import 'package:base_flutter_redux/feature/user/data/models/user.dart';
import 'package:base_flutter_redux/feature/user/domain/repositories/user_repository.dart';

@immutable
class GetUsersUseCase implements UseCase<List<User>, GetUsersParams> {
  final UserRepository userRepository;

  const GetUsersUseCase(this.userRepository);

  @override
  Future<ApiResult<List<User>>> call(GetUsersParams params) async {
    return await userRepository.getUsers(
        status: params.status, gender: params.gender);
  }
}

@immutable
class GetUsersParams {
  final Gender? gender;
  final UserStatus? status;

  const GetUsersParams({this.gender, this.status});
}
