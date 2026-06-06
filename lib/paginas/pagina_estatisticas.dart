import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../modelos/tarefa.dart';
import '../servicos/repositorio.dart';
import '../componentes/cartao_estatistica.dart';

class PaginaEstatisticas extends StatelessWidget {
  const PaginaEstatisticas({super.key});

  @override
  Widget build(BuildContext context) {
    final rep = Repositorio();
    final cores = Theme.of(context).colorScheme;

    return ValueListenableBuilder(
      valueListenable: Hive.box(Repositorio.nomeCaixa).listenable(),
      builder: (context, caixa, _) {
        final lista = rep.buscarTodas();
        final total = lista.length;
        final concluidas = lista.where((t) => t.concluida).length;
        final pendentes = total - concluidas;

        // evita divisao por zero quando nao tem tarefas ainda
        final progresso = total == 0 ? 0.0 : concluidas / total;

        final qtdAlta =
            lista.where((t) => t.prioridade == Prioridade.alta).length;
        final qtdMedia =
            lista.where((t) => t.prioridade == Prioridade.media).length;
        final qtdBaixa =
            lista.where((t) => t.prioridade == Prioridade.baixa).length;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  child: CartaoEstatistica(
                    rotulo: 'Total',
                    valor: '$total',
                    icone: Icons.list_alt,
                    cor: cores.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CartaoEstatistica(
                    rotulo: 'Pendentes',
                    valor: '$pendentes',
                    icone: Icons.pending_actions,
                    cor: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CartaoEstatistica(
                    rotulo: 'Concluidas',
                    valor: '$concluidas',
                    icone: Icons.check_circle,
                    cor: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Progresso geral',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progresso),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOut,
              builder: (context, valor, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: valor,
                        minHeight: 16,
                        backgroundColor: Colors.grey.shade200,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('${(valor * 100).toStringAsFixed(0)}% concluido'),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            Text('Por prioridade',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _BarraPrioridade(
                rotulo: 'Alta',
                quantidade: qtdAlta,
                total: total,
                cor: const Color(0xFFDC2626)),
            _BarraPrioridade(
                rotulo: 'Media',
                quantidade: qtdMedia,
                total: total,
                cor: const Color(0xFFF59E0B)),
            _BarraPrioridade(
                rotulo: 'Baixa',
                quantidade: qtdBaixa,
                total: total,
                cor: const Color(0xFF16A34A)),
          ],
        );
      },
    );
  }
}

class _BarraPrioridade extends StatelessWidget {
  final String rotulo;
  final int quantidade;
  final int total;
  final Color cor;

  const _BarraPrioridade({
    required this.rotulo,
    required this.quantidade,
    required this.total,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    final fracao = total == 0 ? 0.0 : quantidade / total;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 60, child: Text(rotulo)),
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: fracao),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOut,
              builder: (context, valor, _) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: valor,
                    minHeight: 12,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(cor),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          Text('$quantidade'),
        ],
      ),
    );
  }
}
