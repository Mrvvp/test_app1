class Product {
  final int productId;
  final String productName;
  final String categoryName;
  final String subcategoryName;
  final List<ProductVariant> variants;

  Product({
    required this.productId,
    required this.productName,
    required this.categoryName,
    required this.subcategoryName,
    required this.variants,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<ProductVariant> variantsList = [];
    if (json['variants'] != null) {
      json['variants'].forEach((variant) {
        variantsList.add(ProductVariant.fromJson(variant));
      });
    }

    return Product(
      productId: json['product_id'],
      productName: json['product_name'],
      categoryName: json['category_name'],
      subcategoryName: json['subcategory_name'],
      variants: variantsList,
    );
  }
}

class ProductVariant {
  final int variantId;
  final String variantName;
  final double mrp;
  final double offerPrice;
  final bool stock;

  ProductVariant({
    required this.variantId,
    required this.variantName,
    required this.mrp,
    required this.offerPrice,
    required this.stock,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      variantId: json['variant_id'],
      variantName: json['variant_name'],
      mrp: double.parse(json['MRP']),
      offerPrice: double.parse(json['offer_price']),
      stock: json['stock'],
    );
  }
}
