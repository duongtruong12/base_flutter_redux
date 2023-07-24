import 'package:base_flutter_redux/common/bloc/generic_bloc_state.dart';
import 'package:base_flutter_redux/common/dialog/create_dialog.dart';
import 'package:base_flutter_redux/common/dialog/delete_dialog.dart';
import 'package:base_flutter_redux/common/dialog/progress_dialog.dart';
import 'package:base_flutter_redux/common/dialog/retry_dialog.dart';
import 'package:base_flutter_redux/common/widget/empty_widget.dart';
import 'package:base_flutter_redux/common/widget/popup_menu.dart';
import 'package:base_flutter_redux/common/widget/spinkit_indicator.dart';
import 'package:base_flutter_redux/core/app_extension.dart';
import 'package:base_flutter_redux/core/app_style.dart';
import 'package:base_flutter_redux/di.dart';
import 'package:base_flutter_redux/feature/user/data/models/user.dart';
import 'package:base_flutter_redux/feature/user/domain/entities/user_entity.dart';
import 'package:base_flutter_redux/feature/user/presentation/bloc/user_bloc.dart';
import 'package:base_flutter_redux/feature/user/presentation/bloc/user_data.dart';
import 'package:base_flutter_redux/feature/user/presentation/bloc/user_event.dart';
import 'package:base_flutter_redux/feature/user/presentation/widgets/status_container.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

enum Operation { edit, delete, post, todo }

