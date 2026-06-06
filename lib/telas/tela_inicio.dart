import 'package:flutter/material.dart';

import '../paginas/pagina_tarefas.dart';
import '../paginas/pagina_estatisticas.dart';
import '../paginas/pagina_sobre.dart';
import '../componentes/menu_lateral.dart';
import 'tela_formulario.dart';

// tela principal com a barra de navegacao inferior e o menu lateral
class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int _abaAtual = 0;

  static const _titulos = ['Minhas Tarefas', 'Estatisticas', 'Sobre'];

  final List<Widget> _paginas = const [
    PaginaTarefas(),
    PaginaEstatisticas(),
    PaginaSobre(),
  ];

  void _trocarAba(int indice) {
    setState(() => _abaAtual = indice);
  }

  Future<void> _abrirNovaTarefa() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const TelaCadastro()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titulos[_abaAtual]),
      ),
      drawer: MenuLateral(
        abaAtual: _abaAtual,
        aoSelecionarAba: (indice) {
          Navigator.of(context).pop();
          _trocarAba(indice);
        },
      ),
      body: IndexedStack(
        index: _abaAtual,
        children: _paginas,
      ),
      floatingActionButton: _abaAtual == 0
          ? FloatingActionButton.extended(
              onPressed: _abrirNovaTarefa,
              icon: const Icon(Icons.add),
              label: const Text('Nova tarefa'),
            )
          : null,
      // requisito: BottomNavigationBar no Scaffold
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _abaAtual,
        onTap: _trocarAba,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: 'Tarefas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Estatisticas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Sobre',
          ),
        ],
      ),
    );
  }
}
