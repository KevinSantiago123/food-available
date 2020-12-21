import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:food_available/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:food_available/src/bloc/provider.dart';
import 'package:food_available/src/models/producto_model.dart';
import 'package:food_available/src/utils/util.dart' as utils;

class ProductoDonadorPage extends StatefulWidget {
  @override
  _ProductoDonadorPageState createState() => _ProductoDonadorPageState();
}

class _ProductoDonadorPageState extends State<ProductoDonadorPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductosBloc productosBloc;
  MensajesBloc mensajesBloc;
  PreferenciasUsuario pref;
  ProductoModel producto = new ProductoModel();

  bool _guardando = false;
  String _fecha = '';
  TextEditingController _inputFieldDateController = new TextEditingController();
  File foto;
  String tokenCel;

  @override
  Widget build(BuildContext context) {
    productosBloc = Provider.productosBloc(context);
    mensajesBloc = Provider.mensajesBloc(context);
    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    pref = new PreferenciasUsuario();
    if (prodData != null) {
      producto = prodData;
      _inputFieldDateController.text = producto.fechaCaducidad;
    } else {
      mensajesBloc.generarTokenCel();
      Stream<String> data = mensajesBloc.tokenCelStream;
      data.listen((data) => tokenCel = data);
    }
    Map<String, dynamic> dataMap = {'id_producto': producto.id};
    //print('soy el token cel: ' + tokenCel.toString());
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.assignment_outlined),
            onPressed: () =>
                Navigator.pushNamed(context, 'interesados', arguments: dataMap),
          ),
          IconButton(
            icon: Icon(Icons.face),
            onPressed: () => Navigator.pushNamed(context, 'calificaciones'),
          ),
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
                _crearNombre(),
                _crearCantidad(),
                _crearFecha(context),
                _crearDireccion(),
                _crearTelefono(),
                _crearBarrio(),
                _crearCiudad(),
                _crearDepartamento(),
                _crearObservacion(),
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

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.nombre,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: 'Donación',
        icon: Icon(Icons.add_shopping_cart, color: Colors.deepPurple[700]),
      ),
      onSaved: (value) => producto.nombre = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese el nombre de la donación';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearCantidad() {
    return TextFormField(
      initialValue: producto.cantidadUnidades.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Cantidad Unidades',
        icon: Icon(Icons.sort_outlined, color: Colors.deepPurple[700]),
      ),
      onSaved: (value) => producto.cantidadUnidades = double.parse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        }
        {
          return 'Sólo números';
        }
      },
    );
  }

  Widget _crearDireccion() {
    return TextFormField(
      initialValue: producto.direccion,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Dirección',
        icon: Icon(Icons.add_location, color: Colors.deepPurple[700]),
      ),
      onSaved: (value) => producto.direccion = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese la dirección de la donación';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearTelefono() {
    return TextFormField(
      initialValue: producto.telefono.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Telefono',
        icon: Icon(Icons.smartphone, color: Colors.deepPurple[700]),
      ),
      onSaved: (value) => producto.telefono = int.parse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        }
        {
          return 'Sólo números';
        }
      },
    );
  }

  Widget _crearFecha(BuildContext context) {
    return TextFormField(
      //initialValue: producto.fechaCaducidad,
      enableInteractiveSelection: false,
      controller: _inputFieldDateController,
      //cursorColor: Colors.red,
      decoration: InputDecoration(
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        hintText: 'Fecha de caducidad',
        labelText: 'Fecha de caducidad',
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
          producto.fechaCaducidad = _fecha;
        },
      );
    }
  }

  Widget _crearBarrio() {
    return TextFormField(
      initialValue: producto.barrio,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Barrio',
        icon: Icon(Icons.confirmation_num, color: Colors.deepPurple[700]),
      ),
      onSaved: (value) => producto.barrio = value,
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
      initialValue: producto.ciudad,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Ciudad',
        icon: Icon(Icons.location_city, color: Colors.deepPurple[700]),
      ),
      onSaved: (value) => producto.ciudad = value,
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
      initialValue: producto.departamento,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Departamento',
        icon: Icon(Icons.add_location, color: Colors.deepPurple[700]),
      ),
      onSaved: (value) => producto.departamento = value,
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
      initialValue: producto.observacion,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Observación',
        icon: Icon(Icons.text_snippet, color: Colors.deepPurple[700]),
      ),
      onSaved: (value) => producto.observacion = value,
    );
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.deepPurple[600],
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: (_guardando) ? null : _submit,
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    setState(() {
      _guardando = true;
    });
    if (producto.estado == null) producto.estado = 1;
    if (producto.idCorreo == null) {
      producto.idCorreo = pref.correo;
      producto.idCorreoRepartidor = [pref.correo];
    }

    if (foto != null) {
      producto.fotoUrl = await productosBloc.subirFoto(foto);
    }

    if (producto.id == null) {
      producto.tokenCel = tokenCel;
      productosBloc.agregarProducto(producto);
    } else {
      productosBloc.editarProducto(producto);
    }
    setState(() {
      _guardando = false;
    });
    utils.mostrarSnackbar('Registro guardado', scaffoldKey);
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
      producto.fotoUrl = null;
    }
    setState(() {});
  }
}
