import 'package:flutter/material.dart';

// exibido quando a lista nao tem nenhuma tarefa
class EstadoVazio extends StatelessWidget {
  final String mensagem;
  final IconData icone;

  const EstadoVazio({
    super.key,
    required this.mensagem,
    this.icone = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 72, color: cores.outline),
            const SizedBox(height: 16),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: TextStyle(color: cores.outline, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
