import 'package:hive/hive.dart';

import '../modelos/tarefa.dart';

class Repositorio {
  static const String nomeCaixa = 'caixaTarefas';

  Box get _caixa => Hive.box(nomeCaixa);

  List<Tarefa> buscarTodas() {
    final tarefas = _caixa.values
        .map((e) => Tarefa.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
    // ordena da mais nova pra mais antiga
    tarefas.sort((a, b) => b.criadaEm.compareTo(a.criadaEm));
    return tarefas;
  }

  Future<void> salvar(Tarefa tarefa) async {
    await _caixa.put(tarefa.id, tarefa.toMap());
  }

  Future<void> excluir(String id) async {
    await _caixa.delete(id);
  }

  Future<void> alternarConcluida(Tarefa tarefa) async {
    await salvar(tarefa.copyWith(concluida: !tarefa.concluida));
  }
}
