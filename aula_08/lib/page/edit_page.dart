import 'package:aula_06/model/tarefa_model.dart';
import 'package:aula_06/shared/loading.dart';
import 'package:aula_06/shared/modal.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key, required this.tarefa});

  final TarefaModel tarefa;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _prioridadeController = TextEditingController();

  Future gravaTarefa() async {
    try {
      Loading.show(context, mensagem: 'Gravando tarefa ...');

      Dio dio = Dio(
        BaseOptions(
          connectTimeout: Duration(seconds: 20),
          receiveTimeout: Duration(seconds: 30),
          validateStatus: (status) => status! < 500,
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      String dados =
          'id=${widget.tarefa.id}&titulo=${_tituloController.text}&prioridade=${_prioridadeController.text}';

      final response = await dio.put(
        'http://appwll.com.br/api/tarefas',
        data: dados,
      );

      if (response.statusCode == 202) {
        Loading.hide();
        Navigator.pop(context, true);
        return;
      }

      Loading.hide();
      showModalErro(context, response.data['message']);
    } catch (e) {
      Loading.hide();
      showModalErro(context, e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _tituloController.text = widget.tarefa.titulo;
    _prioridadeController.text = widget.tarefa.prioridade;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Editar Tarefa'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 20,
              children: [
                TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um título';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _prioridadeController,
                  decoration: const InputDecoration(
                    labelText: 'Prioridade',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma prioridade';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      gravaTarefa();
                    }
                  },
                  child: Text('Gravar'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
