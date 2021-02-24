import 'package:flutter/material.dart';

import 'package:food_available/src/models/usuario_model.dart';
import 'package:food_available/src/bloc/provider.dart';
import 'package:food_available/src/utils/util.dart' as utils;

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> _tipoDocumento = ['C.C.', 'T.I', 'C.E.'];
  String _opcionSeleccionada = 'C.C.';
  UsuarioModel usuario;
  LoginBloc loginBloc;
  bool _guardando = false;

  @override
  Widget build(BuildContext context) {
    usuario = new UsuarioModel();
    loginBloc = Provider.of(context);
    loginBloc.listarUsuario();
    Stream<UsuarioModel> dataUsuario = loginBloc.usuarioStream;
    dataUsuario.listen((data) => usuario = data);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Mi perfil'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.meeting_room_sharp,
              color: Colors.grey[800],
            ),
            onPressed: () => Navigator.pushNamed(context, 'acerca'),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Divider(height: 50),
                _textoEmail(),
                Divider(height: 50),
                _crearListaDesplegable(),
                _textoNumeroDoc(),
                _textoName(),
                _textoApellido1(),
                _textoApellido2(),
                Divider(height: 50),
                _crearBoton('Actualizar')
              ],
            ),
          ),
        ),
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
    return StreamBuilder(
        stream: loginBloc.usuarioStream,
        builder: (BuildContext context, AsyncSnapshot<UsuarioModel> snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                initialValue: snapshot.data.numeroDocumento.toString(),
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
          } else {
            return Center(child: LinearProgressIndicator());
          }
        });
  }

  Widget _textoName() {
    return StreamBuilder(
      stream: loginBloc.usuarioStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              initialValue: snapshot.data.nombres,
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
        } else {
          return Center(child: LinearProgressIndicator());
        }
      },
    );
  }

  Widget _textoApellido1() {
    return StreamBuilder(
      stream: loginBloc.usuarioStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              initialValue: snapshot.data.primerApellido,
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
        } else {
          return Center(child: LinearProgressIndicator());
        }
      },
    );
  }

  Widget _textoApellido2() {
    return StreamBuilder(
      stream: loginBloc.usuarioStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              initialValue: snapshot.data.segundoApellido,
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
        } else {
          return Center(child: LinearProgressIndicator());
        }
      },
    );

    /*if (snapshot.hasData) {
          } else {
            return Center(child: CircularProgressIndicator());
          }*/
  }

  Widget _textoEmail() {
    return StreamBuilder(
      stream: loginBloc.usuarioStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              snapshot.data.correo.toString(),
              style: TextStyle(color: Colors.deepPurple, fontSize: 25),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearBoton(String texto) {
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 14.0),
        child: Text(
          texto,
          style: TextStyle(fontSize: 16),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      color: Colors.deepPurple,
      textColor: Colors.white,
      onPressed: _registro,
    );
  }

  _registro() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    setState(() {
      _guardando = true;
    });
    //print(usuario.toJson());
    loginBloc.actualizarUsuario(usuario);
    setState(() {
      _guardando = false;
    });
    utils.mostrarSnackbar('Datos actualizados', scaffoldKey);
    Navigator.pushReplacementNamed(context, 'opciones');
  }
}
