import 'dart:convert';
import 'dart:io';
import 'package:mime_type/mime_type.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:http_parser/http_parser.dart';
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

  Future<String> subirImagen(File foto) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dqmhsqj89/image/upload?upload_preset=wuggtmo4');
    final mimeType = mime(foto.path).split('/');

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url,
    );
    //mimeType[0] es la imagen mimeType[1] es la extencion
    final file = await http.MultipartFile.fromPath('file', foto.path,
        contentType: MediaType(mimeType[0], mimeType[1]));
    imageUploadRequest.files.add(file);

    //ejecutamos la peticion
    final streamResponse = await imageUploadRequest.send();
    final res = await http.Response.fromStream(streamResponse);

    if (res.statusCode != 200 && res.statusCode != 201) {
      print("algo salio mal");
      return null;
    }
    //extraemos el url de la respuesta
    final respData = json.decode(res.body);
    return respData['secure_url'];
  }
}