UserData reducer(UserData userBloc, dynamic action) {
  if (action is GenericBlocState) {
    switch (action.status) {
      case Status.success:
        if (action is GenericBlocState<User>) {
          return UserData(status: action.status, data: action.data);
        } else {
          return UserData(status: action.status, data: null);
        }
      case Status.empty:
        return UserData(status: action.status, data: const []);
      case Status.failure:
        return UserData(status: action.status, error: action.error);
      default:
        return UserData(status: action.status);
    }
  } else {
    return const UserData(status: Status.loading);
  }
}

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final store = Store<UserData>(reducer, initialState: getIt<UserData>());

  PreferredSizeWidget get _appBar {
    return AppBar(
      leading: IconButton(
        onPressed: () => getIt<UserBloc>().getUserList(UsersFetched(), store),
        icon: const Icon(Icons.refresh),
      ),
      actions: [
        PopupMenu<UserStatus>(
          icon: Icons.filter_list_outlined,
          items: UserStatus.values,
          onChanged: (UserStatus value) {
            getIt<UserBloc>().getUserList(UsersFetched(status: value), store);
          },
        ),
        PopupMenu<Gender>(
          icon: Icons.filter_alt_outlined,
          items: Gender.values,
          onChanged: (Gender value) {
            getIt<UserBloc>().getUserList(UsersFetched(gender: value), store);
          },
        )
      ],
      title: const Text("Users"),
    );
  }

  Widget get floatingActionButton {
    return FloatingActionButton(
      onPressed: () async {
        late User user;
        bool isCreate = await createDialog(
          context: context,
          userData: (User userValue) => user = userValue,
        );

        if (isCreate) {
          if (!mounted) return;
          getIt<UserBloc>().createUser(UserCreated(user), store);
          showDialog(
            context: context,
            builder: (_) {
              return StoreProvider<UserData>(
                store: store,
                child: StoreConnector<UserData, UserData>(
                  converter: (store) => store.state,
                  builder: (BuildContext context, UserData state) {
                    switch (state.status) {
                      case Status.empty:
                        return const SizedBox();
                      case Status.loading:
                        return const ProgressDialog(
                          title: "Creating user...",
                          isProgressed: true,
                        );
                      case Status.failure:
                        return RetryDialog(
                          title: state.error ?? "Error",
                          onRetryPressed: () => getIt<UserBloc>()
                              .createUser(UserCreated(user), store),
                        );
                      case Status.success:
                        return ProgressDialog(
                          title: "Successfully created",
                          onPressed: () {
                            getIt<UserBloc>()
                                .getUserList(UsersFetched(), store);
                            Navigator.pop(context);
                          },
                          isProgressed: false,
                        );
                    }
                  },
                ),
              );
            },
          );
        }
      },
      child: const Icon(Icons.add),
    );
  }

  Widget userListItem(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Row(
          children: [
            Image.asset(user.gender.name.getGenderWidget, height: 75),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: headLine4),
                  const SizedBox(height: 10),
                  Text(user.email, style: headLine6)
                ],
              ),
            ),
            const SizedBox(width: 15),
            StatusContainer(status: user.status),
            PopupMenu<Operation>(
              items: Operation.values,
              onChanged: (Operation value) async {
                switch (value) {
                  case Operation.post:
                    break;
                  case Operation.todo:
                    break;
                  case Operation.delete:
                    deleteUser(user);
                    break;
                  case Operation.edit:
                    editUser(user);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void deleteUser(User user) async {
    bool isAccepted = await deleteDialog(context);
    if (isAccepted) {
      if (!mounted) return;
      getIt<UserBloc>().deleteUser(UserDeleted(user), store);
      showDialog(
        context: context,
        builder: (_) {
          return StoreProvider<UserData>(
            store: store,
            child: StoreConnector<UserData, UserData>(
              converter: (store) => store.state,
              builder: (BuildContext context, UserData state) {
                switch (state.status) {
                  case Status.empty:
                    return const SizedBox();
                  case Status.loading:
                    return const ProgressDialog(
                      title: "Deleting user...",
                      isProgressed: true,
                    );
                  case Status.failure:
                    return RetryDialog(
                      title: state.error ?? "Error",
                      onRetryPressed: () => getIt<UserBloc>()
                          .deleteUser(UserDeleted(user), store),
                    );
                  case Status.success:
                    return ProgressDialog(
                      title: "Successfully deleted",
                      onPressed: () {
                        getIt<UserBloc>().getUserList(UsersFetched(), store);
                        Navigator.pop(context);
                      },
                      isProgressed: false,
                    );
                }
              },
            ),
          );
        },
      );
    }
  }

  void editUser(User user) async {
    late User userObj;
    bool isUpdate = await createDialog(
      user: user,
      type: Type.update,
      context: context,
      userData: (User userValue) {
        userObj = userValue;
      },
    );

    if (isUpdate) {
      if (!mounted) return;
      getIt<UserBloc>().updateUser(UserUpdated(userObj), store);
      showDialog(
        context: context,
        builder: (_) {
          return StoreProvider<UserData>(
            store: store,
            child: StoreConnector<UserData, UserData>(
              converter: (store) => store.state,
              builder: (BuildContext context, UserData state) {
                switch (state.status) {
                  case Status.empty:
                    return const SizedBox();
                  case Status.loading:
                    return const ProgressDialog(
                      title: "Updating user...",
                      isProgressed: true,
                    );
                  case Status.failure:
                    return RetryDialog(
                      title: state.error ?? "Error",
                      onRetryPressed: () => getIt<UserBloc>()
                          .updateUser(UserUpdated(userObj), store),
                    );
                  case Status.success:
                    return ProgressDialog(
                      title: "Successfully updated",
                      onPressed: () {
                        getIt<UserBloc>().getUserList(UsersFetched(), store);
                        Navigator.pop(context);
                      },
                      isProgressed: false,
                    );
                }
              },
            ),
          );
        },
      );
    }
  }

  void navigateTo(Widget screen) {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  @override
  void initState() {
    getIt<UserBloc>().getUserList(UsersFetched(), store);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      appBar: _appBar,
      body: StoreProvider<UserData>(
        store: store,
        child: StoreConnector<UserData, UserData>(
            converter: (store) => store.state,
            builder: (BuildContext context, UserData state) {
              switch (state.status) {
                case Status.empty:
                  return const EmptyWidget(message: "No user!");
                case Status.loading:
                  return const SpinKitIndicator(type: SpinKitType.circle);
                case Status.failure:
                  return RetryDialog(
                      title: state.error ?? "Error",
                      onRetryPressed: () =>
                          getIt<UserBloc>().getUserList(UsersFetched(), store));
                case Status.success:
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.data?.length ?? 0,
                    itemBuilder: (_, index) {
                      User user = state.data![index];
                      return userListItem(user);
                    },
                  );
              }
            }),
      ),
    );
  }
}
