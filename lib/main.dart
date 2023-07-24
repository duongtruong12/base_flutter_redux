import 'package:base_flutter_redux/core/app_theme.dart';
import 'package:base_flutter_redux/di.dart';
import 'package:base_flutter_redux/feature/user/presentation/screens/user_list_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightAppTheme,
      home: const UserListScreen(),
    );
  }
}
