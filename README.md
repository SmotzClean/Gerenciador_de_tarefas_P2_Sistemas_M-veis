# Organizador de Tarefas 📋

App de organização de tarefas e hábitos desenvolvido em Flutter para o Trabalho Final de Sistemas Móveis (P2).

Cria, edita, conclui e exclui tarefas com prioridade, categoria e prazo. Tudo salvo em **banco de dados local (Hive)** — funciona **100% offline**, sem internet.

## ✨ Funcionalidades

- Lista de tarefas com filtro por status (Todas / Pendentes / Concluídas)
- Cadastro e edição (título, descrição, prioridade, categoria e prazo)
- Marcar como concluída com um toque (checkbox animado)
- Deslizar a tarefa para a esquerda para **Editar** ou **Excluir** (flutter_slidable)
- Tela de Estatísticas com barra de progresso animada
- Menu lateral (Drawer) e barra de navegação inferior (BottomNavigationBar)

## ✅ Requisitos do trabalho — onde cada um está

| Requisito | Onde está |
|---|---|
| 3+ telas com passagem de parâmetros | `tela_inicio.dart`, `tela_detalhes.dart` (recebe `tarefa`), `tela_formulario.dart` (recebe `tarefa?`) |
| Banco de dados (local) | `servicos/repositorio.dart` + Hive (init em `main.dart`) |
| Componentes com estado (Stateful) | `tela_inicio.dart`, `pagina_tarefas.dart`, `tela_formulario.dart`, `tela_detalhes.dart` |
| BottomNavigationBar no Scaffold | `tela_inicio.dart` |
| Biblioteca do pub.dev (fora DB/API) | **flutter_slidable**, usada em `pagina_tarefas.dart` |
| Componentes em arquivos separados com parâmetros | pasta `lib/componentes/` (ItemTarefa, EtiquetaPrioridade, CartaoEstatistica, EstadoVazio, MenuLateral) |

> Extras: Drawer, animações Hero, AnimatedContainer e TweenAnimationBuilder.

## 📂 Estrutura do projeto

```
lib/
├── main.dart
├── modelos/
│   └── tarefa.dart              (modelo + enum Prioridade)
├── servicos/
│   └── repositorio.dart         (CRUD no Hive)
├── telas/
│   ├── tela_inicio.dart         (BottomNavigationBar + Drawer)
│   ├── tela_detalhes.dart       (recebe Tarefa por parâmetro)
│   └── tela_formulario.dart     (recebe Tarefa? por parâmetro)
├── paginas/
│   ├── pagina_tarefas.dart      (lista + flutter_slidable)
│   ├── pagina_estatisticas.dart (gráficos animados)
│   └── pagina_sobre.dart        (info do app)
├── componentes/
│   ├── menu_lateral.dart
│   ├── item_tarefa.dart
│   ├── etiqueta_prioridade.dart
│   ├── cartao_estatistica.dart
│   └── estado_vazio.dart
├── utils/
│   └── auxiliares.dart          (formatarData, iconeCategoria)
└── tema/
    └── tema_app.dart
```

## ▶️ Como executar

1. Instale o Flutter SDK: https://docs.flutter.dev/get-started/install
2. Crie um projeto Flutter novo: `flutter create tarefas_app`
3. Substitua a pasta `lib/` e o `pubspec.yaml` pelos deste pacote
4. `flutter pub get`
5. `flutter run`

> Atalho: extraia o pacote, abra no terminal e rode `flutter create .` para gerar as pastas de plataforma, depois `flutter pub get` e `flutter run`.

## 🎤 Dicas para a arguição

- **Passagem de parâmetro:** `Navigator.push(MaterialPageRoute(builder: (_) => TelaDetalhes(tarefa: tarefa)))` — o objeto `tarefa` é passado pelo construtor.
- **Banco de dados:** Hive guarda cada tarefa como um `Map`; convertemos com `toMap()` e `Tarefa.fromMap()`. O `ValueListenableBuilder` faz a tela se atualizar sozinha quando o banco muda.
- **Stateful:** `setState` controla a aba atual (`_abaAtual`), o filtro de status (`_filtro`) e os campos do formulário.
- **Biblioteca pub.dev:** `flutter_slidable` — gesto de deslizar para revelar as ações de editar e excluir.

## 👥 Integrantes

- Guilherme Dalanora Dos Santos
- João Pedro Pereira Guerra
- Vinicius da Silva Gomes
