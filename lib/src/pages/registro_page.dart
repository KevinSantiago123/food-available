import 'package:flutter/material.dart';

import 'package:food_available/src/bloc/provider.dart';
import 'package:food_available/src/models/usuario_model.dart';
import 'package:food_available/src/providers/usuario_provider.dart';
import 'package:food_available/src/utils/util.dart' as utils;

class RegistroPage extends StatefulWidget {
  @override
  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final formKey1 = GlobalKey<FormState>();
  final scaffoldKey1 = GlobalKey<ScaffoldState>();
  final usuarioProvider = new UsuarioProvider();
  UsuarioModel usuario = new UsuarioModel();
  bool _guardando = false;

  List<String> _tipoDocumento = ['C.C.', 'T.I', 'C.E.'];
  String _opcionSeleccionada = 'C.C.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey1,
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _loginForm(context),
        ],
      ),
    );
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.1),
      ),
    );
    final poster = Container(
      padding: EdgeInsets.only(top: 80.0),
      child: Column(
        children: <Widget>[
          Icon(Icons.food_bank, color: Colors.white, size: 100.0),
          SizedBox(
            height: 10.0,
            width: double.infinity,
          ),
          Text(
            'Food Available',
            style: TextStyle(color: Colors.white, fontSize: 25.0),
          )
        ],
      ),
    );
    final fondoMorado = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: <Color>[
          Color.fromRGBO(63, 63, 156, 1.0),
          Color.fromRGBO(28, 92, 233, 0.7),
          //Color.fromRGBO(90, 70, 178, 1.0),
        ],
      )),
    );

    return Stack(
      children: <Widget>[
        fondoMorado,
        Positioned(top: 70.0, left: 30.0, child: circulo),
        Positioned(top: -40.0, right: -30.0, child: circulo),
        Positioned(top: 110.0, right: 30.0, child: circulo),
        poster
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(child: Container(height: 190.0)),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Form(
              key: formKey1,
              child: Column(
                children: <Widget>[
                  Text('Crear cuenta', style: TextStyle(fontSize: 20.0)),
                  SizedBox(height: 10.0),
                  _crearListaDesplegable(),
                  SizedBox(height: 10.0),
                  _textoNumeroDoc(),
                  SizedBox(height: 10.0),
                  _textoName(),
                  SizedBox(height: 10.0),
                  _textoApellido1(),
                  SizedBox(height: 10.0),
                  _textoApellido2(),
                  SizedBox(height: 10.0),
                  _textoEmail(bloc),
                  SizedBox(height: 10.0),
                  _textoPassword(bloc),
                  SizedBox(height: 30.0),
                  _crearBoton(bloc, 'Registrate'),
                ],
              ),
            ),
          ),
          _textoVolver(context),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> getOpciones() {
    List<DropdownMenuItem<String>> lista = new List();

    _tipoDocumento.forEach((tipoDoc) {
      lista.add(DropdownMenuItem(child: Text(tipoDoc), value: tipoDoc));
    });
    return lista;
  }

  Widget _crearListaDesplegable() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.select_all,
            color: Colors.deepPurple[300],
          ),
          SizedBox(width: 30.0),
          Expanded(
            child: DropdownButton(
              value: _opcionSeleccionada,
              items: getOpciones(),
              onChanged: (opt) => setState(() {
                _opcionSeleccionada = opt;
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textoNumeroDoc() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        //initialValue: usuario.numeroDocumento.toString(),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          icon: Icon(
            Icons.apps,
            color: Colors.deepPurple[300],
          ),
          labelText: 'Número de documento',
        ),
        onSaved: (value) => usuario.numeroDocumento = int.parse(value),
        validator: (value) {
          if (utils.isNumeric(value)) {
            return null;
          }
          {
            return 'Sólo números';
          }
        },
      ),
    );
  }

  Widget _textoName() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        //initialValue: usuario.nombres,
        textCapitalization: TextCapitalization.sentences,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          icon: Icon(
            Icons.person_add,
            color: Colors.deepPurple[300],
          ),
          labelText: 'Nombres',
        ),
        onSaved: (value) => usuario.nombres = value,
        validator: (value) {
          if (value.length < 3) {
            return 'Ingrese el nombre por favor';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _textoApellido1() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          icon: Icon(
            Icons.person_add_alt,
            color: Colors.deepPurple[300],
          ),
          labelText: 'Primer apellido',
        ),
        onSaved: (value) => usuario.primerApellido = value,
        validator: (value) {
          if (value.length < 3) {
            return 'Ingrese el apellido por favor';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _textoApellido2() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          icon: Icon(
            Icons.person_add_alt,
            color: Colors.deepPurple[300],
          ),
          labelText: 'Segundo apellido',
        ),
        onSaved: (value) => usuario.segundoApellido = value,
      ),
    );
  }

  Widget _textoEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.alternate_email,
                  color: Colors.deepPurple[300],
                ),
                hintText: 'ejemplo@correo.com',
                labelText: 'Correo electrónico',
                counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeEmail,
            onSaved: (value) => usuario.correo = value,
          ),
        );
      },
    );
  }

  Widget _textoPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.lock_outline,
                  color: Colors.deepPurple[300],
                ),
                labelText: 'Contraseña',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  Widget _crearBoton(LoginBloc bloc, String texto) {
    return StreamBuilder(
      stream: bloc.stateBotonStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 13.0),
              child: Text(texto),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            color: Colors.deepPurple,
            textColor: Colors.white,
            onPressed:
                snapshot.hasData ? () => _registro(context, bloc) : null);
      },
    );
  }

  _registro(BuildContext context, LoginBloc bloc) async {
    if (!formKey1.currentState.validate()) return;
    formKey1.currentState.save();

    if (_opcionSeleccionada != null)
      usuario.tipoDocumento = _opcionSeleccionada;
    final info = await usuarioProvider.nuevoUsuario(bloc.email, bloc.password);

    if (info['ok']) {
      bloc.agregarUsuario(usuario);
      utils.mostrarSnackbar('Se registro satisfactoriamente', scaffoldKey1);
      Navigator.pushReplacementNamed(context, 'opciones');
    } else {
      utils.mostrarAlerta(context, info['mensaje']);
    }
  }

  Widget _textoVolver(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('¿Ya tienes cuenta?'),
        TextButton(
          child: Text(
            'Login',
            style: TextStyle(
              color: Colors.deepPurple[300],
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
          onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
        ),
      ],
    );
  }
}
