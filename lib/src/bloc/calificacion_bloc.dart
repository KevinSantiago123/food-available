import 'package:rxdart/rxdart.dart';

import 'package:food_available/src/providers/calificacion_provider.dart';
import 'package:food_available/src/models/calificacion_model.dart';

class CalificacionBloc {
  final _calificacionController = new BehaviorSubject<CalificacionModel>();
  final _cargandoController = new BehaviorSubject<bool>();
  final _calificacionProvider = new CalificacionProvider();

  Stream<bool> get cargando => _cargandoController.stream;
  Stream<CalificacionModel> get calificacionStream =>
      _calificacionController.stream;

  void agregarCalificacion(CalificacionModel calificacion) async {
    _cargandoController.sink.add(true);
    await _calificacionProvider.crearCalificacion(calificacion);
    _cargandoController.sink.add(false);
  }

  dispose() {
    _cargandoController?.close();
    _calificacionController?.close();
  }
}
