// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:base_flutter_redux/common/bloc/generic_bloc_state.dart';
import 'package:base_flutter_redux/common/widget/empty_widget.dart';
import 'package:base_flutter_redux/feature/user/presentation/bloc/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:redux/redux.dart';

void main() {
  group('Store Connection User', () {
    testWidgets('Check if Empty Store correct', (tester) async {
      final widget = StoreProvider<UserData>(
        store: Store<UserData>(identityReducer,
            initialState: const UserData(status: Status.empty)),
        child: StoreConnector<UserData, UserData>(
          converter: (store) => store.state,
          builder: (context, store) {
            switch (store.status) {
              case Status.empty:
                return const EmptyWidget(message: "No user!");
              default:
                return Text(
                  store.status.name,
                  textDirection: TextDirection.ltr,
                );
            }
          },
        ),
      );
      await tester.pumpWidget(widget);

      expect(find.text("No user!"), findsOneWidget);
    });
  });
}

T identityReducer<T>(T state, dynamic action) {
  return action as T;
}
