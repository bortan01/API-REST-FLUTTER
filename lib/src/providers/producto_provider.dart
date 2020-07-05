import 'dart:convert';

import 'package:formvalidation/src/models/producto_model.dart';
import 'package:http/http.dart' as http;

class ProductoProvider {
  final String _url = "https://flutter-varios-11491.firebaseio.com";

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/productos.json';
    final respuesta = await http.post(url, body: productoModelToJson(producto));
    final decodeData = json.decode(respuesta.body);
    print(decodeData);
    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    print("pidiendo datos");
    final url = '$_url/productos.json';
    final respuesta = await http.get(url);
    final Map<String, dynamic> decodeData = json.decode(respuesta.body);
    final List<ProductoModel> listProdcutos = new List();

    if (decodeData == null) {
      return [];
    }
    decodeData.forEach((id, prod) {
      final productoTemporal = ProductoModel.fromJson(prod);
      productoTemporal.id = id;
      listProdcutos.add(productoTemporal);
    });
    return listProdcutos;
  }

  Future<int> borraProducto(String id) async {
    final url = '$_url/productos/$id.json';
    final respuesta = await http.delete(url);
    final Map<String, dynamic> decodeData = json.decode(respuesta.body);
    print(decodeData);

    if (decodeData == null) {
      return 1;
    }

    return 1;
  }

  Future<bool> editarProducto(ProductoModel producto) async {
    final url = '$_url/productos/${producto.id}.json';
    final respuesta = await http.put(url, body: productoModelToJson(producto));
    final decodeData = json.decode(respuesta.body);
    print(decodeData);
    return true;
  }
}
