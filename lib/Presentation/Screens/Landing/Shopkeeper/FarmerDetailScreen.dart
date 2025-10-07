import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../Core/Constants/color_constants.dart';
import '../../../../Data/models/farmer_model.dart';
import '../../../../Data/models/product_model.dart';
import 'package:pashu_dhan/Presentation/Common/custom_snackbar.dart';

class FarmerDetailScreen extends StatelessWidget {
  final FarmerModel farmer;
  final Function(ProductModel) onOrderConfirmed;

  const FarmerDetailScreen({Key? key, required this.farmer, required this.onOrderConfirmed}) : super(key: key);

  void _showCallDialog(BuildContext context, String phoneNumber) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Call Farmer'),
        content: Text('Do you want to call $phoneNumber?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final uri = Uri(scheme: 'tel', path: phoneNumber);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              } else {
                CustomSnackbar.showSnackBar(text: 'Could not launch phone app', context: context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: ColorConstants.c1C5D43),
            child: const Text('Call', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showOrderDialog(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Confirm Order',style: TextStyle(fontWeight: FontWeight.bold),),
        content: Text('Do you want to order ${product.productName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',style: TextStyle(color: Colors.black),),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onOrderConfirmed(product);
              CustomSnackbar.showSnackBar(text: '${product.productName} added to orders', context: context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.c1C5D43,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
            ),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.cF2F2F2,
      appBar: AppBar(
        title: Text(farmer.name ?? 'Farmer Details', style: const TextStyle(color: Colors.white)),
        backgroundColor: ColorConstants.c1C5D43,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Farmer Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))]),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: ColorConstants.c1C5D43.withOpacity(0.2),
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: ColorConstants.c1C5D43,
                      child: Text(farmer.name != null && farmer.name!.isNotEmpty ? farmer.name![0].toUpperCase() : 'F',
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(farmer.name ?? 'N/A', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Email: ${farmer.email ?? 'N/A'}', style: const TextStyle(fontSize: 14, color: Colors.black54)),
                        GestureDetector(
                          onTap: () {
                            if (farmer.phoneNumber != null && farmer.phoneNumber!.isNotEmpty) {
                              _showCallDialog(context, farmer.phoneNumber!);
                            }
                          },
                          child: Text(
                            'Phone: ${farmer.phoneNumber ?? 'N/A'}',
                            style: const TextStyle(fontSize: 14, color: Colors.blue, decoration: TextDecoration.underline),
                          ),
                        ),
                        Text('Role: ${farmer.role ?? 'N/A'}', style: const TextStyle(fontSize: 14, color: Colors.black54)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorConstants.c1C5D43)),
            ),
            const SizedBox(height: 12),
            if (farmer.products.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))]),
                child: const Center(child: Text("No products available.", style: TextStyle(color: Colors.black54))),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: farmer.products.length,
                itemBuilder: (context, index) {
                  final product = farmer.products[index];
                  return GestureDetector(
                    onTap: () => _showOrderDialog(context, product),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.shopping_basket, color: Colors.green),
                              const SizedBox(width: 12),
                              Text(product.productName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                            ],
                          ),
                          Text(product.quantity, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
