import 'package:flutter/material.dart';

import 'package:food_available/src/bloc/login_bloc.dart';
import 'package:food_available/src/bloc/provider.dart';
import 'package:food_available/src/models/producto_model.dart';
import 'package:food_available/src/models/usuario_model.dart';
import 'package:food_available/src/utils/util.dart';

class InteresadosPage extends StatefulWidget {
  @override
  _InteresadosPageState createState() => _InteresadosPageState();
}

class _InteresadosPageState extends State<InteresadosPage> {
  ProductoModel producto;
  LoginBloc loginBloc;
  ProductosBloc productosBloc;
  MensajesBloc mensajesBloc;
  Map dataMap;

  @override
  Widget build(BuildContext context) {
    dataMap = ModalRoute.of(context).settings.arguments;
    productosBloc = Provider.productosBloc(context);
    loginBloc = Provider.of(context);
    mensajesBloc = Provider.mensajesBloc(context);
    loginBloc.listarInteresados(dataMap['id_producto']);
    productosBloc.listarProducto(dataMap['id_producto']);
    Stream<ProductoModel> dataPro = productosBloc.productoStream;
    dataPro.listen((data) => producto = data);

    return Scaffold(
      appBar: AppBar(
        title: Text('Interesados page'),
      ),
      body: _crearListadoInteresados(),
    );
  }

  Widget _crearListadoInteresados() {
    return StreamBuilder(
      stream: loginBloc.interesadosStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<InteresadoModel>> snapshot) {
        if (snapshot.hasError) {
          return Container(
            child: Column(children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ]),
          );
        }

        if (snapshot.hasData) {
          if (snapshot.data.length == 0)
            return ver('Lo sentimos aun no hay interesados en tu donación');
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: snapshot.data.length,
            itemBuilder: (context, i) => _crearItem(context, snapshot.data[i]),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, InteresadoModel interesado) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              '${interesado.nombres}',
              style: TextStyle(color: Colors.blue[900], fontSize: 25.0),
            ),
          ),
          ListTile(
            title: Text(
              'Calificación: ${interesado.calificacion}',
              style: TextStyle(color: Colors.red[900], fontSize: 18.0),
            ),
            subtitle: Text('Correo: ${interesado.correo}'),
          ),
          RaisedButton.icon(
            color: Colors.deepPurple[600],
            textColor: Colors.white,
            label: Text('Elegir'),
            icon: Icon(Icons.auto_fix_high),
            onPressed: () => _submit(context, interesado),
          )
        ],
      ),
    );
  }

  void _submit(BuildContext context, InteresadoModel interesado) {
    producto.id = interesado.idProducto;
    producto.estado = 2;
    producto.idCorreoRepartidorAsignado = interesado.correo;
    print(producto.toJson());
    print(interesado.toJson());
    productosBloc.editarProducto(producto);
    mensajesBloc.confirmarDonacion(interesado, producto);
    Navigator.pushReplacementNamed(context, 'opciones');
  }
}
