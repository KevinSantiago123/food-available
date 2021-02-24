import 'package:flutter/material.dart';

import 'package:food_available/src/bloc/provider.dart';
import 'package:food_available/src/providers/usuario_provider.dart';
import 'package:food_available/src/utils/util.dart';

class LoginPage extends StatelessWidget {
  final usuarioProvider = UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _loginForm(context),
        ],
      ),
    );
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.1),
      ),
    );
    final poster = Container(
      padding: EdgeInsets.only(top: 80.0),
      child: Column(
        children: <Widget>[
          //Icon(Icons.food_bank, color: Colors.white, size: 100.0),
          Image.asset('assets/launcher2.png'),
          SizedBox(
            height: 10.0,
            width: double.infinity,
          ),
          Text(
            'Food Available',
            style: TextStyle(color: Colors.white, fontSize: 25.0),
          )
        ],
      ),
    );
    final fondoMorado = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: <Color>[
          Color.fromRGBO(63, 63, 156, 1.0),
          Color.fromRGBO(28, 92, 233, 0.7),
          //Color.fromRGBO(90, 70, 178, 1.0),
        ],
      )),
    );

    return Stack(
      children: <Widget>[
        fondoMorado,
        Positioned(top: 70.0, left: 30.0, child: circulo),
        Positioned(top: -40.0, right: -30.0, child: circulo),
        Positioned(top: 110.0, right: 30.0, child: circulo),
        poster
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(child: Container(height: 190.0)),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              children: <Widget>[
                //_fraseMotivacional(),
                Text('Ingreso', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 10.0),
                _textoEmail(bloc),
                SizedBox(height: 30.0),
                _textoPassword(bloc),
                SizedBox(height: 30.0),
                _crearBoton(bloc, 'Ingresar'),
              ],
            ),
          ),
          /*FlatButton(
              child: Text('¿Has olvidado tu contraseña?'), onPressed: () {}),*/
          _textoRegistro(context),
          SizedBox(height: 100.0),
        ],
      ),
    );
  }

  Widget _fraseMotivacional() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"No hay nada más fuerte en el mundo que el corazón de un voluntario."',
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.deepPurple[300],
                fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
          Text('James H. Doolittle'),
        ],
      ),
    );
  }

  Widget _textoEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.alternate_email,
                  color: Colors.deepPurple[300],
                ),
                hintText: 'ejemplo@correo.com',
                labelText: 'Correo electrónico',
                counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }

  Widget _textoPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.lock_outline,
                  color: Colors.deepPurple[300],
                ),
                labelText: 'Contraseña',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  Widget _crearBoton(LoginBloc bloc, String texto) {
    return StreamBuilder(
      stream: bloc.stateBotonStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 13.0),
              child: Text(texto),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            color: Colors.deepPurple,
            textColor: Colors.white,
            onPressed: snapshot.hasData ? () => _login(context, bloc) : null);
      },
    );
  }

  _login(BuildContext context, LoginBloc bloc) async {
    Map info = await usuarioProvider.login(bloc.email, bloc.password);
    if (info['ok']) {
      Navigator.pushReplacementNamed(context, 'opciones');
    } else {
      mostrarAlerta(context, info['mensaje']);
    }
  }

  Widget _textoRegistro(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Aun no tienes cuenta,'),
        TextButton(
          child: Text(
            'regístrate aquí',
            style: TextStyle(
              color: Colors.deepPurple[300],
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
          onPressed: () => Navigator.pushReplacementNamed(context, 'registro'),
        ),
      ],
    );
  }
}
