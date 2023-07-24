import 'package:flutter/foundation.dart' show immutable;
import 'package:base_flutter_redux/common/network/api_result.dart';
import 'package:base_flutter_redux/common/usecase/usecase.dart';
import 'package:base_flutter_redux/feature/user/data/models/user.dart';
import 'package:base_flutter_redux/feature/user/domain/repositories/user_repository.dart';

@immutable
class UpdateUserUseCase implements UseCase<bool, UpdateUserParams> {
  final UserRepository userRepository;

  const UpdateUserUseCase(this.userRepository);

  @override
  Future<ApiResult<bool>> call(UpdateUserParams params) async {
    return await userRepository.updateUser(params.user);
  }
}

@immutable
class UpdateUserParams {
  final User user;

  const UpdateUserParams(this.user);
}
