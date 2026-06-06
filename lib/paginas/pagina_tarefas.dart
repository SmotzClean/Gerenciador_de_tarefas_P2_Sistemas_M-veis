import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../modelos/tarefa.dart';
import '../servicos/repositorio.dart';
import '../telas/tela_detalhes.dart';
import '../telas/tela_formulario.dart';
import '../componentes/item_tarefa.dart';
import '../componentes/estado_vazio.dart';

enum FiltroStatus { todas, pendentes, concluidas }

class PaginaTarefas extends StatefulWidget {
  const PaginaTarefas({super.key});

  @override
  State<PaginaTarefas> createState() => _PaginaTarefasState();
}

class _PaginaTarefasState extends State<PaginaTarefas> {
  final _rep = Repositorio();
  FiltroStatus _filtro = FiltroStatus.todas;

  List<Tarefa> _aplicarFiltro(List<Tarefa> lista) {
    switch (_filtro) {
      case FiltroStatus.todas:
        return lista;
      case FiltroStatus.pendentes:
        return lista.where((t) => !t.concluida).toList();
      case FiltroStatus.concluidas:
        return lista.where((t) => t.concluida).toList();
    }
  }

  void _abrirDetalhes(Tarefa tarefa) {
    Navigator.of(context).push(
      MaterialPageRoute(
        // passagem de parametro: tarefa enviada como argumento para a proxima tela
        builder: (_) => TelaDetalhes(tarefa: tarefa),
      ),
    );
  }

  void _editarTarefa(Tarefa tarefa) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TelaCadastro(tarefa: tarefa)),
    );
  }

  Future<void> _excluirComConfirmacao(Tarefa tarefa) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir tarefa'),
        content: Text('Deseja excluir "${tarefa.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmou == true) {
      await _rep.excluir(tarefa.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              _chip('Todas', FiltroStatus.todas),
              SizedBox(width: 8), // inconsistencia: esqueci o const aqui
              _chip('Pendentes', FiltroStatus.pendentes),
              const SizedBox(width: 8),
              _chip('Concluidas', FiltroStatus.concluidas),
            ],
          ),
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: Hive.box(Repositorio.nomeCaixa).listenable(),
            builder: (context, caixa, _) {
              // busca todas e aplica o filtro de status
              final filtradas = _aplicarFiltro(_rep.buscarTodas());

              if (filtradas.isEmpty) {
                return const EstadoVazio(
                  mensagem:
                      'Nenhuma tarefa aqui.\nToque em "Nova tarefa" para comecar.',
                  icone: Icons.checklist_rtl,
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(top: 4, bottom: 90),
                itemCount: filtradas.length,
                itemBuilder: (context, i) {
                  final tarefa = filtradas[i];
                  // TODO: adicionar animacao de entrada nos itens depois
                  return Slidable(
                    key: ValueKey(tarefa.id),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      extentRatio: 0.5,
                      children: [
                        SlidableAction(
                          onPressed: (_) => _editarTarefa(tarefa),
                          icon: Icons.edit,
                          label: 'Editar',
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        SlidableAction(
                          onPressed: (_) => _excluirComConfirmacao(tarefa),
                          icon: Icons.delete,
                          label: 'Excluir',
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ],
                    ),
                    child: ItemTarefa(
                      tarefa: tarefa,
                      aoTocar: () => _abrirDetalhes(tarefa),
                      aoAlternar: () => _rep.alternarConcluida(tarefa),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _chip(String texto, FiltroStatus valor) {
    return FilterChip(
      label: Text(texto),
      selected: _filtro == valor,
      onSelected: (_) => setState(() => _filtro = valor),
    );
  }
}
