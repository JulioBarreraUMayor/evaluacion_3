import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/productos.dart';

class ProductWidget extends StatelessWidget {
  final String name;
  final String price;

  ProductWidget({required this.name, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.orange, // ESTO ES EL FONDO
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              color: Colors.white, // ESTO ES EL TEXTO!!
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              color: Colors.white, // ESTO TAMBIEN ES TEXTO
            ),
          ),
        ],
      ),
    );
  }
}

class ProductListOverlay extends StatelessWidget {
  final List<ProductWidget> products;

  ProductListOverlay({required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Text("En el carrito..."),
        GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Para cerrar cuando hagas click en otra parte de la pantalla
              },
              child: Container(
                color: Colors.white, // el color del fondo del widget
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: products,
                    ),
                  ),
                ),
              ),
            )
      ],
      ),
      floatingActionButton: Row(
        children: [
         FloatingActionButton(
            child: const Icon(Icons.confirmation_num),
            onPressed: () {
              Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.green,
                      title: Text('COMPRA COMPLETADA', style: TextStyle(color: Colors.white)),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('ACEPTAR', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    );
                  },
                );
        },
        
      ),
        ] 
    ),
    );
   
  }
}