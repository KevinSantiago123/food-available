import 'dart:convert';

UsuarioModel usuarioModelFromJson(String str) =>
    UsuarioModel.fromJson(json.decode(str));

String usuarioModelToJson(UsuarioModel data) => json.encode(data.toJson());

String interesadoModelToJson(InteresadoModel data) =>
    json.encode(data.toJson());

class UsuarioModel {
  String idUsuario;
  String tipoDocumento;
  int numeroDocumento;
  String nombres;
  String primerApellido;
  String segundoApellido;
  String correo;
  int calificacion;

  UsuarioModel({
    this.idUsuario,
    this.tipoDocumento,
    this.numeroDocumento = 0,
    this.nombres,
    this.primerApellido,
    this.segundoApellido,
    this.correo,
    this.calificacion = 5,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
        idUsuario: json["id_usuario"],
        tipoDocumento: json["tipo_documento"],
        numeroDocumento: json["numero_documento"],
        nombres: json["nombres"],
        primerApellido: json["primer_apellido"],
        segundoApellido: json["segundo_apellido"],
        correo: json["correo"],
        calificacion: json["calificacion"],
      );

  Map<String, dynamic> toJson() => {
        //"id": idUsuario,
        "tipo_documento": tipoDocumento,
        "numero_documento": numeroDocumento,
        "nombres": nombres,
        "primer_apellido": primerApellido,
        "segundo_apellido": segundoApellido,
        "correo": correo,
        "calificacion": calificacion,
      };

  UsuarioModel modelarUsuario(data) {
    UsuarioModel usuTemp;
    data.forEach((id, prod) {
      usuTemp = UsuarioModel.fromJson(prod);
      usuTemp.idUsuario = id;
    });
    return usuTemp;
  }
}

class InteresadoModel {
  String idProducto;
  String nombres;
  String correo;
  int calificacion;
  String tokenInteresado;

  InteresadoModel({
    this.idProducto,
    this.nombres,
    this.correo,
    this.calificacion = 5,
    this.tokenInteresado,
  });

  factory InteresadoModel.fromJson(Map<String, dynamic> json) =>
      InteresadoModel(
        idProducto: json["id_producto"],
        nombres: json["nombres"],
        correo: json["correo"],
        calificacion: json["calificacion"],
        tokenInteresado: json["token_interesado"],
      );

  Map<String, dynamic> toJson() => {
        "id_producto": idProducto,
        "nombres": nombres,
        "correo": correo,
        "calificacion": calificacion,
        "token_interesado": tokenInteresado,
      };

  InteresadoModel toInteresadoModel(String idProducto, String correo,
          String nombres, int calificacion, String tokenInteresado) =>
      InteresadoModel(
        idProducto: idProducto,
        nombres: nombres,
        correo: correo,
        calificacion: calificacion,
        tokenInteresado: tokenInteresado,
      );

  InteresadoModel modelarInteresado(data) {
    InteresadoModel usuTemp;
    data.forEach((id, prod) {
      usuTemp = InteresadoModel.fromJson(prod);
    });
    return usuTemp;
  }

  List<InteresadoModel> modelarInteresados(data) {
    final List<InteresadoModel> interesados = new List();
    data.forEach((id, prod) {
      final prodTemp = InteresadoModel.fromJson(prod);
      interesados.add(prodTemp);
    });
    return interesados;
  }
}
