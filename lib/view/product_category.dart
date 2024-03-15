import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:test_app1/model/model_class.dart';
import 'package:test_app1/view/product_list_page.dart';

class ProductCategoriesPage extends StatelessWidget {
  final Merchant merchant;

  const ProductCategoriesPage({super.key, required this.merchant});

  Future<List<String>> _fetchProductCategories() async {
    final url = 'http://test.needoo.in/merchant/3/?page=2';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic> categories = data['results']['product_categories'];
        return categories.map((category) => category.toString()).toList();
      } else {
        throw Exception('Failed to load product categories');
      }
    } catch (e) {
      print('Error fetching product categories: $e');
      throw Exception('Failed to load product categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<String>>(
        future: _fetchProductCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<String> categories = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        String category = categories[index];
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: ListTile(
                            title: Text(category),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductListPage(
                                    selectedMerchant: merchant,
                                    selectedCategory: category,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
