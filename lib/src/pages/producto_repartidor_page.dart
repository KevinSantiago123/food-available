import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_available/src/models/usuario_model.dart';

import 'package:food_available/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:food_available/src/bloc/provider.dart';
import 'package:food_available/src/models/producto_model.dart';
import 'package:food_available/src/utils/util.dart';

class ProductoRepartidorPage extends StatefulWidget {
  @override
  _ProductoRepartidorPageState createState() => _ProductoRepartidorPageState();
}

class _ProductoRepartidorPageState extends State<ProductoRepartidorPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductosBloc productosBloc;
  LoginBloc loginBloc;
  PreferenciasUsuario pref;
  MensajesBloc mensajesBloc;
  ProductoModel producto;
  UsuarioModel usuario;
  UsuarioModel usuarioDonador;
  TextEditingController _inputFieldDateController = new TextEditingController();
  File foto;
  bool _guardando = false;
  String tokenInteresado;

  @override
  Widget build(BuildContext context) {
    loginBloc = Provider.of(context);
    productosBloc = Provider.productosBloc(context);
    mensajesBloc = Provider.mensajesBloc(context);
    producto = ModalRoute.of(context).settings.arguments;
    pref = new PreferenciasUsuario();
    loginBloc.listarUsuario();
    Stream<UsuarioModel> dataUsuario = loginBloc.usuarioStream;
    dataUsuario.listen((data) => usuario = data);
    mensajesBloc.generarTokenCel();
    Stream<String> data = mensajesBloc.tokenCelStream;
    data.listen((data) => tokenInteresado = data);
    _inputFieldDateController.text = producto.fechaCaducidad;
    loginBloc.listarUsuarioCorreo(producto.idCorreo);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Detalle donación'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _mostrarNombre(),
                _mostrarCantidad(),
                _mostrarFecha(context),
                _crearNombreDonador(),
                _mostrarTelefono(),
                _mostrarDireccion(),
                _mostrarBarrio(),
                _mostrarCiudad(),
                _mostrarDepartamento(),
                _mostrarObservacion(),
                Divider(height: 15.0),
                //SizedBox(height: 15.0),
                _crearBoton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _mostrarNombre() {
    return TextFormField(
      readOnly: true,
      initialValue: producto.nombre,
      decoration: InputDecoration(
        labelText: 'Donación',
        icon: Icon(Icons.add_shopping_cart, color: Colors.deepPurple[700]),
      ),
    );
  }

  Widget _mostrarCantidad() {
    return TextFormField(
      readOnly: true,
      initialValue: producto.cantidadUnidades.toString(),
      decoration: InputDecoration(
        labelText: 'Cantidad Unidades',
        icon: Icon(Icons.sort_outlined, color: Colors.deepPurple[700]),
      ),
    );
  }

  Widget _crearNombreDonador() {
    return StreamBuilder(
        stream: loginBloc.usuario2Stream,
        builder: (BuildContext context, AsyncSnapshot<UsuarioModel> snapshot) {
          if (snapshot.hasData) {
            return TextFormField(
              readOnly: true,
              initialValue: snapshot.data.nombres,
              decoration: InputDecoration(
                labelText: 'Nombres donador',
                icon: Icon(Icons.person, color: Colors.deepPurple[700]),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _mostrarFecha(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: _inputFieldDateController,
      decoration: InputDecoration(
        hintText: 'Fecha de caducidad',
        labelText: 'Fecha de caducidad',
        suffixIcon:
            Icon(Icons.perm_contact_calendar, color: Colors.deepPurple[700]),
        icon: Icon(Icons.calendar_today, color: Colors.deepPurple[700]),
      ),
    );
  }

  Widget _mostrarTelefono() {
    return TextFormField(
      readOnly: true,
      initialValue: producto.telefono.toString(),
      decoration: InputDecoration(
        labelText: 'Telefono de contacto',
        icon: Icon(Icons.sort_outlined, color: Colors.deepPurple[700]),
      ),
    );
  }

  Widget _mostrarDireccion() {
    if (producto.id == '1') {
      return TextFormField(
        readOnly: true,
        initialValue: producto.direccion,
        decoration: InputDecoration(
          labelText: 'Direccion',
          icon: Icon(Icons.add_location, color: Colors.deepPurple[700]),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _mostrarBarrio() {
    if (producto.id == '1') {
      return TextFormField(
        readOnly: true,
        initialValue: producto.barrio,
        decoration: InputDecoration(
          labelText: 'Barrio',
          icon: Icon(Icons.confirmation_num, color: Colors.deepPurple[700]),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _mostrarCiudad() {
    return TextFormField(
      readOnly: true,
      initialValue: producto.ciudad,
      decoration: InputDecoration(
        labelText: 'Ciudad',
        icon: Icon(Icons.location_city, color: Colors.deepPurple[700]),
      ),
    );
  }

  Widget _mostrarDepartamento() {
    return TextFormField(
      readOnly: true,
      initialValue: producto.departamento,
      decoration: InputDecoration(
        labelText: 'Departamento',
        icon: Icon(Icons.location_city, color: Colors.deepPurple[700]),
      ),
    );
  }

  Widget _mostrarObservacion() {
    return TextFormField(
      readOnly: true,
      initialValue: producto.observacion,
      decoration: InputDecoration(
        labelText: 'Observación',
        icon: Icon(Icons.text_snippet, color: Colors.deepPurple[700]),
      ),
    );
  }

  Widget _crearBoton() {
    print(producto.id);
    if (producto.id == '1') {
      return Container();
    } else {
      return RaisedButton.icon(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        color: Colors.green[600],
        textColor: Colors.white,
        label: Text('Apartar Producto'),
        icon: Icon(Icons.send),
        onPressed: (_guardando) ? null : _submit,
      );
    }
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    setState(() {
      _guardando = true;
    });
    //print(producto.toJson());
    mensajesBloc.apartarProducto(usuario, producto);
    producto.idCorreoRepartidor.add(pref.correo);
    loginBloc.agregarInteresado(producto.id, usuario.correo, usuario.nombres,
        usuario.calificacion, tokenInteresado);
    productosBloc.editarProducto(producto);
    setState(() {
      _guardando = false;
    });
    mostrarSnackbar('Se ha apartado la donación con exito', scaffoldKey);
    Navigator.pushReplacementNamed(context, 'opciones');
  }

  Widget _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'),
        image: NetworkImage(producto.fotoUrl),
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {
      if (foto != null) {
        return Image.file(
          foto,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }
}
