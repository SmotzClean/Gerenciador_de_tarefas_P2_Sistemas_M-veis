import 'package:flutter/material.dart';

import '../modelos/tarefa.dart';
import '../servicos/repositorio.dart';
import '../utils/auxiliares.dart';
import '../componentes/etiqueta_prioridade.dart';
import 'tela_formulario.dart';

// recebe a tarefa como parametro para exibir os detalhes
class TelaDetalhes extends StatefulWidget {
  final Tarefa tarefa;

  const TelaDetalhes({super.key, required this.tarefa});

  @override
  State<TelaDetalhes> createState() => _TelaDetalhesState();
}

class _TelaDetalhesState extends State<TelaDetalhes> {
  final _repositorio = Repositorio();
  late Tarefa _tarefa;

  @override
  void initState() {
    super.initState();
    _tarefa = widget.tarefa;
  }

  Future<void> _alternar() async {
    await _repositorio.alternarConcluida(_tarefa);
    setState(() => _tarefa = _tarefa.copyWith(concluida: !_tarefa.concluida));
  }

  Future<void> _excluir() async {
    await _repositorio.excluir(_tarefa.id);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _editar() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TelaCadastro(tarefa: _tarefa)),
    );
    // recarrega a tarefa do banco depois de editar
    final encontradas = _repositorio.buscarTodas()
        .where((t) => t.id == _tarefa.id)
        .toList();
    if (encontradas.isNotEmpty) {
      setState(() => _tarefa = encontradas.first);
    } else if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
        actions: [
          IconButton(onPressed: _editar, icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: _excluir, icon: const Icon(Icons.delete_outline)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              // Hero compartilhado com o icone da lista (animacao de transicao)
              Hero(
                tag: 'tarefa-${_tarefa.id}',
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: cores.primaryContainer,
                  child: Icon(iconeCategoria(_tarefa.categoria),
                      color: cores.primary),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(_tarefa.titulo,
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              EtiquetaPrioridade(prioridade: _tarefa.prioridade),
              const SizedBox(width: 8),
              Chip(
                avatar: Icon(iconeCategoria(_tarefa.categoria), size: 18),
                label: Text(_tarefa.categoria),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_tarefa.descricao.trim().isNotEmpty) ...[
            Text('Descricao', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(_tarefa.descricao),
            const SizedBox(height: 20),
          ],
          Text('Informacoes', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          _linha(Icons.event, 'Criada em', formatarData(_tarefa.criadaEm)),
          if (_tarefa.prazo != null)
            _linha(Icons.alarm, 'Prazo', formatarData(_tarefa.prazo!)),
          _linha(
            _tarefa.concluida
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            'Status',
            _tarefa.concluida ? 'Concluida' : 'Pendente',
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            onPressed: _alternar,
            icon: Icon(_tarefa.concluida ? Icons.undo : Icons.check),
            label: Text(
              _tarefa.concluida ? 'Reabrir tarefa' : 'Marcar como concluida',
            ),
          ),
        ],
      ),
    );
  }

  Widget _linha(IconData icone, String rotulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icone, size: 20),
          const SizedBox(width: 12),
          Text('$rotulo: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(valor),
        ],
      ),
    );
  }
}
