import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final MapController map = new MapController();
  final double zoom = 16;
  String tipoMapa = 'streets-v11';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubica la donación'),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        }),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () => map.move(LatLng(4.758558, -74.032203), zoom),
          )
        ],
      ),
      body: _crearFlutterMap(),
      floatingActionButton: _crearBotones(context),
      //floatingActionButton:
    );
  }

  Widget _crearFlutterMap() {
    return FlutterMap(
      mapController: map,
      options: MapOptions(center: LatLng(4.758558, -74.032203), zoom: zoom),
      //
      layers: [
        _crearMapa(),
        _crearMarcadores(),
      ],
    );
  }

  _crearMapa() {
    return TileLayerOptions(
        urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/'
            '{id}/{z}/{x}/{y}?access_token={accessToken}',
        additionalOptions: {
          'accessToken':
              'pk.eyJ1Ijoia2V2aW4tY2FzdGFuZWRhIiwiYSI6ImNraGM5ZDJoaDAzN24ycWxjc2dpcGduaXgifQ.r3ftW0Q8OJEETh1NZfU7TA',
          'id': '$tipoMapa/tiles'
        });
  }

  _crearMarcadores() {
    return MarkerLayerOptions(markers: <Marker>[
      Marker(
          width: 100.0,
          height: 100.0,
          point: LatLng(4.758558, -74.032203),
          builder: (context) => Container(
                child: Icon(Icons.location_on,
                    size: 60.0, color: Theme.of(context).primaryColor),
              ))
    ]);
  }

  Widget _crearBotones(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        SizedBox(height: 120),
        _crearBotonFlotante(context),
        Expanded(child: SizedBox()),
        _botonRecogerDonacion(),
        _botonCargarEvidencia(),
        SizedBox(width: 15),
      ],
    );
  }

  Widget _botonRecogerDonacion() {
    return FloatingActionButton(
      heroTag: "btn1",
      backgroundColor: Colors.blue[900],
      child: Icon(
        Icons.mail,
        size: 35,
      ),
      onPressed: () {},
    );
  }

  Widget _crearBotonFlotante(BuildContext context) {
    return FloatingActionButton(
      heroTag: "btn2",
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        if (tipoMapa == 'streets-v11') {
          tipoMapa = 'dark-v10';
        } else if (tipoMapa == 'dark-v10') {
          tipoMapa = 'light-v10';
        } else if (tipoMapa == 'light-v10') {
          tipoMapa = 'outdoors-v11';
        } else if (tipoMapa == 'outdoors-v11') {
          tipoMapa = 'satellite-v9';
        } else {
          tipoMapa = 'streets-v11';
        }
        setState(() {});
      },
    );
  }

  Widget _botonCargarEvidencia() {
    return RaisedButton(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
          child: Text(
            'Cargar Evidencia',
            style: TextStyle(fontSize: 15.0),
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        color: Colors.green[800],
        textColor: Colors.white,
        onPressed: () => Navigator.pushNamed(context, 'evidencia'));
  }
}
