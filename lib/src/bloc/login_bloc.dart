import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:food_available/src/models/usuario_model.dart';
import 'package:food_available/src/bloc/validators.dart';
import 'package:food_available/src/providers/usuario_provider.dart';

class LoginBloc with Validators {
  final _emailController = new BehaviorSubject<String>();
  final _passwordController = new BehaviorSubject<String>();
  final _usuarioController = new BehaviorSubject<UsuarioModel>();
  final _usuario2Controller = new BehaviorSubject<UsuarioModel>();
  final _cargandoUserController = new BehaviorSubject<bool>();
  final _interesadosController = new BehaviorSubject<List<InteresadoModel>>();
  final _usuarioProvider = new UsuarioProvider();

  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);

  Stream<UsuarioModel> get usuarioStream => _usuarioController.stream;
  Stream<UsuarioModel> get usuario2Stream => _usuario2Controller.stream;
  Stream<bool> get cargando => _cargandoUserController.stream;

  Stream<bool> get stateBotonStream =>
      Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);

  Stream<List<InteresadoModel>> get interesadosStream =>
      _interesadosController.stream;

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  String get email => _emailController.value;
  String get password => _passwordController.value;

  void listarUsuario() async {
    final usuario = await _usuarioProvider.buscarInfoUsuario();
    _usuarioController.sink.add(usuario);
  }

  void listarUsuarioCorreo(String correo) async {
    final usuarioC = await _usuarioProvider.buscarInfoUsuarioCorreo(correo);
    _usuario2Controller.sink.add(usuarioC);
  }

  void agregarUsuario(UsuarioModel usuario) async {
    _cargandoUserController.sink.add(true);
    await _usuarioProvider.crearDatosUsuario(usuario);
    _cargandoUserController.sink.add(false);
  }

  void agregarInteresado(String idProducto, String correo, String nombres,
      int calificacion, String tokenCel) async {
    _cargandoUserController.sink.add(true);
    await _usuarioProvider.crearUsuarioInteresado(
        idProducto, correo, nombres, calificacion, tokenCel);
    _cargandoUserController.sink.add(false);
  }

  void listarInteresados(String idProducto) async {
    final interesados = await _usuarioProvider.listarInteresados(idProducto);
    _interesadosController.sink.add(interesados);
  }

  dispose() {
    _emailController?.close();
    _passwordController?.close();
    _usuarioController?.close();
    _usuario2Controller?.close();
    _cargandoUserController?.close();
    _interesadosController?.close();
  }
}
