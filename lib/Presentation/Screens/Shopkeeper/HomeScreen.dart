import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Core/Constants/color_constants.dart';
import '../../../Data/models/farmer_model.dart';
import '../../../Data/models/product_model.dart';
import '../../Common/custom_snackbar.dart';
import 'FarmerDetailScreen.dart';
import '../Landing/Profile/profile.dart';
import 'ProfileScreen.dart';

class ShopkeeperScreen extends StatefulWidget {
  const ShopkeeperScreen({Key? key}) : super(key: key);

  @override
  State<ShopkeeperScreen> createState() => _ShopkeeperScreenState();
}

class _ShopkeeperScreenState extends State<ShopkeeperScreen> {
  final String geoapifyApiKey = "cce9e175424847a8bdd3a691c60c80cf";
  int _currentIndex = 0;

  late final MapController _mapController = MapController();
  LatLng _currentCenter = LatLng(28.6139, 77.2090);
  double _currentZoom = 10;

  List<ProductModel> _orders = [];

  List<FarmerModel> farmers = [
    FarmerModel(
      name: "Kunal",
      email: "kunal@gmail.com",
      phoneNumber: "8445408588",
      role: 'Farmer',
      lat: 23.79759,
      lng: 86.42992,
      products: [
        ProductModel(productName: "Milk", quantity: "10L", id: 0, livestockId: ''),
      ],
    ),
    FarmerModel(
      name: "Ramesh",
      email: "ramesh@example.com",
      phoneNumber: "9876543210",
      lat: 28.6200,
      role: 'Farmer',
      lng: 77.2150,
      products: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0
              ? 'Map'
              : _currentIndex == 1
              ? 'Orders'
              : 'Profile',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorConstants.c1C5D43,
      ),
      body: Stack(
        children: [
          _currentIndex == 0
              ? _buildMapScreen()
              : _currentIndex == 1
              ? _buildOrdersScreen()
              : ProfileShopkeeperPage(),
          if (_currentIndex == 0)
            Positioned(
              bottom: 16,
              right: 16,
              child: Column(
                children: [
                  FloatingActionButton(
                    heroTag: 'zoom_in',
                    mini: true,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.add, color: Colors.black),
                    onPressed: () {
                      _currentZoom += 1;
                      _mapController.move(_currentCenter, _currentZoom);
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton(
                    heroTag: 'zoom_out',
                    mini: true,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.remove, color: Colors.black),
                    onPressed: () {
                      _currentZoom -= 1;
                      _mapController.move(_currentCenter, _currentZoom);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.map),
            title: const Text("Map"),
            selectedColor: Colors.green,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.list_alt),
            title: const Text("Orders"),
            selectedColor: Colors.orange,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Profile"),
            selectedColor: Colors.blue,
          ),
        ],
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }

  Widget _buildMapScreen() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _currentCenter,
        initialZoom: _currentZoom,
        onPositionChanged: (position, _) {
          if (position.center != null && position.zoom != null) {
            _currentCenter = position.center!;
            _currentZoom = position.zoom!;
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate:
          "https://maps.geoapify.com/v1/tile/osm-bright/{z}/{x}/{y}.png?apiKey=$geoapifyApiKey",
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: farmers
              .map(
                (farmer) => Marker(
              width: 120,
              height: 80,
              point: LatLng(farmer.lat, farmer.lng),
              child: GestureDetector(
                onTap: () => _showFarmerInfo(farmer),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Text(
                        farmer.name ?? 'Unknown',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Icon(Icons.location_on, color: Colors.red, size: 36),
                  ],
                ),
              ),
            ),
          )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildOrdersScreen() {
    if (_orders.isEmpty) {
      return const Center(
        child: Text("No orders yet", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _orders.length,
      itemBuilder: (context, index) {
        final order = _orders[index];
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const Icon(Icons.shopping_basket, color: Colors.green),
            title: Text(order.productName),
            subtitle: Text('Quantity: ${order.quantity}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  _orders.removeAt(index);
                });
                CustomSnackbar.showSnackBar(text: '${order.productName} removed from orders', context: context);
              },
            ),
          ),
        );
      },
    );
  }


  void _showFarmerInfo(FarmerModel farmer) {
    final firstProduct = farmer.products.isNotEmpty ? farmer.products.first : null;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(farmer.name ?? 'Unknown Farmer', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Email: ${farmer.email}'),
              Text('Phone: ${farmer.phoneNumber ?? 'N/A'}'),
              const SizedBox(height: 12),
              const Text('Product:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              if (firstProduct != null)
                ListTile(
                  leading: const Icon(Icons.shopping_basket, color: Colors.green),
                  title: Text(firstProduct.productName),
                  subtitle: Text('Quantity: ${firstProduct.quantity}'),
                )
              else
                const Text('No products available.'),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FarmerDetailScreen(
                        farmer: farmer,
                        onOrderConfirmed: (product) {
                          setState(() {
                            _orders.add(product);
                          });
                        },
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                label: const Text('View Details', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.c1C5D43,
                  minimumSize: const Size.fromHeight(45),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
