import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/providers/producto_provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("home"),
      ),
      body: crearListado(productosBloc),
      floatingActionButton: crearBotton(context),
    );
  }

  crearListado(ProductosBloc productosBloc) {
    return StreamBuilder(
      stream: productosBloc.productosStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;
          return ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, i) {
                return _crearItem(context, productos[i], productosBloc);
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

  Widget _crearItem(
      BuildContext context, ProductoModel prod, ProductosBloc prodBloc) {
    //ProductoProvider productoProvider = new ProductoProvider();
    return Dismissible(
      background: Container(
        color: Colors.red,
      ),
      //DIRECION ES IZQUIERDA O DERECHA
      onDismissed: (direccion) {
        // ESTO SE DISPARA CUANDO SE DESLIZA EL ELEMENTO
        prodBloc.borraarProducto(prod.id);
      },
      key: UniqueKey(),
      child: new Card(
        child: new Column(
          children: <Widget>[
            (prod.fotoUrl == null)
                ? Image(
                    image: AssetImage('assets/no-image.png'),
                  )
                : Hero(
                    tag: prod.id ?? "no-hero",
                    child: new FadeInImage(
                      placeholder: new AssetImage('assets/loading.gif'),
                      image: NetworkImage(prod.fotoUrl),
                      height: 300.0,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
            new ListTile(
              title: Text('${prod.titulo} - ${prod.valor}'),
              subtitle: new Text(prod.id),
              onTap: () {
                Navigator.pushNamed(context, 'producto', arguments: prod);
              },
            ),
          ],
        ),
      ),
    );
  }
}
