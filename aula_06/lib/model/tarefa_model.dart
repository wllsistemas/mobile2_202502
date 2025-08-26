class TarefaModel {
  int id = 0;
  String titulo = '';
  String prioridade = '';

  TarefaModel();

  TarefaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'];
    prioridade = json['prioridade'];
  }
}
