import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:food_available/src/models/usuario_model.dart';
import 'package:food_available/src/bloc/validators.dart';
import 'package:food_available/src/providers/usuario_provider.dart';

class LoginBloc with Validators {
  final _emailController = new BehaviorSubject<String>();
  final _passwordController = new BehaviorSubject<String>();
  final _usuarioController = new BehaviorSubject<List<UsuarioModel>>();
  final _cargandoUserController = new BehaviorSubject<bool>();
  final _usuarioProvider = new UsuarioProvider();

  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);

  Stream<List<UsuarioModel>> get usuarioStream => _usuarioController.stream;
  Stream<bool> get cargando => _cargandoUserController.stream;

  Stream<bool> get stateBotonStream =>
      Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  String get email => _emailController.value;
  String get password => _passwordController.value;

  void agregarUsuario(UsuarioModel usuario) async {
    _cargandoUserController.sink.add(true);
    await _usuarioProvider.crearDatosUsuario(usuario);
    _cargandoUserController.sink.add(false);
  }

  dispose() {
    _emailController?.close();
    _passwordController?.close();
    _usuarioController?.close();
    _cargandoUserController?.close();
  }
}
