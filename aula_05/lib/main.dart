import 'package:aula_05/model/post_model.dart';
import 'package:aula_05/model/user_model.dart';
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
      home: const MyHomePage(title: 'ListView API'),
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
  List<UserModel> listaUsers = [];

  void consultaPosts() async {
    try {
      listaUsers.clear();
      String url = 'https://dummyjson.com/users';

      Dio dio = Dio(
        BaseOptions(
          connectTimeout: Duration(seconds: 20),
          receiveTimeout: Duration(seconds: 30),
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      Response response = await dio.get(url);
      var data = response.data;

      if (response.statusCode == 200) {
        listaUsers = (data['users'] as List).map((user) => UserModel.fromJson(user)).toList();
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.separated(
          itemCount: listaUsers.length,
          itemBuilder: (context, index) {
            Icon icone;

            if (listaUsers[index].gender == 'female') {
              icone = Icon(Icons.female, color: Colors.pink);
            } else {
              icone = Icon(Icons.male, color: Colors.blue);
            }

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(listaUsers[index].image),
              ),
              trailing: icone,
              title: Text(
                '${listaUsers[index].id} - ${listaUsers[index].firstName}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              subtitle: Text(listaUsers[index].lastName),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: consultaPosts,
        tooltip: 'Increment',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
