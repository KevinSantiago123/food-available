import 'package:http/http.dart' as http;

import 'package:food_available/src/models/calificacion_model.dart';
import 'package:food_available/src/preferencias_usuario/preferencias_usuario.dart';

class CalificacionProvider {
  final String _url = 'https://task-ulibre.firebaseio.com';
  final _pref = new PreferenciasUsuario();

  Future<bool> crearCalificacion(CalificacionModel calificacion) async {
    final url = '$_url/calificaciones.json?auth=${_pref.token}';
    print(calificacion.toJson());
    final resp =
        await http.post(url, body: calificacionModelToJson(calificacion));
    //final decodedData = json.decode(resp.body);
    //print(decodedData);
    return true;
  }
}
