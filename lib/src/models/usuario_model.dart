import 'dart:convert';

UsuarioModel usuarioModelFromJson(String str) =>
    UsuarioModel.fromJson(json.decode(str));

String usuarioModelToJson(UsuarioModel data) => json.encode(data.toJson());

class UsuarioModel {
  String idUsuario;
  String tipoDocumento;
  int numeroDocumento;
  String nombres;
  String primerApellido;
  String segundoApellido;
  String correo;

  UsuarioModel({
    this.idUsuario,
    this.tipoDocumento = '',
    this.numeroDocumento = 0,
    this.nombres = '',
    this.primerApellido = '',
    this.segundoApellido = '',
    this.correo = '',
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
        idUsuario: json["id_usuario"],
        tipoDocumento: json["tipo_documento"],
        numeroDocumento: json["numero_documento"],
        nombres: json["nombres"],
        primerApellido: json["primer_apellido"],
        segundoApellido: json["segundo_apellido"],
        correo: json["correo"],
      );

  Map<String, dynamic> toJson() => {
        "tipo_documento": tipoDocumento,
        "numero_documento": numeroDocumento,
        "nombres": nombres,
        "primer_apellido": primerApellido,
        "segundo_apellido": segundoApellido,
        "correo": correo,
      };
}
