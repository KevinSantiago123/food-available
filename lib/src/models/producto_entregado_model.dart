import 'dart:convert';

ProductoEntregadoModel productoEntregadoModelFromJson(String str) =>
    ProductoEntregadoModel.fromJson(json.decode(str));

String productoEntregadoModelToJson(ProductoEntregadoModel data) =>
    json.encode(data.toJson());

class ProductoEntregadoModel {
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
  String fechaEntrega;
  String direccionEntrega;
  String barrioEntrega;
  String ciudadEntrega;
  String departamentoEntrega;
  String detalleEntrega;
  String fotoUrlEntrega;
  double cxEntrega;
  double cyEntrega;

  ProductoEntregadoModel({
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
    this.estado = 0,
    this.fechaEntrega,
    this.direccionEntrega,
    this.barrioEntrega,
    this.ciudadEntrega,
    this.departamentoEntrega,
    this.detalleEntrega,
    this.fotoUrlEntrega,
    this.cxEntrega = 0.0,
    this.cyEntrega = 0.0,
  });

  factory ProductoEntregadoModel.fromJson(Map<String, dynamic> json) =>
      ProductoEntregadoModel(
        id: json["id"],
        idCorreo: json["id_correo"],
        idCorreoRepartidor: json["id_correo_repartidor"],
        nombre: json["nombre"],
        cantidadUnidades: json["cantidad_unidades"].toDouble(),
        fechaCaducidad: json["fecha_caducidad"],
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
        fechaEntrega: json["fecha_entrega"],
        direccionEntrega: json["direccion_entrega"],
        barrioEntrega: json["barrio_entrega"],
        ciudadEntrega: json["ciudad_entrega"],
        departamentoEntrega: json["departamento_entrega"],
        detalleEntrega: json["detalle_entrega"],
        fotoUrlEntrega: json["foto_url_entrega"],
        cxEntrega: 0.0,
        cyEntrega: 0.0,
      );

  Map<String, dynamic> toJson() => {
        "id_correo": idCorreo,
        "id_correo_repartidor": idCorreoRepartidor,
        "nombre": nombre,
        "cantidad_unidades": cantidadUnidades,
        "fecha_caducidad": fechaCaducidad,
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
        "fecha_entrega": fechaEntrega,
        "direccion_entrega": direccionEntrega,
        "barrio_entrega": barrioEntrega,
        "ciudad_entrega": ciudadEntrega,
        "departamento_entrega": departamentoEntrega,
        "detalle_entrega": detalleEntrega,
        "foto_url_entrega": fotoUrlEntrega,
        "cx_entrega": cxEntrega,
        "cy_entrega": cyEntrega,
      };

  factory ProductoEntregadoModel.fromNull() => ProductoEntregadoModel(
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
        fechaEntrega: '',
        direccionEntrega: '',
        barrioEntrega: '',
        ciudadEntrega: '',
        departamentoEntrega: '',
        detalleEntrega: '',
        fotoUrlEntrega: '',
        cxEntrega: 0.0,
        cyEntrega: 0.0,
      );

  ProductoEntregadoModel toProductoModel(ProductoEntregadoModel producto) =>
      ProductoEntregadoModel(
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
        fechaEntrega: '',
        direccionEntrega: '',
        barrioEntrega: '',
        ciudadEntrega: '',
        departamentoEntrega: '',
        detalleEntrega: '',
        fotoUrlEntrega: '',
        cxEntrega: 0.0,
        cyEntrega: 0.0,
      );

  List<ProductoEntregadoModel> modelarProductosEntregado(data) {
    final List<ProductoEntregadoModel> productosEntregado = new List();
    print('pase');
    if (data == null) {
      print('pase null');
      data.forEach((id, prod) {
        final _temp = ProductoEntregadoModel.fromNull();
        productosEntregado.add(_temp);
      });
      return productosEntregado;
    }

    if (data['error'] != null) {
      print('pase error');
      data.forEach((id, prod) {
        final _temp = ProductoEntregadoModel.fromNull();
        productosEntregado.add(_temp);
      });
      return productosEntregado;
    }
    print('pase2');
    data.forEach((id, prod) {
      final prodTemp = ProductoEntregadoModel.fromJson(prod);
      prodTemp.id = id;
      productosEntregado.add(prodTemp);
    });
    return productosEntregado;
  }
}
