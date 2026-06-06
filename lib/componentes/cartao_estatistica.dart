import 'package:flutter/material.dart';

// cartao de metrica reutilizavel — rotulo, valor, icone e cor por parametro
class CartaoEstatistica extends StatelessWidget {
  final String rotulo;
  final String valor;
  final IconData icone;
  final Color cor;

  const CartaoEstatistica({
    super.key,
    required this.rotulo,
    required this.valor,
    required this.icone,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Icon(icone, color: cor, size: 28),
            const SizedBox(height: 8),
            Text(valor,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(rotulo,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
