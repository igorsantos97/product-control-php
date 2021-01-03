import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  TextEditingController ctr;
  String label = '';
  TextInputType typeKeyboard;
  bool isNotEdit;

  Input({
    @required this.ctr,
    @required this.label,
    @required this.isNotEdit,
    this.typeKeyboard,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: ctr,
          enabled: this.isNotEdit,
          keyboardType: this.typeKeyboard ?? TextInputType.text,
          decoration: InputDecoration(
            labelText: this.label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          validator: (valor) {
            if (valor.isEmpty) {
              return 'Informe o ${this.label}';
            } else {
              return null;
            }
          },
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
