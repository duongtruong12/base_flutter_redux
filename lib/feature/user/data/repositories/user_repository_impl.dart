import 'package:base_flutter_redux/common/network/api_result.dart';
import 'package:base_flutter_redux/common/repository/repository_helper.dart';
import 'package:base_flutter_redux/feature/user/data/datasources/user_remote_data_source.dart';
import 'package:base_flutter_redux/feature/user/data/models/user.dart';
import 'package:base_flutter_redux/feature/user/domain/entities/user_entity.dart';
import 'package:base_flutter_redux/feature/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository with RepositoryHelper<User> {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ApiResult<List<User>>> getUsers(
      {Gender? gender, UserStatus? status}) async {
    return checkItemsFailOrSuccess(
        remoteDataSource.getUsers(gender: gender, status: status));
  }

  @override
  Future<ApiResult<bool>> createUser(User user) async {
    return checkItemFailOrSuccess(remoteDataSource.createUser(user));
  }

  @override
  Future<ApiResult<bool>> updateUser(User user) async {
    return checkItemFailOrSuccess(remoteDataSource.updateUser(user));
  }

  @override
  Future<ApiResult<bool>> deleteUser(User user) async {
    return checkItemFailOrSuccess(remoteDataSource.deleteUser(user));
  }
}
