import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/productos.dart';
import '../ui/input_decorations.dart';
import 'package:flutter_application_1/services/product_service.dart';
import 'package:flutter_application_1/widgets/product_card.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/screen/screen.dart';
import 'package:flutter_application_1/widgets/shopping_card.dart';

import 'package:flutter_application_1/globals.dart' as globals;

class ListProductState extends StatefulWidget {
  @override
  ListProductScreen createState() => ListProductScreen();
}

class ListProductScreen extends State<ListProductState> {

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);

    if (productService.isLoading) return LoadingScreen();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de productos'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: TextField(
              onChanged: (text) {
                setState(() {
                   globals.searchText = text;
                });
                  print("Texto actual: " + globals.searchText);
              },
              decoration: InputDecoration(
                  hintText: 'Buscar Productos',
              ),
            ),
          ),
          // Aqui deberian ir los resultados
          Expanded(
            child: ListView.builder(
              itemCount: productService.products.length,
              itemBuilder: (BuildContext context, index) {
                if(productService.products[index].productName.toLowerCase().contains(globals.searchText.toLowerCase())) {
                   if (!globals.counts.containsKey(productService.products[index])) {
                      globals.counts[productService.products[index]] = 0;
                   }
                  return GestureDetector(
                    onTap: () {
                      print("Deberias agregar el producto."); /// AGREGA EL METER EL PRODUCTO EN EL CARRO AQUI
                      // Aqui cambio la cantidad de este objeto que hay en el carro
                      setState(() {
                        int c = globals.counts[productService.products[index]] as int;
                        globals.counts[productService.products[index]] = c + 1;
                      });
 
                    },
                    child: Stack(
                      children: [
                      ProductCard(product: productService.products[index]),
                      Positioned(
                        top: 0,
                        right: 12,
                        child: Container(
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 212, 142, 12),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            globals.counts[productService.products[index]].toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                              child: const Icon(Icons.details),
                              onPressed: () {
                               /// ESTO INVOCA LOS DETALLES
                          },
                          
                        ), 
                      ]
                    )
                  );
                } else {
                  if (index >= productService.products.length) {
                    // Aquí no se da ningun resultado
                    return Center(child: Text("0 Resultados"));
                  } else {
                    return Container();
                  }
                }
              }
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        children: [
         FloatingActionButton(
            child: const Icon(Icons.money),
            onPressed: () {

              List<ProductWidget> prod_list = List<ProductWidget>.empty(growable:  true);

              globals.counts.forEach((prod, num) {
                String prod_name = prod.productName;
                int price_num = (num * prod.productPrice);
                String prod_price = price_num.toString();

                if (price_num > 0) {
                  prod_list.add(ProductWidget(name: prod_name, price: prod_price));
                }
              }

              
              );
              if (prod_list.isNotEmpty){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      elevation: 1,
                      backgroundColor: Colors.transparent,
                      child: ProductListOverlay(products: prod_list),
                    );
                  },
                );
              }
        },
        
      ), 
      SizedBox(width: 16.0), // esto crea un espacio entre los dos botones
      FloatingActionButton(
            child: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.red,
                      title: Text('CARRITO VACIADO', style: TextStyle(color: Colors.white)),
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
              globals.counts.forEach((prod, num) {
                setState(() {
                  globals.counts[prod] = 0;
                });
              });
        },
        
      ),
        ]
    ),
    );
  }
}
