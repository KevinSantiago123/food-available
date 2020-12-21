import 'dart:async';
import 'dart:convert';
import 'package:food_available/src/models/producto_model.dart';
import 'package:food_available/src/models/usuario_model.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_messaging/firebase_messaging.dart';

//pushApp d4wwS1nhQMiDCETyBzUaG1:APA91bFsdgkXdyJw8fg46k4n656abE8f9k70vfBDOM-IQ4ql2RN6inTKSUnRZBHIibOox-umgdhZxRWP48CTuxtx8mIEC_kIbIhSH1LuMMuOOlQ5Eo6_OOZIVILYfowFRnU-xhzXOuls
//food_available cwO_iGCtQ9yWcAT3ouJQY7:APA91bH2PcrK2Ey76cHRkZZyhXvBiEgcAiTWlpsWqUQO46Sph_5Sk2WFwHg78QCZqUv58cSGnLH0icQpbLIOeWeCXB5RLse8Vx_TgkeqGnMjn19iPoN8qzkm86JHfXG8h6J5BHH82-5Q

class PushNotificationsProvider {
  final String _serverToken =
      'AAAALWUzjTo:APA91bHTE_V22WDZEnf0Jr2ifuicsT8os4KOochm3zjF9J3NsDfVzmqUmXBr-qXrCQcOXWD_j2zFsu8SZ5C05GKufYdmxcaF3EImrkWovO_f6ZHVjQFtVWvTIUhsjJSheMfg5TF4PRE0';
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _mensajesStreamController = StreamController<Map>.broadcast();
  Stream<Map> get mensajesStream => _mensajesStreamController.stream;

  initNotifications() async {
    await _firebaseMessaging.requestNotificationPermissions();
    final tokenCel = await _firebaseMessaging.getToken();
    print('==================FCM Token Init Madre================');
    print(tokenCel);

    _firebaseMessaging.configure(
      onMessage: onMessage,
      onBackgroundMessage: onBackgroundMessage,
      onLaunch: onLaunch,
      onResume: onResume,
    );
  }

  generarIdCel() async {
    final tokenCel = await _firebaseMessaging.getToken();
    print('==================FCM Token================');
    print(tokenCel);
    return tokenCel;
  }

  static Future<dynamic> onBackgroundMessage(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  Future<dynamic> onMessage(Map<String, dynamic> message) async {
    print('=============onMessage============');
    print('message: $message');
    final argumento = message['data'];
    _mensajesStreamController.sink.add(argumento);
    //print(argumento);
  }

  Future<dynamic> onLaunch(Map<String, dynamic> message) async {
    print('===========onLaunch============');
    print('message: $message');
    final argumento = message['data'];
    _mensajesStreamController.sink.add(argumento);
  }

  Future<dynamic> onResume(Map<String, dynamic> message) async {
    print('============onResume=============');
    print('message: $message');
    final argumento = message['data'];
    _mensajesStreamController.sink.add(argumento);
    //print(argumento);
  }

  Future<Map<String, dynamic>> sendAndRetrieveMessage(
      UsuarioModel usuario, ProductoModel producto) async {
    await _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: false),
    );
    print(producto.tokenCel);
    final _url = 'https://fcm.googleapis.com/fcm/send';
    final _header = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$_serverToken'
    };
    final _body = {
      'notification': <String, dynamic>{
        'title': '${producto.nombre}',
        'body': '${usuario.nombres} está interesada en ${producto.nombre}'
      },
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        'id_producto': '${producto.id}',
        'ruta': 'interesados',
      },
      'to': producto.tokenCel,
    };
    print(_url);
    print(_header);
    print(jsonEncode(_body));

    final resp =
        await http.post(_url, headers: _header, body: jsonEncode(_body));
    final decodedData = json.decode(resp.body);
    return decodedData;
  }

  Future<Map<String, dynamic>> sendMessageConfirmacion(
      InteresadoModel interesado, ProductoModel producto) async {
    await _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: false),
    );

    final _url = 'https://fcm.googleapis.com/fcm/send';
    final _header = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$_serverToken'
    };
    final _body = {
      'notification': <String, dynamic>{
        'title': '${interesado.nombres}',
        'body': 'Aceptó tu solicitud de donación.'
      },
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        'ruta': 'mapa',
        'nombre': producto.nombre,
        'token_cel': producto.tokenCel
      },
      'to': interesado.tokenInteresado,
    };

    final resp =
        await http.post(_url, headers: _header, body: jsonEncode(_body));
    final decodedData = json.decode(resp.body);
    return decodedData;
  }

  Future<Map<String, dynamic>> sendMessageVoyPorProducto(
      UsuarioModel usuario, Map dataMap) async {
    await _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: false),
    );

    final _url = 'https://fcm.googleapis.com/fcm/send';
    final _header = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$_serverToken'
    };
    final _body = {
      'notification': <String, dynamic>{
        'title': '${usuario.nombres} ya viene por la donación',
        'body': 'Alista tu ${dataMap['nombre']}'
      },
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        'ruta': 'calificaciones',
      },
      'to': dataMap['token_cel'],
    };

    final resp =
        await http.post(_url, headers: _header, body: jsonEncode(_body));
    final decodedData = json.decode(resp.body);
    return decodedData;
  }

  dispose() {
    _mensajesStreamController?.close();
  }
}
