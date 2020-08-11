import 'dart:convert';

import 'package:formvalidation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {
  final String _firebaseToken = 'AIzaSyD1IgPamjOigSGci_oAaoTM9Q8cdqg1xx0';
  final _prefe = new PreferenciasUsuario();

  //PARA HACER UNA AUTENTICACION POR PASSWORD
  Future<Map<String, dynamic>> login({String email, String password}) async {
    final authData = {
      'email': email,
      'password': password,

      ///para pedir que nos retornen el token
      'returnSecureToken': true
    };
    final respuesta = await http.post(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken",
        body: json.encode(authData));

    Map<String, dynamic> decodeRespuesta = json.decode(respuesta.body);
    print(decodeRespuesta);
    if (decodeRespuesta.containsKey('idToken')) {
      _prefe.token = decodeRespuesta['idToken'];
      return {'ok': true, 'token': decodeRespuesta['idToken']};
    } else {
      return {'ok': false, 'mensaje': decodeRespuesta['error']['message']};
    }
  }

  ///PARA CREAR UN NUEVO USUARIO
  Future<Map<String, dynamic>> nuevoUsuario(
      {String email, String password}) async {
    final authData = {
      'email': email,
      'password': password,

      ///para pedir que nos retornen el token
      'returnSecureToken': true
    };
    final respuesta = await http.post(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken",
        body: json.encode(authData));

    Map<String, dynamic> decodeRespuesta = json.decode(respuesta.body);
    //print(decodeRespuesta);
    if (decodeRespuesta.containsKey('idToken')) {
      _prefe.token = decodeRespuesta['idToken'];
      return {'ok': true, 'token': decodeRespuesta['idToken']};
    } else {
      return {'ok': false, 'mensaje': decodeRespuesta['error']['menssage']};
    }
  }
}
