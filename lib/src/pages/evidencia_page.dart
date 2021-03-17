import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:food_available/src/models/producto_entregado_model.dart';
import 'package:food_available/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:food_available/src/bloc/provider.dart';
import 'package:food_available/src/models/producto_model.dart';

class EvidenciaPage extends StatefulWidget {
  @override
  _EvidenciaPageState createState() => _EvidenciaPageState();
}

class _EvidenciaPageState extends State<EvidenciaPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductosBloc productosBloc;
  PreferenciasUsuario pref;
  ProductoEntregadoModel productoEntregado = new ProductoEntregadoModel();
  CoordenadasModel coordenadas = new CoordenadasModel();
  bool _guardando = false;
  String _fecha = '';
  TextEditingController _inputFieldDateController = new TextEditingController();
  File foto;
  int contador = 0;

  @override
  Widget build(BuildContext context) {
    if (contador == 0) {
      productosBloc = Provider.productosBloc(context);
      productosBloc.cargarEvidenciaProducto(2);
      pref = new PreferenciasUsuario();
      Stream<ProductoEntregadoModel> data =
          productosBloc.productoEntregadoStream;
      data.listen((data) => productoEntregado = data);
      contador++;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Evidencia'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
            //onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
            //onPressed: () {},
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
                _mostrarFoto(),
                Divider(height: 15.0),
                _crearFecha(context),
                _crearDireccion(),
                _crearBarrio(),
                _crearCiudad(),
                _crearDepartamento(),
                _crearObservacion(),
                Divider(height: 15.0),
                _crearBoton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearDireccion() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Dirección',
        icon: Icon(Icons.add_location, color: Colors.deepPurple[700]),
      ),
      onSaved: (value) =>
          productoEntregado.direccionEntrega = value.toUpperCase(),
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese la dirección de la entrega';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearFecha(BuildContext context) {
    return TextFormField(
      enableInteractiveSelection: false,
      controller: _inputFieldDateController,
      //cursorColor: Colors.red,
      decoration: InputDecoration(
        hintText: 'Fecha de entrega',
        labelText: 'Fecha de entrega',
        suffixIcon:
            Icon(Icons.perm_contact_calendar, color: Colors.deepPurple[700]),
        icon: Icon(Icons.calendar_today, color: Colors.deepPurple[700]),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectDate(context);
      },
    );
  }

  _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2010),
        lastDate: new DateTime(2025),
        locale: Locale('es', 'ES'));
    if (picked != null) {
      setState(
        () {
          String _day = picked.day.toString();
          _day.length == 1 ? _day = '0' + _day : _day = _day;

          _fecha = (picked.year.toString() +
              '-' +
              picked.month.toString() +
              '-' +
              _day);
          _inputFieldDateController.text = _fecha;
          productoEntregado.fechaEntrega = _fecha;
        },
      );
    }
  }

  Widget _crearBarrio() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Barrio',
        icon: Icon(Icons.confirmation_num, color: Colors.deepPurple[700]),
      ),
      onSaved: (value) => productoEntregado.barrioEntrega = value.toUpperCase(),
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese el barrio';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearCiudad() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Ciudad',
        icon: Icon(Icons.location_city, color: Colors.deepPurple[700]),
      ),
      onSaved: (value) => productoEntregado.ciudadEntrega = value.toUpperCase(),
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese el barrio';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearDepartamento() {
    return TextFormField(
      //initialValue: snapshot.data.departamento,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Departamento',
        icon: Icon(Icons.add_location, color: Colors.deepPurple[700]),
      ),
      onSaved: (value) =>
          productoEntregado.departamentoEntrega = value.toUpperCase(),
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese el departamento';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearObservacion() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Observación',
        icon: Icon(Icons.text_snippet, color: Colors.deepPurple[700]),
      ),
      onSaved: (value) => productoEntregado.detalleEntrega = value,
    );
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.green[600],
      textColor: Colors.white,
      label: Text('Cargar Evidencia'),
      icon: Icon(Icons.cloud),
      onPressed: (_guardando) ? null : _submit,
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    setState(() {
      _guardando = true;
    });
    coordenadas = await productosBloc.obtenerCoordenadas2(
        productoEntregado.direccionEntrega,
        productoEntregado.barrioEntrega,
        productoEntregado.ciudadEntrega,
        productoEntregado.departamentoEntrega);
    productoEntregado.estado = 3;
    productoEntregado.cxEntrega = coordenadas.cx;
    productoEntregado.cyEntrega = coordenadas.cy;

    if (foto != null) {
      productoEntregado.fotoUrlEntrega = await productosBloc.subirFoto(foto);
    }
    productosBloc.agregarProductoEntregado(productoEntregado);
    productosBloc.borrarProducto(productoEntregado.id);
    setState(() {
      _guardando = false;
    });
    //mostrarSnackbar('Se cargo la evidencia exitosamente Exitosamente');
    Navigator.pushReplacementNamed(context, 'opciones');
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _mostrarFoto() {
    if (productoEntregado.fotoUrlEntrega != null) {
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'),
        image: NetworkImage(productoEntregado.fotoUrlEntrega),
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

  _seleccionarFoto() async {
    _procesarFoto(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarFoto(ImageSource.camera);
  }

  _procesarFoto(ImageSource origen) async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.getImage(
      source: origen,
    );
    foto = File(pickedFile.path);
    if (foto != null) {
      productoEntregado.fotoUrlEntrega = null;
    }
    setState(() {});
  }
}
