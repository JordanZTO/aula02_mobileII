import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/todos/data/repositories/todo_repository_impl.dart';
import 'features/todos/domain/repositories/todo_repository.dart';
import 'features/todos/presentation/viewmodels/todo_viewmodel.dart';
import 'features/todos/presentation/pages/todos_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<TodoRepository>(
          create: (_) => TodoRepositoryImpl(),
        ),
        ChangeNotifierProvider(
          create: (context) => TodoViewModel(context.read<TodoRepository>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodosPage(),
    );
  }
}
