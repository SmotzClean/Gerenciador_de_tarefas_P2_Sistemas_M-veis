import 'dart:math';

import 'package:flutter/material.dart';

import '../modelos/tarefa.dart';
import '../servicos/repositorio.dart';
import '../utils/auxiliares.dart';

// null = nova tarefa | preenchido = edicao de tarefa existente
class TelaCadastro extends StatefulWidget {
  final Tarefa? tarefa;

  const TelaCadastro({super.key, this.tarefa});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _formKey = GlobalKey<FormState>();
  final Repositorio _db = Repositorio(); // conexao com o banco

  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();

  Prioridade _prioridade = Prioridade.media;
  String _categoria = 'Estudos';
  DateTime? _prazo;

  static const _listaCategorias = [
    'Estudos',
    'Trabalho',
    'Casa',
    'Pessoal',
    'Outros',
  ];

  bool get _modoEdicao => widget.tarefa != null;

  @override
  void initState() {
    super.initState();
    final t = widget.tarefa;
    if (t != null) {
      _tituloController.text = t.titulo;
      _descricaoController.text = t.descricao;
      _prioridade = t.prioridade;
      _categoria =
          _listaCategorias.contains(t.categoria) ? t.categoria : 'Outros';
      _prazo = t.prazo;
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _escolherData() async {
    final hoje = DateTime.now();
    final escolhida = await showDatePicker(
      context: context,
      initialDate: _prazo ?? hoje,
      firstDate: DateTime(hoje.year - 1),
      lastDate: DateTime(hoje.year + 5),
    );
    if (escolhida != null) {
      setState(() => _prazo = escolhida);
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final novoId = widget.tarefa?.id ??
        '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(9999)}';

    final tarefa = Tarefa(
      id: novoId,
      titulo: _tituloController.text.trim(),
      descricao: _descricaoController.text.trim(),
      prioridade: _prioridade,
      categoria: _categoria,
      concluida: widget.tarefa?.concluida ?? false,
      criadaEm: widget.tarefa?.criadaEm ?? DateTime.now(),
      prazo: _prazo,
    );

    // debugPrint('salvando tarefa: ${tarefa.titulo}'); // tirar isso antes de entregar
    await _db.salvar(tarefa);

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_modoEdicao ? 'Editar tarefa' : 'Nova tarefa'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Titulo *',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
              validator: (v) {
                if (v == null || v.trim() == '') {
                  return 'Informe um titulo para a tarefa.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descricao',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Text('Prioridade', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SegmentedButton<Prioridade>(
              segments: const [
                ButtonSegment(value: Prioridade.baixa, label: Text('Baixa')),
                ButtonSegment(value: Prioridade.media, label: Text('Media')),
                ButtonSegment(value: Prioridade.alta, label: Text('Alta')),
              ],
              selected: {_prioridade},
              onSelectionChanged: (sel) {
                setState(() => _prioridade = sel.first);
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _categoria,
              decoration: const InputDecoration(
                labelText: 'Categoria',
                border: OutlineInputBorder(),
              ),
              items: _listaCategorias
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Row(children: [
                          Icon(iconeCategoria(c), size: 18),
                          const SizedBox(width: 8),
                          Text(c),
                        ]),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _categoria = v);
              },
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: _escolherData,
              borderRadius: BorderRadius.circular(8),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Prazo (opcional)',
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_prazo == null
                        ? 'Sem prazo definido'
                        : formatarData(_prazo!)),
                    const Icon(Icons.calendar_today, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: _salvar,
              icon: const Icon(Icons.save),
              label:
                  Text(_modoEdicao ? 'Salvar alteracoes' : 'Adicionar tarefa'),
            ),
          ],
        ),
      ),
    );
  }
}
