import 'package:flutter/foundation.dart' show immutable;
import 'package:base_flutter_redux/common/network/api_result.dart';
import 'package:base_flutter_redux/common/usecase/usecase.dart';
import 'package:base_flutter_redux/feature/user/data/models/user.dart';
import 'package:base_flutter_redux/feature/user/domain/repositories/user_repository.dart';

@immutable
class DeleteUserUseCase implements UseCase<bool, DeleteUserParams> {
  final UserRepository userRepository;

  const DeleteUserUseCase(this.userRepository);

  @override
  Future<ApiResult<bool>> call(DeleteUserParams params) async {
    return await userRepository.deleteUser(params.user);
  }
}

@immutable
class DeleteUserParams {
  final User user;

  const DeleteUserParams(this.user);
}
