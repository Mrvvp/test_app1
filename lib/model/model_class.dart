class Merchant {
  final String name;
  final double distance;
  final List<String> categories;

  Merchant({
    required this.name,
    required this.distance,
    required this.categories,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      name: json['name'],
      distance: json['distance'].toDouble(),
      categories: List<String>.from(json['categories']),
    );
  }

  get id => null;
}

class ShopData {
  final int customerId;
  final double latitude;
  final double longitude;
  final List<Merchant> merchants;
  final List<String> shopCategories;

  ShopData({
    required this.customerId,
    required this.latitude,
    required this.longitude,
    required this.merchants,
    required this.shopCategories,
  });

  factory ShopData.fromJson(Map<String, dynamic> json) {
    List<Merchant> merchantsList = [];
    if (json['merchants'] != null) {
      json['merchants'].forEach((merchant) {
        merchantsList.add(Merchant.fromJson(merchant));
      });
    }

    return ShopData(
      customerId: json['customer_id'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      merchants: merchantsList,
      shopCategories: List<String>.from(json['shop_categories']),
    );
  }
}
