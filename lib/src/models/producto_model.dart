import 'dart:convert';

ProductoModel productoModelFromJson(String str) =>
    ProductoModel.fromJson(json.decode(str));

String productoModelToJson(ProductoModel data) => json.encode(data.toJson());

class ProductoModel {
  String id;
  String idCorreo;
  List<String> idCorreoRepartidor;
  String nombre;
  double cantidadUnidades;
  String fechaCaducidad;
  String direccion;
  int telefono;
  String barrio;
  String ciudad;
  String departamento;
  String observacion;
  double cx;
  double cy;
  String fotoUrl;
  int estado;
  String tokenCel;
  String idCorreoRepartidorAsignado;

  ProductoModel({
    this.id,
    this.idCorreo,
    this.idCorreoRepartidor = const ['correo'],
    this.nombre,
    this.cantidadUnidades = 0.0,
    this.fechaCaducidad,
    this.direccion,
    this.telefono = 0,
    this.barrio,
    this.ciudad,
    this.departamento,
    this.observacion,
    this.cx = 0.0,
    this.cy = 0.0,
    this.fotoUrl,
    this.estado,
    this.tokenCel,
    this.idCorreoRepartidorAsignado,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
        idCorreo: json["id_correo"],
        idCorreoRepartidor: json["id_correo_repartidor"].cast<String>(),
        nombre: json["nombre"],
        cantidadUnidades: json["cantidad_unidades"].toDouble(),
        fechaCaducidad:
            json["fecha_caducidad"], //DateTime.parse(json["fecha_caducidad"]),
        direccion: json["direccion"],
        telefono: json["telefono"],
        barrio: json["barrio"],
        ciudad: json["ciudad"],
        departamento: json["departamento"],
        observacion: json["observacion"],
        cx: json["cx"].toDouble(),
        cy: json["cy"].toDouble(),
        fotoUrl: json["foto_url"],
        estado: json["estado"],
        tokenCel: json["token_cel"],
        idCorreoRepartidorAsignado: json["id_correo_repartidor_asignado"],
      );

  Map<String, dynamic> toJson() => {
        "id_correo": idCorreo,
        "id_correo_repartidor": idCorreoRepartidor,
        "nombre": nombre,
        "cantidad_unidades": cantidadUnidades,
        "fecha_caducidad": fechaCaducidad,
        //"${fechaCaducidad.year.toString().padLeft(4, '0')}-${fechaCaducidad.month.toString().padLeft(2, '0')}-${fechaCaducidad.day.toString().padLeft(2, '0')}",
        "direccion": direccion,
        "telefono": telefono,
        "barrio": barrio,
        "ciudad": ciudad,
        "departamento": departamento,
        "observacion": observacion,
        "cx": cx,
        "cy": cy,
        "foto_url": fotoUrl,
        "estado": estado,
        "token_cel": tokenCel,
        "id_correo_repartidor_asignado": idCorreoRepartidorAsignado,
      };

  ProductoModel toProductoModel(ProductoModel producto) => ProductoModel(
        idCorreo: producto.idCorreo,
        idCorreoRepartidor: producto.idCorreoRepartidor,
        nombre: producto.nombre,
        cantidadUnidades: producto.cantidadUnidades,
        fechaCaducidad: producto.fechaCaducidad,
        direccion: producto.direccion,
        telefono: producto.telefono,
        barrio: producto.barrio,
        ciudad: producto.ciudad,
        departamento: producto.departamento,
        observacion: producto.observacion,
        cx: producto.cx,
        cy: producto.cy,
        fotoUrl: producto.fotoUrl,
        estado: producto.estado,
        tokenCel: producto.tokenCel,
        idCorreoRepartidorAsignado: idCorreoRepartidorAsignado,
      );

  List<ProductoModel> modelarProductos(data) {
    final List<ProductoModel> productos = new List();
    data.forEach((id, prod) {
      final prodTemp = ProductoModel.fromJson(prod);
      prodTemp.id = id;
      productos.add(prodTemp);
    });
    return productos;
  }

  ProductoModel modelarProducto(data) {
    ProductoModel usuTemp;
    data.forEach((id, prod) {
      usuTemp = ProductoModel.fromJson(prod);
    });
    return usuTemp;
  }
}
