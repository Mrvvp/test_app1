import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_app1/model/model_class.dart';
import 'package:test_app1/view/carouselslider.dart';
import 'package:test_app1/view/shop_list_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedLocation = 'Location 1 (10.9916, 76.0103)';
  List<String> locations = [
    'Location 1 (10.9916, 76.0103)',
    'Location 2 (11.0023, 76.3421)',
  ];
  ShopData shopData = ShopData(
    customerId: 0,
    latitude: 0,
    longitude: 0,
    merchants: [],
    shopCategories: [],
  );

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDataFromSelectedLocation();
  }

  Future<void> fetchDataFromSelectedLocation() async {
    List<String> parts = selectedLocation.split('(');
    String coordinates = parts[1].replaceAll(')', '');
    List<String> latLng = coordinates.split(', ');

    double latitude = double.parse(latLng[0]);
    double longitude = double.parse(latLng[1]);

    await fetchData(latitude, longitude);
  }

  Future<void> fetchData(double latitude, double longitude) async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse(
        'https://test.needoo.in/calculate_distance/9785641253/$latitude/$longitude/',
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        shopData = ShopData.fromJson(jsonDecode(response.body));
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load data');
    }
  }

  void _onLocationChanged(newValue) {
    setState(() {
      selectedLocation = newValue;
    });

    fetchDataFromSelectedLocation();
  }

  void _goToShopListPage(String category) {
    List<Merchant> filteredMerchants = shopData.merchants
        .where((merchant) => merchant.categories.contains(category))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShopListPage(merchants: filteredMerchants),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_pin,
                    color: Colors.green,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  DropdownButton<String>(
                    value: selectedLocation,
                    onChanged: _onLocationChanged,
                    items: locations.map((String location) {
                      return DropdownMenuItem<String>(
                        value: location,
                        child: Text(location),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'You will get on your doorstep !',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              if (isLoading)
                Center(child: CircularProgressIndicator())
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: shopData.shopCategories.length,
                    itemBuilder: (context, index) {
                      String category = shopData.shopCategories[index];
                      return Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade500,
                                blurRadius: 1.5,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                    backgroundImage:
                                        AssetImage('lib/images/delvry.png'),
                                    radius: 25),
                                Text(
                                  category,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  onTap: () => _goToShopListPage(category),
                                  child: Icon(Icons.arrow_forward_ios),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(color: Colors.transparent);
                    },
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: ImageSlider(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
