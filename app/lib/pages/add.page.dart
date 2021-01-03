import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trabalho/classes/produto.dart';
import 'package:trabalho/main.dart';
import 'package:trabalho/widgets/input.dart';
import 'package:trabalho/widgets/loader.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController _ctrDescricao = TextEditingController();
  TextEditingController _ctrValor = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int _isRadioValue = 0;
  bool _ocupado = false;
  Produto produto;

  Future gravarProduto() async {
    setState(() {
      _ocupado = true;
    });

    try {
      Dio dio = Dio();
      Response response = await dio.post(
        URL_BASE,
        options: Options(contentType: 'application/json; charset=UTF-8'),
        data: {
          'descricao': _ctrDescricao.text,
          'valor': _ctrValor.text,
          'status': (_isRadioValue == 0) ? 'ATIVO' : 'INATIVO'
        },
      );

      if (response.statusCode == 201) {
        // Accepted
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      print('Erro: ' + e.toString());
    }

    setState(() {
      _ocupado = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Produto'),
      ),
      body: Visibility(
        visible: _ocupado,
        child: Loader(
          texto: 'Aguarde, gravando Produto...',
        ),
        replacement: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Input(
                      ctr: _ctrDescricao,
                      label: 'Descricao',
                      isNotEdit: true,
                    ),
                    Input(
                      ctr: _ctrValor,
                      label: 'Valor R\$',
                      typeKeyboard: TextInputType.number,
                      isNotEdit: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                            value: 0,
                            groupValue: _isRadioValue,
                            onChanged: (value) {
                              setState(() {
                                _isRadioValue = value;
                              });
                            }),
                        Text('ATIVO'),
                        Radio(
                            value: 1,
                            groupValue: _isRadioValue,
                            onChanged: (value) {
                              setState(() {
                                _isRadioValue = value;
                              });
                            }),
                        Text('INATIVO'),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                          gravarProduto();
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 55,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            'GRAVAR',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
