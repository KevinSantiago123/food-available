import 'package:flutter/material.dart';

bool isNumeric(String value) {
  final numero = num.tryParse(value);
  if (value.isEmpty) return false;
  return (numero == null) ? false : true;
}

void mostrarAlerta(BuildContext context, String mensaje) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Información incorrecta'),
          content: Text(mensaje),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });
}

void mostrarSnackbar(String mensaje, dynamic key) {
  final snackbar = SnackBar(
    content: Text(mensaje),
    duration: Duration(milliseconds: 1500),
  );
  key.currentState.showSnackBar(snackbar);
}

Widget ver(String mensaje) {
  return Container(
    padding: EdgeInsets.all(50),
    child: Column(children: [
      Icon(
        Icons.error_outline,
        color: Colors.red,
        size: 60,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16, left: 20),
        child: Text(
          mensaje,
          style: TextStyle(
              wordSpacing: 2, fontSize: 18, fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
      )
    ]),
  );
}
