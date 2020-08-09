import 'package:flutter/material.dart';

bool isNumeric(String s) {
  if (s.isEmpty) {
    return false;
  }
  final n = num.tryParse(s);

  if (n == null) {
    return false;
  }
  return true;
}

mostrarAlerta({BuildContext context, String mensaje}) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: new Text("informacion incorrecta"),
          content: new Text(mensaje),
          actions: <Widget>[
            FlatButton(
              child: Text("ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}
