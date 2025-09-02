import 'package:aula_06/model/tarefa_model.dart';
import 'package:aula_06/page/add_page.dart';
import 'package:aula_06/page/edit_page.dart';
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
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(),
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
  final _inputFiltro = TextEditingController();
  List<TarefaModel> tarefasOriginal = [];
  List<TarefaModel> tarefasFiltrada = [];
  int alta = 0;
  int media = 0;
  int baixa = 0;

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

  Future consultaTarefas() async {
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
        tarefasOriginal = jsonList.map((json) => TarefaModel.fromJson(json)).toList();
        tarefasFiltrada = List.from(tarefasOriginal);
        totalizarTarefas();
        setState(() {});
      }

      Loading.hide();
    } catch (e) {
      Loading.hide();
      showModalErro(context, e.toString());
    }
  }

  void totalizarTarefas() {
    if (tarefasOriginal.isEmpty) {
      alta = 0;
      media = 0;
      baixa = 0;
      return;
    }

    alta = tarefasOriginal.where((tarefa) => tarefa.prioridade.toLowerCase() == 'alta').length;

    media = tarefasOriginal
        .where((tarefa) =>
            tarefa.prioridade.toLowerCase() == 'média' ||
            tarefa.prioridade.toLowerCase() == 'media')
        .length;

    baixa = tarefasOriginal.where((tarefa) => tarefa.prioridade.toLowerCase() == 'baixa').length;
  }

  void filtraPrioridade(String prioridade) {
    if (prioridade == 'Todos') {
      tarefasFiltrada = List.from(tarefasOriginal);
    } else {
      tarefasFiltrada = tarefasOriginal
          .where(
            (tarefa) => tarefa.prioridade.toLowerCase() == prioridade.toLowerCase(),
          )
          .toList();
    }
    setState(() {});
  }

  void filtraPorTitulo() {
    if (_inputFiltro.text.isEmpty) {
      tarefasFiltrada = List.from(tarefasOriginal);
    } else {
      tarefasFiltrada = tarefasOriginal
          .where((tarefa) => tarefa.titulo.toLowerCase().contains(_inputFiltro.text.toLowerCase()))
          .toList();
    }
    setState(() {});
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
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: consultaTarefas,
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 50,
              child: TextField(
                controller: _inputFiltro,
                decoration: InputDecoration(
                  hintText: 'Filtrar por título',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[600],
                  suffixIcon: Icon(Icons.search, color: Colors.white),
                ),
                onChanged: (value) {
                  filtraPorTitulo();
                },
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(spacing: 10, children: [
                InkWell(
                  onTap: () {
                    filtraPrioridade('Todos');
                  },
                  child: Container(
                    width: 80,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                        child: Text(
                      'Todos ${(alta + media + baixa)}',
                      style: TextStyle(color: Colors.grey[700]),
                    )),
                  ),
                ),
                InkWell(
                  onTap: () {
                    filtraPrioridade('alta');
                  },
                  child: Container(
                    width: 80,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        'Alta $alta',
                        style: TextStyle(color: Colors.red[800]),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    filtraPrioridade('media');
                  },
                  child: Container(
                    width: 80,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        'Média $media',
                        style: TextStyle(color: Colors.amber[900]),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    filtraPrioridade('baixa');
                  },
                  child: Container(
                    width: 80,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        'Baixa $baixa',
                        style: TextStyle(color: Colors.green[800]),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                consultaTarefas();
              },
              child: ListView.separated(
                itemCount: tarefasFiltrada.length,
                itemBuilder: (context, index) {
                  TarefaModel tarefa = tarefasFiltrada[index];
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
                        tarefasFiltrada.removeAt(index);
                        tarefasOriginal.removeAt(index);
                        totalizarTarefas();
                        setState(() {});
                      }
                    },
                    child: ListTile(
                      onTap: () async {
                        var retorno = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditPage(
                              tarefa: tarefa,
                            ),
                          ),
                        );

                        if (retorno != null && retorno == true) {
                          consultaTarefas();
                        }
                      },
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
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        'Prioridade: ${tarefa.prioridade}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: Colors.grey[800],
                    thickness: 1,
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var retorno = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddPage(),
            ),
          );

          if (retorno != null && retorno == true) {
            consultaTarefas();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
