import 'package:app_dio_2025/model/cep_model.dart';
import 'package:app_dio_2025/shared/loading.dart';
import 'package:app_dio_2025/shared/modal.dart';
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  final _formKey = GlobalKey<FormState>();
  final _inputCep = TextEditingController();
  final _inputRua = TextEditingController();
  final _inputBairro = TextEditingController();
  final _inputCidade = TextEditingController();

  void limparCampos() {
    _inputBairro.clear();
    _inputRua.clear();
    _inputCidade.clear();
  }

  void consultaCep(String cep) async {
    try {
      Loading.show(context, mensagem: 'Consultando CEP...');
      limparCampos();

      Dio dio = Dio(
        BaseOptions(
          connectTimeout: Duration(seconds: 30),
          receiveTimeout: Duration(seconds: 120),
          sendTimeout: Duration(seconds: 30),
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      final response = await dio.get('https://cep.awesomeapi.com.br/json/$cep');

      if (response.statusCode == 200) {
        CepModel cep = CepModel.fromJson(response.data);

        _inputBairro.text = cep.district;
        _inputRua.text = cep.address;
        _inputCidade.text = cep.city;
      } else {
        showModalErro(context, 'CEP não encontrado');
      }

      Loading.hide();
    } catch (e) {
      Loading.hide();

      if (e.toString().contains('Failed host lookup')) {
        showModalErro(context, 'Verifique sua conexão com a internet');
      } else {
        showModalErro(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _inputCep,
                  maxLength: 8,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'CEP',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um CEP válido';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    consultaCep(_inputCep.text);
                  }
                },
                child: const Text('Consultar'),
              ),
              TextField(
                controller: _inputRua,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Rua',
                ),
              ),
              TextField(
                controller: _inputBairro,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Bairro',
                ),
              ),
              TextField(
                controller: _inputCidade,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Cidade',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
