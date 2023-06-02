import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  //url de firebase
  final String _baseUrl = 'saludonline-dev-default-rtdb.firebaseio.com';

  final List<Product> products = [];

  late Product selectedProduct;

  bool isLoading = true;
  bool isSaving = false;

  ProductsService() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    try {
      isLoading = true;
      notifyListeners();
      final url = Uri.https(_baseUrl, 'lawyers/products.json');

      final resp = await http.get(url);
      final Map<String, dynamic> productsMap = json.decode(resp.body);

      productsMap.forEach((key, value) {
        final tempProduct = Product.fromJson(value);
        tempProduct.id = key;
        products.add(tempProduct);
      });
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
    return products;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      await createProduct(product);
    } else {
      await updateProduct(product);
    }
    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'lawyers/products/${ product.id }.json');
    final resp = await http.put(url, body: product.toRawJson());

    final decoreData = resp.body;

    print(decoreData);

    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;
    return product.id!;
  }
  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'lawyers/products.json');
    final resp = await http.post(url, body: product.toRawJson());

    final decoreData = json.decode(resp.body);

    product.id = decoreData['name'];
    products.add(product);

    print(decoreData);

    return product.id!;
  }
}
