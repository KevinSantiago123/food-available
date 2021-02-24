import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:food_available/src/bloc/provider.dart';
import 'package:food_available/src/pages/acerca_page.dart';
import 'package:food_available/src/pages/calificaciones_page.dart';
import 'package:food_available/src/pages/evidencia_page.dart';
import 'package:food_available/src/pages/historial_page.dart';
import 'package:food_available/src/pages/interesados_page.dart';
import 'package:food_available/src/pages/mapa_page.dart';
import 'package:food_available/src/pages/perfil_page.dart';
import 'package:food_available/src/pages/producto_repartidor_page.dart';
import 'package:food_available/src/pages/repartidor_page.dart';
import 'package:food_available/src/pages/donador_page.dart';
import 'package:food_available/src/pages/login_page.dart';
import 'package:food_available/src/pages/opciones_page.dart';
import 'package:food_available/src/pages/producto_donador_page.dart';
import 'package:food_available/src/pages/registro_page.dart';
import 'package:food_available/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:food_available/src/providers/productos_provider.dart';
import 'package:food_available/src/providers/push_notifications_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final productosProvider = new ProductosProvider();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  await productosProvider.initPrefs();
  await productosProvider.validarToken();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  final prefs = new PreferenciasUsuario();

  @override
  void initState() {
    super.initState();
    final pushProvider = new PushNotificationsProvider();
    pushProvider.initNotifications();
    pushProvider.mensajesStream.listen((argumento) {
      print(argumento);
      //print('argumento desde main: $argumento');
      //Navigator.pushNamed(context, 'mensaje');
      navigatorKey.currentState
          .pushNamed(argumento['ruta'], arguments: argumento);
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(prefs.token);
    return Provider(
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('es', 'ES'),
          const Locale.fromSubtags(languageCode: 'en'),
        ],
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'Food Available',
        initialRoute: prefs.page,
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'registro': (BuildContext context) => RegistroPage(),
          'opciones': (BuildContext context) => OpcionesPage(),
          'donador': (BuildContext context) => DonadorPage(),
          'producto_donador': (BuildContext context) => ProductoDonadorPage(),
          'calificaciones': (BuildContext context) => CalificacionesPage(),
          'interesados': (BuildContext context) => InteresadosPage(),
          'repartidor': (BuildContext context) => RepartidorPage(),
          'producto_repartidor': (BuildContext context) =>
              ProductoRepartidorPage(),
          'mapa': (BuildContext context) => MapaPage(),
          'evidencia': (BuildContext context) => EvidenciaPage(),
          'historial': (BuildContext context) => HistorialPage(),
          'acerca': (BuildContext context) => AcercaPage(),
          'perfil': (BuildContext context) => PerfilPage(),
        },
        theme: ThemeData(primaryColor: Colors.deepPurple),
      ),
    );
  }
}
