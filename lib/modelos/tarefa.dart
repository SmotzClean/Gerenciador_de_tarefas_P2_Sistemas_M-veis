// modelo principal do app — representa uma tarefa do usuario
enum Prioridade { baixa, media, alta }

extension RotuloPrioridade on Prioridade {
  String get rotulo {
    switch (this) {
      case Prioridade.baixa:
        return 'Baixa';
      case Prioridade.media:
        return 'Media';
      case Prioridade.alta:
        return 'Alta';
    }
  }
}

class Tarefa {
  final String id;
  final String titulo;
  final String descricao;
  final Prioridade prioridade;
  final String categoria;
  final bool concluida;
  final DateTime criadaEm;
  final DateTime? prazo;

  const Tarefa({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.prioridade,
    required this.categoria,
    required this.concluida,
    required this.criadaEm,
    this.prazo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'prioridade': prioridade.index,
      'categoria': categoria,
      'concluida': concluida,
      'criadaEm': criadaEm.millisecondsSinceEpoch,
      'prazo': prazo?.millisecondsSinceEpoch,
    };
  }

  factory Tarefa.fromMap(Map<String, dynamic> mapa) {
    return Tarefa(
      id: mapa['id'] as String,
      titulo: mapa['titulo'] as String,
      descricao: (mapa['descricao'] ?? '') as String,
      prioridade: Prioridade.values[(mapa['prioridade'] ?? 0) as int],
      categoria: (mapa['categoria'] ?? 'Geral') as String,
      concluida: (mapa['concluida'] ?? false) as bool,
      criadaEm:
          DateTime.fromMillisecondsSinceEpoch((mapa['criadaEm'] ?? 0) as int),
      prazo: mapa['prazo'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(mapa['prazo'] as int),
    );
  }

  Tarefa copyWith({
    String? id,
    String? titulo,
    String? descricao,
    Prioridade? prioridade,
    String? categoria,
    bool? concluida,
    DateTime? criadaEm,
    DateTime? prazo,
  }) {
    return Tarefa(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      prioridade: prioridade ?? this.prioridade,
      categoria: categoria ?? this.categoria,
      concluida: concluida ?? this.concluida,
      criadaEm: criadaEm ?? this.criadaEm,
      prazo: prazo ?? this.prazo,
    );
  }
}
