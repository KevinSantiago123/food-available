import 'dart:io';
import 'package:rxdart/rxdart.dart';

import 'package:food_available/src/models/producto_model.dart';
import 'package:food_available/src/providers/productos_provider.dart';

class ProductosBloc {
  final _productosController = new BehaviorSubject<List<ProductoModel>>();
  final _cargandoController = new BehaviorSubject<bool>();
  final _productoEntregadoController = new BehaviorSubject<ProductoModel>();

  final _productosProvider = new ProductosProvider();

  Stream<List<ProductoModel>> get productosStream =>
      _productosController.stream;
  Stream<bool> get cargando => _cargandoController.stream;

  Stream<ProductoModel> get productoEntregado =>
      _productoEntregadoController.stream;

  void cargarProductos() async {
    final productos = await _productosProvider.listarProductos();
    _productosController.sink.add(productos);
  }

  void cargarProductosRecolector([int value = 1]) async {
    final productos = await _productosProvider.listarProductosRecolector(value);
    _productosController.sink.add(productos);
  }

  void cargarEvidenciaProducto([int value = 1]) async {
    final producto = await _productosProvider.listarEvidenciaRecolector(value);
    _productoEntregadoController.sink.add(producto);
  }

  void agregarProducto(ProductoModel producto) async {
    _cargandoController.sink.add(true);
    await _productosProvider.crearProducto(producto);
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
  }
}
