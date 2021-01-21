import 'package:flutter/material.dart';

import 'package:food_available/src/bloc/provider.dart';
import 'package:food_available/src/models/producto_model.dart';
import 'package:food_available/src/utils/util.dart';

class DonadorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis productos donados'),
        //leading: Container(),
      ),
      body: _crearListado(productosBloc),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado(ProductosBloc productosBloc) {
    return StreamBuilder(
      stream: productosBloc.productosStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0)
            return ver('aun no has realizado donaciones');
          //Navigator.pushReplacementNamed(context, 'login');
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
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direction) => productosBloc.borrarProducto(producto.id),
      child: Card(
        elevation: 8.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
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
                  'Cantidad de unidades: ${producto.cantidadUnidades} \nFecha de caducidad: ${producto.fechaCaducidad}'),
              subtitle: Text('Detalle ${producto.observacion}'),
              onTap: () => Navigator.pushNamed(context, 'producto_donador',
                  arguments: producto),
            ),
          ],
        ),
      ),
    );
  }

  Widget _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple[400],
      onPressed: () => Navigator.pushNamed(context, 'producto_donador'),
    );
  }
}
