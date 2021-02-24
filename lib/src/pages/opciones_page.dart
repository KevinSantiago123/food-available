import 'dart:math';
import 'package:flutter/material.dart';

class OpcionesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        _fondoApp(),
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 40.0),
              _titulos(),
              Image.asset('assets/launcher2.png'),
              SizedBox(height: 50.0),
              _botonesRedondiados(context),
              SizedBox(height: 10.0),
              _botonSalir(context),
            ],
          ),
        )
      ],
    ));
  }

  Widget _fondoApp() {
    final gradiente = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(155, 89, 182, 1.0),
            Color.fromRGBO(74, 35, 90, 1.0)
          ],
          begin: FractionalOffset(0.0, 0.6),
          end: FractionalOffset(0.0, 1.0),
        ),
      ),
    );

    final cajaRosa = Transform.rotate(
      angle: -pi / 5.0,
      child: Container(
        height: 360.0,
        width: 360.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80.0),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(253, 254, 254, 1.0),
            Color.fromRGBO(179, 182, 183, 1.0)
          ]),
        ),
      ),
    );

    return Stack(
      children: <Widget>[
        gradiente,
        Positioned(
          top: -100.0,
          left: -15.0,
          child: cajaRosa,
        ),
      ],
    );
  }

  Widget _titulos() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'FOOD AVAILABLE',
              style: TextStyle(
                  color: Colors.purple[900],
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
            /*SizedBox(height: 10.0),
            Text(
              'Selecciona alguna opción',
              style: TextStyle(
                color: Colors.purple[800],
                fontSize: 18.0,
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  Widget _botonesRedondiados(BuildContext context) {
    return Table(
      children: [
        TableRow(
          children: [
            _crearBotonRedondeado(context, Colors.red[400], Icons.favorite,
                'Mis Donaciones', 'donador'),
            _crearBotonRedondeado(context, Colors.blue, Icons.motorcycle,
                'Mis Recolecciones', 'repartidor'),
          ],
        ),
        TableRow(
          children: [
            _crearBotonRedondeado(context, Colors.green, Icons.access_time,
                'Mi Historial', 'historial'),
            _crearBotonRedondeado(
                context, Colors.orange, Icons.person, 'Mi Perfil', 'perfil'),
          ],
        ),
      ],
    );
  }

  Widget _crearBotonRedondeado(BuildContext context, Color color,
      IconData icono, String texto, String ruta) {
    return Container(
      height: 180.0,
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(62, 66, 107, 0.7),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
            height: 5.0,
          ),
          CircleAvatar(
            backgroundColor: color,
            radius: 35.0,
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, ruta);
              },
              icon: Icon(
                icono,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ),
          Text(
            texto,
            style: TextStyle(color: color, fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 5.0,
          )
        ],
      ),
    );
  }

  Widget _textoSalir(BuildContext context) {
    return TextButton(
      child: Text(
        'Cerrar Sesión',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
      onPressed: () {
        //prefs
        Navigator.pushReplacementNamed(context, 'login');
      },
    );
  }

  Widget _botonSalir(BuildContext context) {
    return RaisedButton(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
          child: Text(
            'Cerrar Sesión',
            style: TextStyle(fontSize: 15.0),
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        color: Colors.indigo[300],
        textColor: Colors.white,
        onPressed: () => Navigator.pushReplacementNamed(context, 'login'));
  }
}
