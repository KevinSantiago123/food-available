import 'dart:convert';

CalificacionModel calificacionModelFromJson(String str) =>
    CalificacionModel.fromJson(json.decode(str));

String calificacionModelToJson(CalificacionModel data) =>
    json.encode(data.toJson());

class CalificacionModel {
  String correo;
  double calificacion;
  String observacion;
  String tipificacion;

  CalificacionModel({
    this.correo,
    this.calificacion = 3.0,
    this.observacion,
    this.tipificacion,
  });

  factory CalificacionModel.fromJson(Map<String, dynamic> json) =>
      CalificacionModel(
        correo: json["correo"],
        calificacion: json["calificacion"],
        observacion: json["observacion"],
        tipificacion: json["tipificacion"],
      );

  Map<String, dynamic> toJson() => {
        "correo": correo,
        "calificacion": calificacion,
        "observacion": observacion,
        "tipificacion": tipificacion,
      };
}
