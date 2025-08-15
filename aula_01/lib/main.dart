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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'TextField X TextFormField'),
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
  String? nomeCliente = '';
  final _formKey = GlobalKey<FormState>();
  final _inputNome = TextEditingController();
  final _inputIdade= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: 
                  Column(
                    spacing: 20,
                    children: [  
                      TextFormField(
                        controller: _inputNome,
                        autovalidateMode: AutovalidateMode.disabled,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nome do Cliente',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o nome do cliente';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _inputIdade,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Idade do Cliente',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira a idade do cliente';
                          }

                          if (int.tryParse(value)! < 18) {
                            return 'A idade dever ser maior ou igual que 18 anos';
                          }
                          return null;
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            print('Nome: ${_inputNome.text}');
                            print('Idade: ${_inputIdade.text}');
                            
                          }
                        },
                        child: const Text('Gravar'),
                      )
                    ],
                  )
                ),
              // TextField(
              //   maxLength: 20,
              //   keyboardType: TextInputType.text,
              //   decoration: const InputDecoration(
              //     border: OutlineInputBorder(),
              //     labelText: 'Nome do Cliente',
              //   ),
              //   onChanged: (value) => {
              //     nomeCliente = value
              //   },
              // ),
              // TextField(
              //   keyboardType: TextInputType.emailAddress,
              //   decoration: const InputDecoration(
              //     border: OutlineInputBorder(),
              //     labelText: 'E-mail do Cliente',
              //     prefixIcon: Icon(Icons.email),
              //     suffixIcon: Icon(Icons.warning, color: Colors.red,)
              //   ),
              // ),
              // TextField(
              //   readOnly: true,
              //   keyboardType: TextInputType.number,
              //   decoration: InputDecoration(
              //     filled: true,
              //     fillColor: Colors.grey[300],
              //     border: OutlineInputBorder(),
              //     labelText: 'Telefone',
              //   ),
              // ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          print('**Nome do Cliente: $nomeCliente');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), 
    );
  }
}
