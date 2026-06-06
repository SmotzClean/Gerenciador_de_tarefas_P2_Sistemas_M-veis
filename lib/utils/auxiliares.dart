import 'package:flutter/material.dart';

// formata data no padrao brasileiro dd/mm/aaaa
String formatarData(DateTime data) {
  String _dd(int n) => n.toString().padLeft(2, '0'); // 2 digitos
  return '${_dd(data.day)}/${_dd(data.month)}/${data.year}';
}

// retorna icone baseado na categoria da tarefa
IconData iconeCategoria(String categoria) {
  switch (categoria.toLowerCase()) {
    case 'estudos':
      return Icons.school_outlined;
    case 'trabalho':
      return Icons.work_outline;
    case 'casa':
      return Icons.home_outlined;
    case 'pessoal':
      return Icons.self_improvement_outlined;
    default:
      return Icons.label_outline;
  }
}
