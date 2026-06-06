import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'modelos/tarefa.dart';
import 'servicos/repositorio.dart';
import 'telas/tela_inicio.dart';
import 'tema/tema_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // precisa inicializar antes de usar o Hive, se nao da erro de runtime
  await Hive.initFlutter();
  await Hive.openBox(Repositorio.nomeCaixa);

  await _popularExemplos();

  runApp(const MeuApp());
}

// popula o banco com exemplos so na primeira vez que o app abre
Future<void> _popularExemplos() async {
  final caixa = Hive.box(Repositorio.nomeCaixa);
  if (caixa.isNotEmpty) return;

  final rep = Repositorio();
  await rep.salvar(Tarefa(
    id: 'ex-1',
    titulo: 'Estudar Flutter para a P2',
    descricao: 'Revisar navegacao entre telas e banco de dados.',
    prioridade: Prioridade.alta,
    categoria: 'Estudos',
    concluida: false,
    criadaEm: DateTime.now(),
    prazo: DateTime.now().add(const Duration(days: 2)),
  ));
  await rep.salvar(Tarefa(
    id: 'ex-2',
    titulo: 'Comprar mantimentos',
    descricao: 'Arroz, cafe e frutas.',
    prioridade: Prioridade.media,
    categoria: 'Casa',
    concluida: false,
    criadaEm: DateTime.now().subtract(const Duration(hours: 3)),
  ));
  await rep.salvar(Tarefa(
    id: 'ex-3',
    titulo: 'Treinar 30 minutos',
    descricao: '',
    prioridade: Prioridade.baixa,
    categoria: 'Pessoal',
    concluida: true,
    criadaEm: DateTime.now().subtract(const Duration(days: 1)),
  ));
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Organizador de Tarefas',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.claro,
      home: const TelaPrincipal(),
    );
  }
}
