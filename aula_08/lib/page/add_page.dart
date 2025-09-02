import 'package:aula_06/shared/loading.dart';
import 'package:aula_06/shared/modal.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
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
        ),
      );

      final formData = FormData.fromMap({
        'titulo': _tituloController.text,
        'prioridade': _prioridadeController.text,
      });

      final response = await dio.post(
        'http://appwll.com.br/api/tarefas',
        data: formData,
      );

      if (response.statusCode == 201) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Adicionar Tarefa'),
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
