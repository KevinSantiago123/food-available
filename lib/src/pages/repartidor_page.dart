import 'package:flutter/material.dart';

import 'package:food_available/src/bloc/provider.dart';
import 'package:food_available/src/models/producto_model.dart';

class RepartidorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductosRecolector();
    return Scaffold(
        appBar: AppBar(
          title: Text('Recolecciones Disponibles'),
        ),
        body: _crearListado(productosBloc));
  }

  Widget _crearListado(ProductosBloc productosBloc) {
    return StreamBuilder(
      stream: productosBloc.productosStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        /*if (snapshot.data == null) {
          Navigator.pushReplacementNamed(context, 'login');
        }*/

        if (snapshot.hasData) {
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: snapshot.data.length,
            itemBuilder: (context, i) =>
                _crearItem(context, productosBloc, snapshot.data[i]),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, ProductosBloc productosBloc,
      ProductoModel producto) {
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
                'Unidades: ${producto.cantidadUnidades} \nCaduca el: ${producto.fechaCaducidad} \n${producto.barrio} \n${producto.ciudad}'),
            subtitle: Text('Detalle ${producto.observacion}'),
            onTap: () => Navigator.pushNamed(context, 'producto_repartidor',
                arguments: producto),
          ),
        ],
      ),
    );
  }
}
