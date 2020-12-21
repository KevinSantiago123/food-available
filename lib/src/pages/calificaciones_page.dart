import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CalificacionesPage extends StatefulWidget {
  @override
  _CalificacionesPageState createState() => _CalificacionesPageState();
}

class _CalificacionesPageState extends State<CalificacionesPage> {
  double _rating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Califica el repartidor'),
      ),
      body: SingleChildScrollView(
        //padding: EdgeInsets.all(80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 100.0,
            ),
            _titulo('Rating Bar'),
            _ratingBar(_rating),
            SizedBox(height: 20.0),
            _rating != null
                ? Text(
                    'Calificación: $_rating',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                : Container(),
            SizedBox(height: 40),
            _titulo('Observaciones'),
            _cajaObservacion(),
            SizedBox(height: 20.0),
            _crearBoton(),
          ],
        ),
      ),
    );
  }

  Widget _ratingBar(double index) {
    return Container(
      padding: EdgeInsets.only(top: 40),
      child: RatingBar.builder(
        initialRating: 3,
        itemCount: 5,
        //itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return Icon(
                Icons.sentiment_very_dissatisfied,
                color: Colors.red,
              );
            case 1:
              return Icon(
                Icons.sentiment_dissatisfied,
                color: Colors.redAccent,
              );
            case 2:
              return Icon(
                Icons.sentiment_neutral,
                color: Colors.amber,
              );
            case 3:
              return Icon(
                Icons.sentiment_satisfied,
                color: Colors.lightGreen,
              );
            case 4:
              return Icon(
                Icons.sentiment_very_satisfied,
                color: Colors.green,
              );
            default:
              return Container();
          }
        },
        onRatingUpdate: (rating) {
          setState(() {
            _rating = rating;
          });
        },
        updateOnDrag: true,
      ),
    );
  }

  Widget _titulo(String text) => Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 24.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      );

  Widget _cajaObservacion() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        //initialValue: producto.observacion,
        maxLines: 4,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          hintText: 'Escribe aquí',

          //labelText: 'Observación',
          //icon: Icon(Icons.text_snippet, color: Colors.deepPurple[700]),
        ),
        //onSaved: (value) => producto.observacion = value,
        //onSaved: (value) => {},
      ),
    );
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Colors.deepPurple[600],
      textColor: Colors.white,
      label: Text('Calificar'),
      icon: Icon(Icons.save),
      onPressed: () => Navigator.pushReplacementNamed(context, 'opciones'),
    );
  }
}
