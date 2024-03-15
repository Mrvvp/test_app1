import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_app1/model/model_class.dart';
import 'package:test_app1/model/product_model.dart';
import 'package:test_app1/view/product_detials_page.dart';


class ProductListPage extends StatelessWidget {
  final Merchant selectedMerchant;
  final String selectedCategory;

  const ProductListPage(
      {Key? key,
      required this.selectedMerchant,
      required this.selectedCategory})
      : super(key: key);

  Future<List<Product>> _fetchProducts() async {
    final url = 'http://test.needoo.in/merchant/3/?page=2';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> productsData =
            jsonDecode(response.body)['results']['products'];
        List<Product> products =
            productsData.map((data) => Product.fromJson(data)).toList();
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Product>>(
        future: _fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Product> products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                Product product = products[index];

                return ExpansionTile(
                  title: Text(product.productName),
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: product.variants.length,
                      itemBuilder: (context, variantIndex) {
                        ProductVariant variant = product.variants[variantIndex];

                        bool isClickable = variant.stock;

                        return ListTile(
                          title: Text(variant.variantName),
                          subtitle:
                              Text('In Stock: ${variant.stock ? 'Yes' : 'No'}'),
                          onTap: isClickable
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailsPage(
                                        variant: variant,
                                        product: product,
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          tileColor:
                              isClickable ? Colors.white : Colors.grey[300],
                          enabled: isClickable,
                        );
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
