import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqlite_pam/bloc/user_bloc.dart';
import 'package:sqlite_pam/bloc/user_event.dart';
import 'package:sqlite_pam/pages/home_page.dart';

import 'data/repositories/user_repository_impl.dart';
import 'helper/database_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final dbHelper = DatabaseHelper();
  final userRepository = UserRepositoryImpl(dbHelper);

  runApp(MyApp(repository: userRepository));
}

class MyApp extends StatelessWidget {
  final UserRepositoryImpl repository;
  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(repository)..add(LoadUsers()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
        home: const HomePage(),
      ),
    );
  }
}