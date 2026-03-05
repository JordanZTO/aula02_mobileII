# ARCH — Preencha após refatoração

## Estrutura final (cole a árvore de pastas)

  lib/
  main.dart

  core/
    error/
      app_error.dart

  features/
    todos/
      data/
        datasources/
          todo_remote_datasource.dart
          todo_local_datasource.dart
        models/
          todo_model.dart
        repositories/
          todo_repository_impl.dart

      domain/
        entities/
          todo.dart
        repositories/
          todo_repository.dart

      presentation/
        viewmodels/
          todo_viewmodel.dart
        pages/
          todos_page.dart
        widgets/
          add_todo_dialog.dart

## Fluxo de dependências
UI -> ViewModel -> Repository -> (RemoteDataSource, LocalDataSource)

UI (TodosPage)
        ↓
ViewModel (TodoViewModel)
        ↓
Repository (TodoRepository - interface)
        ↓
RepositoryImpl
        ↓
RemoteDataSource (HTTP)
        ↓
LocalDataSource (SharedPreferences)

Fluxo detalhado:
A UI chama o ViewModel.
O ViewModel chama o Repository.
O Repository decide como buscar dados (remoto/local).
DataSources acessam infraestrutura (HTTP ou armazenamento local).
Resultado retorna até a UI via estado.

## Decisões
- Onde ficou a validação?

A validação ficou no ViewModel.

Exemplo:
Verificação se o título do TODO está vazio antes de adicionar.

Motivo:
Validações simples de entrada pertencem à camada de apresentação.
A UI não deve conter regra de negócio.
O Domain permanece puro e independente de interface

- Onde ficou o parsing JSON?

O parsing JSON ficou no:
features/todos/data/models/todo_model.dart

Mais especificamente:
Dentro do factory TodoModel.fromJson
E no toJson()

Motivo:
Parsing é responsabilidade da camada data.
O Domain não deve conhecer JSON.
Mantemos a entidade (Todo) limpa e desacoplada de infraestrutura.

- Como você tratou erros?

Camada Data:
RemoteDataSource lança Exception quando status HTTP é inválido.
LocalDataSource pode retornar null quando não há dados.

Repository:
Apenas propaga erros para o ViewModel.

ViewModel:
Usa try/catch
Converte erro técnico em mensagem amigável
Atualiza errorMessage
Notifica a UI via notifyListeners()