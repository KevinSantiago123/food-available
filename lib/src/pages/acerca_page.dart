import 'package:flutter/material.dart';

class AcercaPage extends StatelessWidget {
  final estiloTitulo = TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold);
  final estiloSubTitulo = TextStyle(fontSize: 18.0, color: Colors.deepPurple);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Objetivo de la App'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _crearImagen(),
            _crearTitulo(),
            _crearTexto(),
          ],
        ),
      ),
    );
  }

  Widget _crearImagen() {
    return Container(
      width: double.infinity,
      child: Image.asset('assets/fao2.jpg'),
      /*Image(
        image: Image.asset('assets/fao.jpg');
        height: 200.0,
        fit: BoxFit.cover,
      ),*/
    );
  }

  Widget _crearTitulo() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Hambre Cero', style: estiloTitulo),
                  SizedBox(height: 7.0),
                  Text('Objetivo de desarrollo sostenible 2',
                      style: estiloSubTitulo)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _crearTexto() {
    return SafeArea(
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
              'El objetivo de está aplicación es que aquellas personas que desean donar o colaborar con alimentos perecederos o no perecederos, lo puedan realizar mediante la aplicación. Esta permite la publicación de esos alimentos y que personas que trabajan con entidades o con organizaciones sin ánimo de lucro y que cuyo objetivo sea llevar alimentos y bebidas a personas necesitadas puedan mediante la aplicación ubicar y reservar para recoger dichos alimentos.',
              textAlign: TextAlign.justify)),
    );
  }
}
