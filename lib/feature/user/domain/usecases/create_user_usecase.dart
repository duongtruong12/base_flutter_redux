import 'package:base_flutter_redux/common/network/api_result.dart';
import 'package:base_flutter_redux/common/usecase/usecase.dart';
import 'package:base_flutter_redux/feature/user/data/models/user.dart';
import 'package:base_flutter_redux/feature/user/domain/repositories/user_repository.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class CreateUserUseCase implements UseCase<bool, CreateUserParams> {
  final UserRepository userRepository;

  const CreateUserUseCase(this.userRepository);

  @override
  Future<ApiResult<bool>> call(CreateUserParams params) async {
    return await userRepository.createUser(params.user);
  }
}

@immutable
class CreateUserParams {
  final User user;

  const CreateUserParams(this.user);
}
