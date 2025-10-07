import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pashu_dhan/Presentation/Common/custom_snackbar.dart';
import '../../../../Core/Constants/color_constants.dart';
import '../../../../Domain/entities/animal_entity.dart';
import '../../../../Domain/entities/treatment_entity.dart';
import '../../../bloc/product_bloc/product_bloc.dart';
import '../../../bloc/product_bloc/product_event.dart';
import '../../../bloc/product_bloc/product_state.dart';

class AnimalDetailScreen extends StatefulWidget {
  final String animalId;
  final String imageAsset;
  final AnimalEntity animal;

  const AnimalDetailScreen({
    super.key,
    required this.animalId,
    required this.imageAsset,
    required this.animal,
  });

  @override
  State<AnimalDetailScreen> createState() => _AnimalDetailScreenState();
}

class _AnimalDetailScreenState extends State<AnimalDetailScreen> {
  final List<Treatment> treatmentHistory = [
    Treatment(date: "Sep 25, 2025", drugName: "Amoxicillin", dosage: "500 mg", reason: "Respiratory Infection"),
    Treatment(date: "Aug 12, 2025", drugName: "Ivermectin", dosage: "20 ml", reason: "Deworming (Prophylactic)"),
  ];

  final Map<String, List<String>> animalProducts = {
    "Cow": ["Milk", "Leather"],
    "Buffalo": ["Milk", "Leather"],
    "Goat": ["Milk", "Meat"],
    "Sheep": ["Wool", "Meat"],
    "Hen": ["Eggs", "Meat"],
    "Duck": ["Eggs", "Meat"],
    "Camel": ["Milk", "Leather"],
    "Horse": ["Leather", "Manure"],
  };

  final List<String> units = ["ml", "mg", "kg", "litre", "pcs"];

  void _showAddProductDialog() {
    String? selectedProduct;
    String? selectedUnit;
    final qtyController = TextEditingController();
    final availableProducts = animalProducts[widget.animal.name] ?? [];

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text("Add Product", style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    decoration: const InputDecoration(
                      labelText: "Select Product",
                      border: OutlineInputBorder(),
                    ),
                    value: selectedProduct,
                    items: availableProducts.map((product) {
                      return DropdownMenuItem(value: product, child: Text(product));
                    }).toList(),
                    onChanged: (value) => setState(() => selectedProduct = value),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Enter Quantity",
                      labelText: "Quantity",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    decoration: const InputDecoration(
                      labelText: "Select Unit",
                      border: OutlineInputBorder(),
                    ),
                    value: selectedUnit,
                    items: units.map((unit) {
                      return DropdownMenuItem(value: unit, child: Text(unit));
                    }).toList(),
                    onChanged: (value) => setState(() => selectedUnit = value),
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text("Cancel", style: TextStyle(color: Colors.black))),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    if (selectedProduct != null &&
                        qtyController.text.isNotEmpty &&
                        selectedUnit != null) {
                      final quantityWithUnit =
                          "${qtyController.text} $selectedUnit"; // ✅ merge quantity + unit
                      context.read<ProductBloc>().add(AddProduct(
                        id: widget.animalId.hashCode,
                        livestockId: widget.animalId,
                        productName: selectedProduct!,
                        quantity: quantityWithUnit, // ✅ send full string
                      ));
                      Navigator.pop(ctx);
                      CustomSnackbar.showSnackBar(
                        text: "${selectedProduct!} added successfully",
                        context: context,
                      );
                    } else {
                      CustomSnackbar.showSnackBar(
                          text: "Please fill all fields", context: context);
                    }
                  },
                  child: const Text("Save", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchProducts(widget.animalId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.cF2F2F2,
      appBar: AppBar(
        backgroundColor: ColorConstants.c1C5D43,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Animal Details",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            tooltip: "Add Product",
            onPressed: _showAddProductDialog,
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildHeaderCard(),
          const SizedBox(height: 16),
          _buildWithdrawalStatusCard(),
          const SizedBox(height: 20),
          _buildTreatmentHistorySection(),
          const SizedBox(height: 20),
          _buildProductSection(),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(widget.imageAsset, width: 120, height: 120),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(Icons.bookmark, widget.animal.name, Colors.black, FontWeight.bold),
                  Text(widget.animalId,
                      style:
                      const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Text("Healthy",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String text, Color color, FontWeight fontwt) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black),
        const SizedBox(width: 8),
        Text(text,
            style: TextStyle(fontSize: 16, color: color, fontWeight: fontwt)),
      ],
    );
  }

  Widget _buildWithdrawalStatusCard() {
    return Card(
      color: Colors.green.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 32),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Safe for Market",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green)),
                  Text("No active withdrawal period."),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreatmentHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Treatment History",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (treatmentHistory.isEmpty)
          const Center(
              child: Text("No treatment history found.",
                  style: TextStyle(color: Colors.grey, fontSize: 16)))
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: treatmentHistory.length,
            itemBuilder: (context, index) {
              final treatment = treatmentHistory[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(treatment.date,
                          style:
                          const TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 8),
                      Text(treatment.drugName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text("Reason: ${treatment.reason}"),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text("Dosage: ${treatment.dosage}",
                            style:
                            const TextStyle(color: Colors.black54)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildProductSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Products Ready",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProductError) {
              return Center(child: Text(state.message));
            }
            if (state is ProductLoaded) {
              final products = state.products;
              if (products.isEmpty) {
                return const Center(
                    child: Text("No products recorded yet.",
                        style: TextStyle(color: Colors.grey, fontSize: 16)));
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const Icon(Icons.shopping_bag,
                          color: ColorConstants.c1C5D43),
                      title: Text(product.productName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Quantity: ${product.quantity}"),
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
