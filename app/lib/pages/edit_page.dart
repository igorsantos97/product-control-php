import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trabalho/classes/produto.dart';
import 'package:trabalho/widgets/input.dart';
import 'package:trabalho/widgets/loader.dart';

import '../main.dart';

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController _ctrId = TextEditingController();
  TextEditingController _ctrDescricao = TextEditingController();
  TextEditingController _ctrValor = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _isRadioValue = 0;
  bool _ocupado = false;
  Produto produto;

  Future gravarDados() async {
    setState(() {
      _ocupado = true;
    });

    try {
      Dio dio = Dio();
      Response response = await dio.put(URL_BASE,
          options: Options(contentType: 'application/json; charset=UTF-8'),
          data: {
            'id': _ctrId.text,
            'descricao': _ctrDescricao.text,
            'valor': _ctrValor.text,
            'status': (_isRadioValue == 0) ? 'ATIVO' : 'INATIVO'
          });

      if (response.statusCode == 202) {
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
    produto = ModalRoute.of(context).settings.arguments as Produto;

    if (produto != null && _ctrId.text == '') {
      _ctrId.text = produto.iD;
      _ctrDescricao.text = produto.dESCRICAO;
      _ctrValor.text = produto.vALOR;
      if (produto.sTATUS == 'ATIVO') {
        _isRadioValue = 0;
      } else {
        _isRadioValue = 1;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar produto'),
      ),
      body: Visibility(
        visible: _ocupado,
        child: Loader(
          texto: 'Aguarde, atualizando produto...',
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
                      ctr: _ctrId,
                      label: 'ID',
                      isNotEdit: false,
                    ),
                    Input(
                      ctr: _ctrDescricao,
                      label: 'Descrição',
                      isNotEdit: true,
                    ),
                    Input(
                      ctr: _ctrValor,
                      label: 'Valor',
                      isNotEdit: true,
                      typeKeyboard: TextInputType.number,
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
                          gravarDados();
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
                            'ATUALIZAR',
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
