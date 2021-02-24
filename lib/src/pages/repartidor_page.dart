import 'package:flutter/material.dart';

import 'package:food_available/src/bloc/provider.dart';
import 'package:food_available/src/models/producto_model.dart';
import 'package:food_available/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:food_available/src/utils/util.dart';

class RepartidorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productosBloc = Provider.productosBloc(context);
    final pref = new PreferenciasUsuario();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: 'Disponibles'),
                Tab(text: 'Mis recolecciones'),
              ],
            ),
            title: Text('Recolecciones'),
            toolbarOpacity: 0.6,
          ),
          body: TabBarView(
            children: [
              _crearListadoDisponibles(context, productosBloc, pref),
              _crearListadoMisRecolecciones(context, productosBloc, pref)
            ],
          )
          //body: _crearListado(productosBloc, pref),
          ),
    );
  }

  Widget _crearListadoDisponibles(BuildContext context,
      ProductosBloc productosBloc, PreferenciasUsuario pref) {
    productosBloc.cargarProductosRecolector();
    return StreamBuilder(
      stream: productosBloc.productosStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: snapshot.data.length,
            itemBuilder: (context, i) {
              /*if (snapshot.data[i].idCorreoRepartidor == null) {
                return _crearItem(context, productosBloc, snapshot.data[i]);
              }*/
              final temp = snapshot.data[i].idCorreoRepartidor.firstWhere(
                  (item) => item == pref.correo,
                  orElse: () => 'None!');
              if (temp != pref.correo) {
                return _crearItem(context, productosBloc, snapshot.data[i],
                    'producto_repartidor', 1);
              } else {
                return Container();
              }
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearListadoMisRecolecciones(BuildContext context,
      ProductosBloc productosBloc, PreferenciasUsuario pref) {
    productosBloc.cargarMisRecolecciones(2);
    return StreamBuilder(
      stream: productosBloc.misRecoleccionesStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0)
            return ver(
                'Lo sentimos, aun no te han aprobado donaciones, intenta comunicarte con la persona de la donación');

          //Navigator.pushReplacementNamed(context, 'login');
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: snapshot.data.length,
            itemBuilder: (context, i) {
              int contador = 0;
              if (snapshot.data[i].idCorreoRepartidorAsignado == pref.correo) {
                return _crearItem(
                    context, productosBloc, snapshot.data[i], 'mapa', 2);
              } else {
                return Container();
                /*contador++;
                if (contador == 0) {
                  return ver(
                      'Lo sentimos, aun no te han aprobado donaciones, intenta comunicarte con la persona de la donación');
                } else {
                  return Container();
                }*/
              }
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, ProductosBloc productosBloc,
      ProductoModel producto, String ruta, int decision) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        children: <Widget>[
          ListTile(
              title: Text(
            '${producto.nombre}',
            style: TextStyle(color: Colors.blue[900], fontSize: 25.0),
          )),
          (producto.fotoUrl == null)
              ? Image(image: AssetImage('assets/no-image.png'))
              : FadeInImage(
                  image: NetworkImage(producto.fotoUrl),
                  placeholder: AssetImage('assets/jar-loading.gif'),
                  height: 200.0,
                  width: 300.0,
                  fit: BoxFit.cover,
                ),
          ListTile(
              title: Text(
                  'Unidades: ${producto.cantidadUnidades} \nVence: ${producto.fechaCaducidad} \n${producto.barrio} \n${producto.ciudad}'),
              subtitle: Text('Detalle ${producto.observacion}'),
              onTap: () {
                if (decision == 1) {
                  Navigator.pushNamed(context, ruta, arguments: producto);
                } else if (decision == 2) {
                  Map data = {
                    'nombre': producto.nombre,
                    'token_cel': producto.tokenCel,
                    'correo': producto.idCorreo,
                    'cx': producto.cx,
                    'cy': producto.cy,
                    'id_producto': producto.id
                  };
                  Navigator.pushNamed(context, ruta, arguments: data);
                }
              }),
        ],
      ),
    );
  }

  _mostrarAlert(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            title: Text('Lo Sentimos'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Aun no hay nadie interesado en tu donación'),
                FlutterLogo(size: 100.0)
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'producto_donador');
                },
              )
            ],
          );
        });
  }
}
