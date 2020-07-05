import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/providers/producto_provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("home"),
      ),
      body: crearListado(),
      floatingActionButton: crearBotton(context),
    );
  }

  crearListado() {
    ProductoProvider productoProvider = new ProductoProvider();
    return FutureBuilder(
      future: productoProvider.cargarProductos(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;
          return ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, i) {
                return _crearItem(context, productos[i]);
              });
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  crearBotton(context) {
    return new FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, "producto"),
    );
  }

  Widget _crearItem(BuildContext context, ProductoModel prod) {
    ProductoProvider productoProvider = new ProductoProvider();
    return Dismissible(
      background: Container(
        color: Colors.red,
      ),
      //DIRECION ES IZQUIERDA O DERECHA
      onDismissed: (direccion) {
        // ESTO SE DISPARA CUANDO SE DESLIZA EL ELEMENTO
        productoProvider.borraProducto(prod.id);
      },
      key: UniqueKey(),
      child: new ListTile(
        title: Text('${prod.titulo} - ${prod.valor}'),
        subtitle: new Text(prod.id),
        onTap: () {
          Navigator.pushNamed(context, 'producto', arguments: prod);
        },
      ),
    );
  }
}
