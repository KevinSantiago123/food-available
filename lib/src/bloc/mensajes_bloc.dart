import 'package:food_available/src/models/producto_model.dart';
import 'package:food_available/src/models/usuario_model.dart';
import 'package:food_available/src/providers/push_notifications_provider.dart';
import 'package:rxdart/rxdart.dart';

class MensajesBloc {
  final _tokenCelStreamController = new BehaviorSubject<String>();
  final _cargandoController = new BehaviorSubject<bool>();
  Stream<String> get tokenCelStream => _tokenCelStreamController.stream;
  Stream<bool> get cargando => _cargandoController.stream;

  final _pushProvider = new PushNotificationsProvider();

  void generarTokenCel() async {
    final tokenCel = await _pushProvider.generarIdCel();
    _tokenCelStreamController.sink.add(tokenCel);
  }

  void apartarProducto(UsuarioModel usuario, ProductoModel producto) async {
    _cargandoController.sink.add(true);
    await _pushProvider.sendAndRetrieveMessage(usuario, producto);
    _cargandoController.sink.add(false);
  }

  void confirmarDonacion(InteresadoModel interesado, ProductoModel producto,
      UsuarioModel usuario) async {
    _cargandoController.sink.add(true);
    await _pushProvider.sendMessageConfirmacion(interesado, producto, usuario);
    _cargandoController.sink.add(false);
  }

  void voyPorProducto(UsuarioModel usuario, Map data) async {
    _cargandoController.sink.add(true);
    await _pushProvider.sendMessageVoyPorProducto(usuario, data);
    _cargandoController.sink.add(false);
  }

  dispose() {
    _cargandoController?.close();
    _tokenCelStreamController?.close();
  }
}
