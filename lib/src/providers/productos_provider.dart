import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

import 'package:food_available/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:food_available/src/models/producto_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
export 'package:food_available/src/models/producto_model.dart';
import 'package:food_available/src/models/producto_entregado_model.dart';

class ProductosProvider {
  SharedPreferences _prefs;
  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  final String _url = 'https://task-ulibre.firebaseio.com';
  final _pref = new PreferenciasUsuario();

  Future<int> validarToken() async {
    final url = '$_url/productos/1.json?auth=${_pref.token}';
    final resp = await http.delete(url);
    if (resp.statusCode == 200) {
      _pref.page = 'opciones';
    } else {
      _pref.page = 'login';
    }
    return 1;
  }

  //final String _url = 'https://food-available-dev.firebaseio.com';
  final productosModel = new ProductoModel();
  final productosEntregadoModel = new ProductoEntregadoModel();

  Future<CoordenadasModel> geolocalizar(
      String dir, String bar, String ciu, String dep) async {
    var temp;
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$dir, $bar, $ciu, $dep, colombia&key=AIzaSyAmkxnOho34pIYMSqblQvWma_qPPl_UjAY';
    final resp = await http.get(url);
    temp = json.decode(resp.body);
    final CoordenadasModel coordenadas =
        CoordenadasModel.fromJson(temp['results'][0]['geometry']['location']);
    print('saliendo del ws' + coordenadas.toJson().toString());
    return coordenadas;
  }

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/productos.json?auth=${_pref.token}';
    final resp = await http.post(url, body: productoModelToJson(producto));
    //final decodedData = json.decode(resp.body);
    //print(decodedData);
    return true;
  }

  Future<bool> crearProductoEntregado(ProductoEntregadoModel producto) async {
    final url = '$_url/productos_entregados.json?auth=${_pref.token}';
    final resp =
        await http.post(url, body: productoEntregadoModelToJson(producto));
    return true;
  }

  Future<bool> editarProducto(ProductoModel producto) async {
    final url = '$_url/productos/${producto.id}.json?auth=${_pref.token}';
    //final resp = producto.remove('id');
    final resp = await http.put(url, body: productoModelToJson(producto));
    final decodedData = json.decode(resp.body);
    return true;
  }

  Future<ProductoModel> buscarProducto(String idProducto) async {
    final url = '$_url/productos/$idProducto.json?auth=${_pref.token}';
    //print(url);
    //final resp = producto.remove('id');
    final resp = await http.get(url);
    final ProductoModel producto = productoModelFromJson(resp.body);
    //print('saliendo del ws' + producto.toJson().toString());
    return producto;
  }

  Future<List<ProductoModel>> listarProductos() async {
    final url =
        '$_url/productos.json?orderBy="id_correo"&equalTo="${_pref.correo}"&print=pretty&auth=${_pref.token}';
    //print(url);
    final resp = await http.get(url);
    final List<ProductoModel> productos =
        productosModel.modelarProductos(json.decode(resp.body));
    return productos;
  }

  Future<List<ProductoEntregadoModel>> listarProductosEntregados(
      [int opcion = 1]) async {
    String url;
    if (opcion == 1) {
      url =
          '$_url/productos_entregados.json?orderBy="id_correo"&equalTo="${_pref.correo}"&print=pretty&auth=${_pref.token}';
    } else {
      url =
          '$_url/productos_entregados.json?orderBy="id_correo_repartidor_asignado"&equalTo="${_pref.correo}"&print=pretty&auth=${_pref.token}';
    }
    //print(url);
    final resp = await http.get(url);
    final List<ProductoEntregadoModel> productos = productosEntregadoModel
        .modelarProductosEntregado(json.decode(resp.body));
    return productos;
  }

  Future<List<ProductoModel>> listarProductosRecolector([int value = 1]) async {
    final url =
        '$_url/productos.json?orderBy="estado"&equalTo=$value&print=pretty&auth=${_pref.token}';
    //print(url);
    final resp = await http.get(url);
    final temp = json.decode(resp.body);
    final List<ProductoModel> productos =
        productosModel.modelarProductos(json.decode(resp.body));
    return productos;
  }

  Future<ProductoEntregadoModel> listarEvidenciaRecolector(
      [int value = 1]) async {
    final url =
        '$_url/productos.json?orderBy="estado"&equalTo=$value&print=pretty&auth=${_pref.token}';
    //print(url);
    final resp = await http.get(url);
    final List<ProductoEntregadoModel> productosEntregados =
        productosEntregadoModel
            .modelarProductosEntregado(json.decode(resp.body));
    ProductoEntregadoModel productosNew = new ProductoEntregadoModel();
    productosEntregados.forEach((data) {
      if (data.idCorreoRepartidorAsignado == _pref.correo) {
        productosNew = productosNew.toProductoModel(data);
      }
    });
    return productosNew;
  }

  Future<int> eliminarProducto(String id) async {
    final url = '$_url/productos/$id.json?auth=${_pref.token}';
    final resp = await http.delete(url);
    return 1;
  }

  Future<String> subirImagen(File imagen) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/kevincho/image/upload?upload_preset=aw5ugyu7');
    final mimeType = mime(imagen.path).split('/');
    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', imagen.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      //print('algo esta mal');
      //print(resp.body);
      return null;
    }
    final respData = json.decode(resp.body);
    //print(respData);
    return respData['secure_url'];
  }
}
