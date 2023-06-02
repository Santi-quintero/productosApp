import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/screens/product_screen.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/loading.dart';
import 'package:productos_app/widgets/product_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = 'Home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final productService = Provider.of<ProductsService>(context);

    if (productService.isLoading) return const LoadingWidget();
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Home')),
      ),
      body: ListView.builder(
        itemCount: productService.products.length,
        itemBuilder: (context, index) => GestureDetector(
          child: ProductCard(product: productService.products[index]),
          onTap: () {
            productService.selectedProduct = productService.products[index].copy();
            Navigator.pushNamed(
            context,
            'Product',
          );
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          productService.selectedProduct = Product(avalaible: false, name: '', price: 0.0);
          Navigator.pushNamed(context, ProductScreen.routeName);
        },
      ),
    );
  }
}
