import 'package:app_dio_2025/model/cep_model.dart';
import 'package:flutter/material.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key, required this.cep});

  final CepModel cep;

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final _inputCidade = TextEditingController();

  @override
  void initState() {
    super.initState();
    _inputCidade.text = widget.cep.city;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 2'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: TextField(
            controller: _inputCidade,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Cidade',
            ),
          ),
        ),
      ),
    );
  }
}
