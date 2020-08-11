import 'dart:io';

import 'package:formvalidation/src/bloc/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/producto_model.dart';

import 'package:formvalidation/src/utils/utils.dart' as utils;

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final picker = ImagePicker();
  ProductosBloc prodBloc;

  File _foto;

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductoModel producto = new ProductoModel();
  bool _guardado = false;

  @override
  Widget build(BuildContext context) {
    prodBloc = Provider.productosBloc(context);
    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    if (prodData != null) {
      producto = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.photo_size_select_actual),
              onPressed: _seleccionarFoto),
          new IconButton(icon: new Icon(Icons.camera), onPressed: _tomarFoto),
        ],
      ),
      body: new SingleChildScrollView(
          child: new Container(
        padding: EdgeInsets.all(15.0),
        child: new Form(
            key: formKey,
            child: new Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                crearBotton(),
                crearDiispobible()
              ],
            )),
      )),
      floatingActionButton: _crearBoton(context),
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: new Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () =>
          Navigator.pushNamed(context, "producto", arguments: producto),
    );
  }

  _crearNombre() {
    return new TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: new InputDecoration(labelText: "Producto"),
      validator: (value) {
        if (value.length < 3) {
          return "ingrese el nombre del producto";
        } else {
          return null;
        }
      },
      onSaved: (value) => producto.titulo = value,
    );
  }

  _crearPrecio() {
    return new TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.number,
      decoration: new InputDecoration(labelText: "Precio"),
      onSaved: (value) => producto.valor = double.parse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return "solo numeros";
        }
      },
    );
  }

  crearBotton() {
    return RaisedButton.icon(
      onPressed: _guardado ? null : submit,
      icon: new Icon(Icons.save),
      label: Text("guardar"),
      shape:
          new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.deepPurpleAccent,
      textColor: Colors.white,
    );
  }

  submit() async {
    if (!formKey.currentState.validate()) {
      return;
    }
    formKey.currentState.save();
    //print("todo ok");
    setState(() {
      _guardado = true;
    });

    if (_foto != null) {
      producto.fotoUrl = await prodBloc.subirFoto(_foto);
    }

    if (producto.id == null) {
      prodBloc.agregarProducto(producto);
    } else {
      print("editar");
      prodBloc.editarProducto(producto);
    }
    mostrarSnackbar("Registro guardado");

    setState(() {
      _guardado = false;
      Navigator.pushReplacementNamed(context, 'home');
    });
  }

  crearDiispobible() {
    return SwitchListTile(
      value: producto.disponible,
      title: new Text("Dispobible"),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        producto.disponible = value;
      }),
    );
  }

  void mostrarSnackbar(String mensaje) {
    final snack = new SnackBar(
      backgroundColor: Colors.deepPurple,
      content: Text(mensaje),
      duration: new Duration(milliseconds: 3000),
    );

    scaffoldKey.currentState.showSnackBar(snack);
  }

  void _seleccionarFoto() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      producto.fotoUrl = null;
    }

    setState(() {
      print("dentro del state ");
      _foto = File(pickedFile.path);
    });
  }

  void _tomarFoto() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _foto = File(pickedFile.path);
    });
  }

  Widget _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return Hero(
        ///esto es para evitar problema si no existe el id del producto, como cuando no se a creado
        tag: producto.id ?? "no-hero",
        child: new FadeInImage(
          placeholder: new AssetImage('assets/loading.gif'),
          image: NetworkImage(producto.fotoUrl),
          height: 300.0,
          width: double.infinity,
          fit: BoxFit.contain,
        ),
      );
    } else {
      return Center(
        //pregunta si existe la imagen
        child: (_foto == null)
            ?
            //si la imagen no existe se carga una imagen por defecto
            Image(
                image: AssetImage('assets/no-image.png'),
                height: 300.0,
                fit: BoxFit.cover)
            :
            //de lo contrario se carga la imagen cargda
            Image.file(_foto, height: 300.0, fit: BoxFit.cover),
      );
    }
  }
}
