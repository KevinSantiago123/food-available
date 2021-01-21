import 'package:flutter/material.dart';
import 'package:food_available/src/bloc/calificacion_bloc.dart';

import 'package:food_available/src/bloc/login_bloc.dart';
export 'package:food_available/src/bloc/login_bloc.dart';
import 'package:food_available/src/bloc/productos_bloc.dart';
export 'package:food_available/src/bloc/productos_bloc.dart';
import 'package:food_available/src/bloc/mensajes_bloc.dart';
export 'package:food_available/src/bloc/mensajes_bloc.dart';

class Provider extends InheritedWidget {
  final loginBloc = LoginBloc();
  final _productosBloc = new ProductosBloc();
  final _mensajesBloc = new MensajesBloc();
  final _calificacionBloc = new CalificacionBloc();
  static Provider _instancia;
  factory Provider({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new Provider._internal(key: key, child: child);
    }
    return _instancia;
  }
  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }

  static ProductosBloc productosBloc(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<Provider>()
        ._productosBloc;
  }

  static MensajesBloc mensajesBloc(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()._mensajesBloc;
  }

  static CalificacionBloc calificacionBloc(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<Provider>()
        ._calificacionBloc;
  }
}
