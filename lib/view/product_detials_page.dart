import 'package:flutter/material.dart';
import 'package:test_app1/model/product_model.dart';


class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage(
      {Key? key, required this.product, required ProductVariant variant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.productName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Category: ${product.categoryName}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Variants:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: product.variants.map((variant) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Variant Name: ${variant.variantName}'),
                    Text('MRP: ${variant.mrp.toStringAsFixed(2)}'),
                    Text(
                        'Offer Price: ${variant.offerPrice.toStringAsFixed(2)}'),
                    Text('In Stock: ${variant.stock ? 'Yes' : 'No'}'),
                    Divider(),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
