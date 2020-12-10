import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:food_available/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:food_available/src/bloc/provider.dart';
import 'package:food_available/src/models/producto_model.dart';
import 'package:food_available/src/utils/util.dart' as utils;

class ProductoRepartidorPage extends StatefulWidget {
  @override
  _ProductoRepartidorPageState createState() => _ProductoRepartidorPageState();
}

class _ProductoRepartidorPageState extends State<ProductoRepartidorPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductosBloc productosBloc;
  PreferenciasUsuario pref;
  ProductoModel producto = new ProductoModel();
  TextEditingController _inputFieldDateController = new TextEditingController();
  File foto;
  bool _guardando = false;

  @override
  Widget build(BuildContext context) {
    productosBloc = Provider.productosBloc(context);
    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    pref = new PreferenciasUsuario();
    if (prodData != null) {
      producto = prodData;
      _inputFieldDateController.text = producto.fechaCaducidad;
    }
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
                _mostrarTelefono(),
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

  Widget _crearDireccion() {
    return TextFormField(
      readOnly: true,
      initialValue: producto.direccion,
      decoration: InputDecoration(
        labelText: 'Dirección',
        icon: Icon(Icons.add_location, color: Colors.deepPurple[700]),
      ),
    );
  }

  Widget _mostrarFecha(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: _inputFieldDateController,
      decoration: InputDecoration(
        hintText: 'Fecha de nacimiento',
        labelText: 'Fecha de nacimiento',
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

  Widget _crearBarrio() {
    return TextFormField(
      readOnly: true,
      initialValue: producto.barrio,
      decoration: InputDecoration(
        labelText: 'Barrio',
        icon: Icon(Icons.confirmation_num, color: Colors.deepPurple[700]),
      ),
    );
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
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.green[600],
      textColor: Colors.white,
      label: Text('Apartar Producto'),
      icon: Icon(Icons.send),
      onPressed: (_guardando) ? null : _submit,
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    setState(() {
      _guardando = true;
    });
    producto.estado = 3;
    producto.idCorreoRepartidor = pref.correo;
    productosBloc.editarProducto(producto);
    setState(() {
      _guardando = false;
    });
    mostrarSnackbar('Se ha apartado la donación con exito');
    Navigator.pushReplacementNamed(context, 'mapa');
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 2000),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
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
