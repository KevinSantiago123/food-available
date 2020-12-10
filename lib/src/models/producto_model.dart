import 'dart:convert';

ProductoModel productoModelFromJson(String str) =>
    ProductoModel.fromJson(json.decode(str));

String productoModelToJson(ProductoModel data) => json.encode(data.toJson());

class ProductoModel {
  String id;
  String idCorreo;
  String idCorreoRepartidor;
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

  ProductoModel({
    this.id,
    this.idCorreo,
    this.idCorreoRepartidor,
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
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
        idCorreo: json["id_correo"],
        idCorreoRepartidor: json["id_correo_repartidor"],
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
      );

  Map<String, dynamic> toJson() => {
        "id": id,
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
      };

  factory ProductoModel.fromNull() => ProductoModel(
        id: '1',
        idCorreo: '',
        idCorreoRepartidor: '',
        nombre: '',
        cantidadUnidades: 0.0,
        fechaCaducidad: '',
        direccion: '',
        telefono: 0,
        barrio: '',
        ciudad: '',
        departamento: '',
        observacion: '',
        cx: 0.0,
        cy: 0.0,
        fotoUrl: '',
        estado: 0,
      );

  ProductoModel toProductoModel(ProductoModel producto) => ProductoModel(
        id: producto.id,
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
      );

  List<ProductoModel> modelarProductos(data) {
    final List<ProductoModel> productos = new List();
    if (data == null) {
      data.forEach((id, prod) {
        final _temp = ProductoModel.fromNull();
        productos.add(_temp);
      });
      return productos;
    }

    if (data['error'] != null) {
      data.forEach((id, prod) {
        final _temp = ProductoModel.fromNull();
        productos.add(_temp);
      });
      return productos;
    }

    data.forEach((id, prod) {
      final prodTemp = ProductoModel.fromJson(prod);
      prodTemp.id = id;
      productos.add(prodTemp);
    });
    return productos;
  }
}
