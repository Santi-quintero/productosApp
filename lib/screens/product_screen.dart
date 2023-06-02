import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productos_app/provider/product_form.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/product_image.dart';
import 'package:provider/provider.dart';

import '../ui/input_decorations.dart';

class ProductScreen extends StatelessWidget {
  static const routeName = 'Product';

  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productService.selectedProduct),
      child: _ProductBodyScreen(productService: productService),
    );
    // return _ProductBodyScreen(productService: productService);
  }
}

class _ProductBodyScreen extends StatelessWidget {
  const _ProductBodyScreen({
    required this.productService,
  });

  final ProductsService productService;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(url: productService.selectedProduct.picture),
                Positioned(
                    left: 20,
                    top: 60,
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 40,
                          color: Colors.white,
                        ))),
                Positioned(
                    right: 30,
                    top: 60,
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          size: 40,
                          color: Colors.white,
                        ))),
              ],
            ),
            const _ProductForm(),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: ()async {
          if (!productForm.isValidForm()) return;
          await productService.saveOrCreateProduct(productForm.product);
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, HomeScreen.routeName);
        },
        child: const Icon(Icons.save_as_outlined),
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm();

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _styleDecoration(),
        child: Form(
          key: productForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
          children: [
            TextFormField(
              initialValue: product.picture,
              onChanged: (value) => product.picture = value,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'url de la imagen',
                  labelText: 'Url',
                  icon: Icons.route),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              initialValue: product.name,
              onChanged: (value) => product.name = value,
              // ignore: body_might_complete_normally_nullable
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'El Nombre es obligatorio';
              },
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del producto',
                  labelText: 'Nombre',
                  icon: Icons.production_quantity_limits_outlined),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              initialValue: '${product.price}',
              onChanged: (value) => {
                if (double.tryParse(value) == null)
                  {product.price = 0}
                else
                  {product.price = double.parse(value)}
              },
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
              ],
              decoration: InputDecorations.authInputDecoration(
                  hintText: '\$150',
                  labelText: 'Precio',
                  icon: Icons.money_off_csred_outlined),
            ),
            const SizedBox(
              height: 30,
            ),
            SwitchListTile.adaptive(
              title: const Text('Disponible'),
              activeColor: Colors.indigo,
              value: product.avalaible,
              onChanged: productForm.updateAvailability,
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        )),
      ),
    );
  }

  BoxDecoration _styleDecoration() => BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 5),
            )
          ]);
}
