import 'package:base_flutter_redux/common/bloc/generic_bloc_state.dart';
import 'package:base_flutter_redux/feature/user/data/models/user.dart';

class UserData extends GenericBlocState<User> {
  const UserData({required super.status, super.data, super.error});
}
