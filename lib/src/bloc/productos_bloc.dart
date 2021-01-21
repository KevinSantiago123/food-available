import 'dart:io';
import 'package:rxdart/rxdart.dart';

import 'package:food_available/src/models/producto_model.dart';
import 'package:food_available/src/models/producto_entregado_model.dart';
import 'package:food_available/src/providers/productos_provider.dart';

class ProductosBloc {
  final _productosController = new BehaviorSubject<List<ProductoModel>>();
  final _misRecoleccionesController =
      new BehaviorSubject<List<ProductoModel>>();
  final _productoController = new BehaviorSubject<ProductoModel>();
  final _cargandoController = new BehaviorSubject<bool>();
  final _productoEntregadoController =
      new BehaviorSubject<ProductoEntregadoModel>();
  final _productosProvider = new ProductosProvider();
  final _coordenadasController = new BehaviorSubject<CoordenadasModel>();

  Stream<List<ProductoModel>> get productosStream =>
      _productosController.stream;

  Stream<List<ProductoModel>> get misRecoleccionesStream =>
      _misRecoleccionesController.stream;

  Stream<bool> get cargando => _cargandoController.stream;

  Stream<ProductoEntregadoModel> get productoEntregadoStream =>
      _productoEntregadoController.stream;

  Stream<CoordenadasModel> get coordenadasStream =>
      _coordenadasController.stream;

  Stream<ProductoModel> get productoStream => _productoController.stream;

  void cargarProductos() async {
    final productos = await _productosProvider.listarProductos();
    _productosController.sink.add(productos);
  }

  Future<double> cargarProductosEntregados([int opcion = 1]) async {
    double valor = 0.0;
    if (opcion == 1) {
      _cargandoController.sink.add(true);
      final productosEntregado =
          await _productosProvider.listarProductosEntregados(opcion);
      valor = productosEntregado.length.toDouble();
      _cargandoController.sink.add(false);
    } else if (opcion == 2) {
      _cargandoController.sink.add(true);
      final productosEntregado =
          await _productosProvider.listarProductosEntregados(opcion);
      _cargandoController.sink.add(false);
      valor = productosEntregado.length.toDouble();
    } else {
      _cargandoController.sink.add(true);
      final productos = await _productosProvider.listarProductos();
      _cargandoController.sink.add(false);
      valor = productos.length.toDouble();
    }
    return valor;
  }

  void listarProducto(String idProducto) async {
    final producto = await _productosProvider.buscarProducto(idProducto);
    _productoController.sink.add(producto);
  }

  void cargarProductosRecolector([int value = 1]) async {
    final productos = await _productosProvider.listarProductosRecolector(value);
    _productosController.sink.add(productos);
  }

  void cargarMisRecolecciones([int value = 1]) async {
    final productos = await _productosProvider.listarProductosRecolector(value);
    _misRecoleccionesController.sink.add(productos);
  }

  void cargarEvidenciaProducto([int value = 1]) async {
    _cargandoController.sink.add(true);
    final producto = await _productosProvider.listarEvidenciaRecolector(value);
    _productoEntregadoController.sink.add(producto);
    _cargandoController.sink.add(false);
  }

  void agregarProducto(ProductoModel producto) async {
    _cargandoController.sink.add(true);
    await _productosProvider.crearProducto(producto);
    _cargandoController.sink.add(false);
  }

  void obtenerCoordenadas(
      String dir, String bar, String ciu, String dep) async {
    _cargandoController.sink.add(true);
    final coordenadas =
        await _productosProvider.geolocalizar(dir, bar, ciu, dep);
    _coordenadasController.sink.add(coordenadas);
    _cargandoController.sink.add(false);
  }

  Future<CoordenadasModel> obtenerCoordenadas2(
      String dir, String bar, String ciu, String dep) async {
    _cargandoController.sink.add(true);
    final coordenadas =
        await _productosProvider.geolocalizar(dir, bar, ciu, dep);
    _coordenadasController.sink.add(coordenadas);
    _cargandoController.sink.add(false);
    return coordenadas;
  }

  void agregarProductoEntregado(ProductoEntregadoModel producto) async {
    _cargandoController.sink.add(true);
    await _productosProvider.crearProductoEntregado(producto);
    _cargandoController.sink.add(false);
  }

  Future<String> subirFoto(File foto) async {
    _cargandoController.sink.add(true);
    final fotoUrl = await _productosProvider.subirImagen(foto);
    _cargandoController.sink.add(false);

    return fotoUrl;
  }

  void editarProducto(ProductoModel producto) async {
    _cargandoController.sink.add(true);
    await _productosProvider.editarProducto(producto);
    _cargandoController.sink.add(false);
  }

  void borrarProducto(String id) async {
    await _productosProvider.eliminarProducto(id);
  }

  dispose() {
    _productosController?.close();
    _cargandoController?.close();
    _productoEntregadoController?.close();
    _productoController?.close();
    _misRecoleccionesController?.close();
    _coordenadasController?.close();
  }
}
