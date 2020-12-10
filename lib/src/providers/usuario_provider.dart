import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:food_available/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:food_available/src/models/usuario_model.dart';

class UsuarioProvider {
  final String _url = 'https://task-ulibre.firebaseio.com';
  final String _firebaseToken = 'AIzaSyBwBXIdT92VWQ7LcXyBh9IPM4LdLiVahxY';
  final _pref = new PreferenciasUsuario();
  final productosModel = new UsuarioModel();
  String _mensaje = '';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
        body: json.encode(authData));
    Map<String, dynamic> decodeResp = json.decode(resp.body);
    //print(decodeResp);

    if (decodeResp.containsKey('idToken')) {
      _pref.token = decodeResp['idToken'];
      _pref.correo = email;
      return {'ok': true, 'token': decodeResp['idToken']};
    } else {
      if (decodeResp['error']['message'] == 'EMAIL_NOT_FOUND') {
        _mensaje = 'correo no encontrado en la base de datos.';
      } else if (decodeResp['error']['message'] == 'INVALID_PASSWORD') {
        _mensaje = 'contraseña invalida.';
      } else {
        _mensaje = decodeResp['error']['message'];
      }
      return {'ok': false, 'mensaje': _mensaje};
    }
  }

  Future<Map<String, dynamic>> nuevoUsuario(
      String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
        body: json.encode(authData));

    Map<String, dynamic> decodeResp = json.decode(resp.body);
    //print(decodeResp);

    if (decodeResp.containsKey('idToken')) {
      _pref.token = decodeResp['idToken'];
      _pref.correo = email;
      return {'ok': true, 'token': decodeResp['idToken']};
    } else {
      if (decodeResp['error']['message'] == 'EMAIL_EXISTS') {
        _mensaje = 'El correo ya existe en la base de datos.';
      } else {
        _mensaje = decodeResp['error']['message'];
      }
      return {'ok': false, 'mensaje': _mensaje};
    }
  }

  Future<bool> crearDatosUsuario(UsuarioModel usuario) async {
    final url = '$_url/usuarios.json?auth=${_pref.token}';
    final resp = await http.post(url, body: usuarioModelToJson(usuario));
    final decodedData = json.decode(resp.body);
    //print(decodedData);
    return true;
  }
}
