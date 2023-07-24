import 'package:base_flutter_redux/common/network/api_result.dart';
import 'package:base_flutter_redux/feature/user/data/models/user.dart';
import 'package:base_flutter_redux/feature/user/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<ApiResult<List<User>>> getUsers({Gender? gender, UserStatus? status});

  Future<ApiResult<bool>> createUser(User user);

  Future<ApiResult<bool>> updateUser(User user);

  Future<ApiResult<bool>> deleteUser(User user);
}
