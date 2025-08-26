import 'package:aula_06/model/tarefa_model.dart';
import 'package:aula_06/shared/loading.dart';
import 'package:aula_06/shared/modal.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Listagem de Tarefas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TarefaModel> tarefas = [];

  Future<bool> excluirTarefa(int id) async {
    try {
      Loading.show(context, mensagem: 'Excluindo tarefa...');

      Dio dio = Dio(
        BaseOptions(
          connectTimeout: Duration(seconds: 20),
          receiveTimeout: Duration(seconds: 30),
          validateStatus: (status) => status! < 500,
        ),
      );

      Response response = await dio.delete('http://appwll.com.br/api/tarefas/$id');

      if (response.statusCode == 202) {
        Loading.hide();
        return true;
      }
    } catch (e) {
      Loading.hide();
      showModalErro(context, e.toString());
    }
    Loading.hide();
    return false;
  }

  void consultaTarefas() async {
    try {
      Loading.show(context, mensagem: 'Consultando tarefas...');

      Dio dio = Dio(
        BaseOptions(
          connectTimeout: Duration(seconds: 20),
          receiveTimeout: Duration(seconds: 30),
          validateStatus: (status) => status! < 500,
        ),
      );

      Response response = await dio.get('http://appwll.com.br/api/tarefas');

      if (response.statusCode == 200) {
        List<dynamic> jsonList = response.data;
        tarefas = jsonList.map((json) => TarefaModel.fromJson(json)).toList();
        setState(() {});
      }

      Loading.hide();
    } catch (e) {
      Loading.hide();
      showModalErro(context, e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      consultaTarefas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('${widget.title} (${tarefas.length})'),
        actions: [
          IconButton(
            onPressed: consultaTarefas,
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: () async {
            consultaTarefas();
          },
          child: ListView.builder(
            itemCount: tarefas.length,
            itemBuilder: (context, index) {
              TarefaModel tarefa = tarefas[index];
              String prioridade = tarefa.prioridade.toLowerCase().replaceAll('é', 'e');

              Color cor;
              switch (prioridade) {
                case 'alta':
                  cor = Colors.red;
                  break;
                case 'media':
                  cor = Colors.amber;
                  break;
                case 'baixa':
                  cor = Colors.green;
                  break;
                default:
                  cor = Colors.red;
              }

              return Dismissible(
                key: Key(tarefa.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (direction) async {
                  var sucesso = await excluirTarefa(tarefa.id);

                  if (sucesso) {
                    tarefas.removeAt(index);
                    setState(() {});
                  }
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: cor,
                    child: Text(
                      tarefa.prioridade[0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: Text(
                    tarefa.titulo,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  subtitle: Text(
                    'Prioridade: ${tarefa.prioridade}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
