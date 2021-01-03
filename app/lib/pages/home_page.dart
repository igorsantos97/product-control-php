import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:trabalho/classes/app_route.dart';
import 'package:trabalho/classes/produto.dart';
import 'package:trabalho/widgets/loader.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _ocupado = false;
  List<Produto> _listaProduto = List<Produto>();

  Future consultaProdutos() async {
    this._ocupado = true;
    Dio dio = Dio();
    Response response = await dio.get(URL_BASE);
    if (response.statusCode == 200) {
      var produtosJson = response.data;
      _listaProduto.clear();
      for (var produto in produtosJson) {
        _listaProduto.add(Produto.fromJson(produto));
      }
    } else {
      print(response.statusCode);
    }

    _ocupado = false;
    setState(() {});
  }

  Future excluirProduto(id) async {
    setState(() {
      _ocupado = true;
    });

    Dio dio = Dio();
    Response response = await dio.delete('$URL_BASE/$id');
    if (response.statusCode == 202) {
      consultaProdutos();
    }
  }

  @override
  void initState() {
    consultaProdutos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consumo de API - Tabela Produtos'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                consultaProdutos();
              });
            },
          ),
        ],
      ),
      body: Visibility(
        visible: _ocupado,
        child: Loader(texto: 'Aguarde, carregando...'),
        replacement: ListView.builder(
          itemCount: _listaProduto.length,
          itemBuilder: (BuildContext context, int index) {
            final avatar = (_listaProduto[index].sTATUS == 'ATIVO')
                ? CircleAvatar(
                    child: Icon(Icons.work),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  )
                : CircleAvatar(
                    child: Icon(Icons.work),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  );
            return ListTile(
              isThreeLine: true,
              leading: avatar,
              title: Text(_listaProduto[index].dESCRICAO),
              subtitle: Text('#' +
                  _listaProduto[index].iD +
                  '\n' +
                  _listaProduto[index].vALOR),
              trailing: Container(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.blue,
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(
                          AppRoutes.EDIT_PAGE,
                          arguments: _listaProduto[index],
                        )
                            .then((retorno) {
                          if (retorno) {
                            setState(() {
                              consultaProdutos();
                            });
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Row(
                              children: [
                                Icon(
                                  Icons.warning,
                                  color: Colors.red,
                                ),
                                Text(
                                  'Exclusão',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                            content: Text(
                                'Produto será excluído, deseja prosseguir?'),
                            actions: [
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text(
                                  'NÃO',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Text(
                                  'SIM',
                                ),
                              ),
                            ],
                          ),
                        ).then((retorno) {
                          if (retorno) {
                            excluirProduto(_listaProduto[index].iD);
                          } else {
                            print('Clicou no NÃO');
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.ADD_PAGE).then((retorno) {
            if (retorno) {
              consultaProdutos();
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
