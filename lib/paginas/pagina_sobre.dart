import 'package:flutter/material.dart';

// tela com info do app e os requisitos do trabalho
class PaginaSobre extends StatelessWidget {
  const PaginaSobre({super.key});

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    final requisitos = <String>[
      'Navegacao entre 3+ telas com passagem de parametros',
      'Banco de dados local com Hive (funciona offline)',
      'Componentes com estado (StatefulWidget)',
      'BottomNavigationBar no Scaffold',
      'Biblioteca do pub.dev: flutter_slidable',
      'Componentes em arquivos separados com parametros',
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 12),
        Center(
          child: CircleAvatar(
            radius: 40,
            backgroundColor: cores.primaryContainer,
            child: Icon(Icons.task_alt, size: 44, color: cores.primary),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text('Organizador de Tarefas',
              style: Theme.of(context).textTheme.headlineSmall),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            'Trabalho Final - Sistemas Moveis P2',
            style: TextStyle(color: cores.onSurfaceVariant),
          ),
        ),
        const SizedBox(height: 24),
        Text('Requisitos atendidos',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...requisitos.map(
          (r) => ListTile(
            dense: true,
            leading: const Icon(Icons.check_circle, color: Colors.green),
            title: Text(r),
          ),
        ),
        const Divider(height: 32),
        Text('Integrantes', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        const Text('- (preencher com os nomes do grupo)'),
      ],
    );
  }
}
