import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../servicos/repositorio.dart';

class MenuLateral extends StatelessWidget {
  final int abaAtual;
  final ValueChanged<int> aoSelecionarAba;

  const MenuLateral({
    super.key,
    required this.abaAtual,
    required this.aoSelecionarAba,
  });

  @override
  Widget build(BuildContext context) {
    final rep = Repositorio();
    final cores = Theme.of(context).colorScheme;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: Hive.box(Repositorio.nomeCaixa).listenable(),
              builder: (context, caixa, _) {
                final pendentes =
                    rep.buscarTodas().where((t) => !t.concluida).length;
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  color: cores.primary,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Icon(Icons.task_alt, color: cores.onPrimary, size: 40),
                      const SizedBox(height: 8),
                      Text(
                        'Organizador de Tarefas',
                        style: TextStyle(
                          color: cores.onPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$pendentes pendente(s)',
                        style: TextStyle(color: cores.onPrimary),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.checklist),
              title: const Text('Tarefas'),
              selected: abaAtual == 0,
              onTap: () => aoSelecionarAba(0),
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Estatisticas'),
              selected: abaAtual == 1,
              onTap: () => aoSelecionarAba(1),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Sobre'),
              selected: abaAtual == 2,
              onTap: () => aoSelecionarAba(2),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.cleaning_services_outlined),
              title: const Text('Limpar concluidas'),
              onTap: () async {
                final todasAsTarefas = rep.buscarTodas();
                final feitas =
                    todasAsTarefas.where((t) => t.concluida).toList();
                // remove uma por uma (for classico por seguranca)
                for (var i = 0; i < feitas.length; i++) {
                  await rep.excluir(feitas[i].id);
                }
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('${feitas.length} tarefa(s) removida(s).'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
