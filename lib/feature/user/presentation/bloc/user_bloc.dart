import 'package:base_flutter_redux/common/bloc/redux_helper.dart';
import 'package:base_flutter_redux/feature/user/data/models/user.dart';
import 'package:base_flutter_redux/feature/user/domain/usecases/create_user_usecase.dart';
import 'package:base_flutter_redux/feature/user/domain/usecases/delete_user_usecase.dart';
import 'package:base_flutter_redux/feature/user/domain/usecases/get_users_usecase.dart';
import 'package:base_flutter_redux/feature/user/domain/usecases/update_user_usecase.dart';
import 'package:base_flutter_redux/feature/user/presentation/bloc/user_data.dart';
import 'package:base_flutter_redux/feature/user/presentation/bloc/user_event.dart';
import 'package:redux/redux.dart';

class UserBloc with ReduxHelper<User, UserData> {
  final GetUsersUseCase getUsersUseCase;
  final CreateUserUseCase createUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final DeleteUserUseCase deleteUserUseCase;

  UserBloc(
      {required this.getUsersUseCase,
      required this.createUserUseCase,
      required this.updateUserUseCase,
      required this.deleteUserUseCase});

  Future<void> getUserList(UsersFetched event, Store<UserData> emit) async {
    await getItems(
        getUsersUseCase
            .call(GetUsersParams(status: event.status, gender: event.gender)),
        emit);
  }

  Future<void> createUser(UserCreated event, Store<UserData> emit) async {
    await createItem(
        createUserUseCase.call(CreateUserParams(event.user)), emit);
  }

  Future<void> updateUser(UserUpdated event, Store<UserData> emit) async {
    await updateItem(
        updateUserUseCase.call(UpdateUserParams(event.user)), emit);
  }

  Future<void> deleteUser(UserDeleted event, Store<UserData> emit) async {
    await deleteItem(
        deleteUserUseCase.call(DeleteUserParams(event.user)), emit);
  }
}
