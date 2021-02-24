import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:food_available/src/bloc/provider.dart';
import 'package:food_available/src/utils/util.dart';

class HistorialPage extends StatefulWidget {
  final Widget child;

  HistorialPage({Key key, this.child}) : super(key: key);

  @override
  _HistorialPageState createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  List<charts.Series<Task, String>> _seriesPieData;
  ProductosBloc productosBloc;
  double misDonaciones = 0;
  double misRecolecciones = 0;

  Future<bool> _alistarInfo() async {
    final productosBloc = Provider.productosBloc(context);
    misDonaciones = await productosBloc.cargarProductosEntregados(3);
    misDonaciones += await productosBloc.cargarProductosEntregados();
    misRecolecciones += await productosBloc.cargarProductosEntregados(2);
    _generateData();
    return true;
  }

  void _generateData() {
    var piedata = [
      new Task('Mis donaciones realizadas', misDonaciones, Color(0xff3366cc)),
      new Task(
          'Mis recolecciones realizadas', misRecolecciones, Color(0xff990099)),
    ];

    _seriesPieData.add(
      charts.Series(
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'Air1',
        data: piedata,
        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _seriesPieData = List<charts.Series<Task, String>>();
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Color,
        title: Text('Mi Historial'),
      ),
      body: FutureBuilder(
        future: _alistarInfo(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (misDonaciones == 0 && misRecolecciones == 0)
              return ver('te invitamos a que dones o lleves donaciones');
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      _textoTitulo('Descripción'),
                      SizedBox(height: 10.0),
                      Expanded(
                        child: charts.PieChart(_seriesPieData,
                            animate: true,
                            animationDuration: Duration(seconds: 2),
                            behaviors: [
                              new charts.DatumLegend(
                                outsideJustification:
                                    charts.OutsideJustification.endDrawArea,
                                horizontalFirst: false,
                                desiredMaxRows: 2,
                                cellPadding: new EdgeInsets.only(
                                    right: 4.0, bottom: 4.0),
                                entryTextStyle: charts.TextStyleSpec(
                                    color: charts.MaterialPalette.black,
                                    fontFamily: 'Georgia',
                                    fontSize: 18),
                              )
                            ],
                            defaultRenderer: new charts.ArcRendererConfig(
                                arcWidth: 100,
                                arcRendererDecorators: [
                                  new charts.ArcLabelDecorator(
                                      labelPosition:
                                          charts.ArcLabelPosition.inside)
                                ])),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container(
              height: 400.0,
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}

Widget _textoTitulo(String titulo) {
  return Text(
    titulo,
    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
  );
}

class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}
