import 'package:flutter/material.dart';

import '../modelos/tarefa.dart';

// etiqueta colorida de prioridade — recebe Prioridade como parametro
class EtiquetaPrioridade extends StatelessWidget {
  final Prioridade prioridade;

  const EtiquetaPrioridade({super.key, required this.prioridade});

  Color get _fundo {
    switch (prioridade) {
      case Prioridade.baixa:
        return Colors.green.shade50;
      case Prioridade.media:
        return Colors.orange.shade50;
      case Prioridade.alta:
        return Colors.red.shade50;
    }
  }

  Color get _texto {
    switch (prioridade) {
      case Prioridade.baixa:
        return Colors.green.shade700;
      case Prioridade.media:
        return Colors.orange.shade800;
      case Prioridade.alta:
        return Colors.red.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _fundo,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _texto),
      ),
      child: Text(
        prioridade.rotulo,
        style: TextStyle(
          color: _texto,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
