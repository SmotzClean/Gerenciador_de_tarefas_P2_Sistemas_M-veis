import 'package:flutter/material.dart';

import '../modelos/tarefa.dart';
import '../utils/auxiliares.dart';
import 'etiqueta_prioridade.dart';

class ItemTarefa extends StatelessWidget {
  final Tarefa tarefa;
  final VoidCallback aoTocar;
  final VoidCallback aoAlternar;

  const ItemTarefa({
    super.key,
    required this.tarefa,
    required this.aoTocar,
    required this.aoAlternar,
  });

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: aoTocar,
        leading: Hero(
          tag: 'tarefa-${tarefa.id}',
          child: CircleAvatar(
            backgroundColor: cores.primaryContainer,
            child: Icon(iconeCategoria(tarefa.categoria), color: cores.primary),
          ),
        ),
        title: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 250),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            decoration: tarefa.concluida
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: tarefa.concluida ? Colors.grey : cores.onSurface,
          ),
          child: Text(tarefa.titulo),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              EtiquetaPrioridade(prioridade: tarefa.prioridade),
              if (tarefa.prazo != null) ...[
                const SizedBox(width: 8),
                const Icon(Icons.event, size: 14),
                const SizedBox(width: 2),
                Text(formatarData(tarefa.prazo!),
                    style: const TextStyle(fontSize: 12)),
              ],
            ],
          ),
        ),
        trailing: GestureDetector(
          onTap: aoAlternar,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tarefa.concluida ? Colors.green : Colors.transparent,
              border: Border.all(
                color: tarefa.concluida ? Colors.green : Colors.grey,
                width: 2,
              ),
            ),
            child: tarefa.concluida
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : null,
          ),
        ),
      ),
    );
  }
}
