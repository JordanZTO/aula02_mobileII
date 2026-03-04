import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:todo_refatoracao_baguncado/features/todos/domain/entities/todo.dart';
import 'package:todo_refatoracao_baguncado/features/todos/domain/repositories/todo_repository.dart';
import 'package:todo_refatoracao_baguncado/features/todos/presentation/viewmodels/todo_viewmodel.dart';
import 'package:todo_refatoracao_baguncado/features/todos/presentation/pages/todos_page.dart';

class FakeTodoRepository implements TodoRepository {
  @override
  Future<TodoFetchResult> fetchTodos({bool forceRefresh = false}) async {
    return const TodoFetchResult(
      todos: [
        Todo(id: 1, title: 'Test Todo', completed: false),
      ],
      lastSyncLabel: 'now',
    );
  }

  @override
  Future<Todo> addTodo(String title) async {
    return Todo(id: 99, title: title, completed: false);
  }

  @override
  Future<void> updateCompleted({
    required int id,
    required bool completed,
  }) async {}
}

void main() {
  testWidgets('TodosPage renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<TodoRepository>(
            create: (_) => FakeTodoRepository(),
          ),
          ChangeNotifierProvider(
            create: (context) => TodoViewModel(context.read<TodoRepository>()),
          ),
        ],
        child: const MaterialApp(
          home: TodosPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verifica se título aparece
    expect(find.text('Todos'), findsOneWidget);

    // Verifica se botão + existe
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Verifica se o todo fake aparece
    expect(find.text('Test Todo'), findsOneWidget);
  });
}
