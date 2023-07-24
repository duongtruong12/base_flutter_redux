import 'package:base_flutter_redux/common/bloc/generic_bloc_state.dart';
import 'package:base_flutter_redux/common/network/dio_client.dart';
import 'package:base_flutter_redux/feature/user/data/datasources/user_remote_data_source.dart';
import 'package:base_flutter_redux/feature/user/data/repositories/user_repository_impl.dart';
import 'package:base_flutter_redux/feature/user/domain/repositories/user_repository.dart';
import 'package:base_flutter_redux/feature/user/domain/usecases/create_user_usecase.dart';
import 'package:base_flutter_redux/feature/user/domain/usecases/delete_user_usecase.dart';
import 'package:base_flutter_redux/feature/user/domain/usecases/get_users_usecase.dart';
import 'package:base_flutter_redux/feature/user/domain/usecases/update_user_usecase.dart';
import 'package:base_flutter_redux/feature/user/presentation/bloc/user_bloc.dart';
import 'package:base_flutter_redux/feature/user/presentation/bloc/user_data.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerFactory(
    () => const UserData(status: Status.loading),
  );

  getIt.registerLazySingleton(
    () => UserBloc(
      getUsersUseCase: getIt<GetUsersUseCase>(),
      createUserUseCase: getIt<CreateUserUseCase>(),
      updateUserUseCase: getIt<UpdateUserUseCase>(),
      deleteUserUseCase: getIt<DeleteUserUseCase>(),
    ),
  );

  // User Use cases
  getIt.registerLazySingleton(() => GetUsersUseCase(getIt<UserRepository>()));
  getIt.registerLazySingleton(() => CreateUserUseCase(getIt<UserRepository>()));
  getIt.registerLazySingleton(() => UpdateUserUseCase(getIt<UserRepository>()));
  getIt.registerLazySingleton(() => DeleteUserUseCase(getIt<UserRepository>()));

  // User repository
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: getIt()),
  );

  // User remote data sources
  getIt.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl());

  //Dio
  getIt.registerLazySingleton<DioClient>(() => DioClient(getIt<Dio>()));
  getIt.registerLazySingleton<Dio>(() => Dio());
}
