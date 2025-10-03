import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting
import 'package:pashu_dhan/Presentation/Common/custom_snackbar.dart';

import '../../../../Core/Constants/color_constants.dart';
import '../../../../Domain/entities/treatment_entity.dart'; // Assuming this defines your Treatment class

class AnimalDetailScreen extends StatefulWidget {
  final String animalId;
  final String imageAsset;

  const AnimalDetailScreen({
    super.key,
    required this.animalId,
    required this.imageAsset,
  });

  @override
  State<AnimalDetailScreen> createState() => _AnimalDetailScreenState();
}

class _AnimalDetailScreenState extends State<AnimalDetailScreen> {
  final List<Treatment> treatmentHistory = [
    Treatment(date: "Sep 25, 2025", drugName: "Amoxicillin", dosage: "500 mg", reason: "Respiratory Infection"),
    Treatment(date: "Aug 12, 2025", drugName: "Ivermectin", dosage: "20 ml", reason: "Deworming (Prophylactic)"),
    Treatment(date: "Jul 30, 2025", drugName: "Tylosin", dosage: "350 mg", reason: "Foot Rot (Therapeutic)"),
    Treatment(date: "Jun 05, 2025", drugName: "Vitamin B Complex", dosage: "15 ml", reason: "Nutritional Supplement"),
  ];

  DateTime _selectedDate = DateTime.now();
  String? _selectedReason;


  final List<String> _treatmentReasons = [
    "Respiratory Infection",
    "Deworming (Prophylactic)",
    "Foot Rot (Therapeutic)",
    "Nutritional Supplement",
    "Vaccination",
    "Injury",
    "Other"
  ];


  void _showAddTreatmentDialog() {
    final drugController = TextEditingController();
    final dosageController = TextEditingController();


    _selectedDate = DateTime.now();
    _selectedReason = null;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              title: const Text(
                "Add New Treatment",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(height: 20, thickness: 1, color: Colors.grey),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Date: ${DateFormat('MMM dd, yyyy').format(_selectedDate)}",
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: ColorConstants.c1C5D43,
                                      onPrimary: Colors.white,
                                      onSurface: Colors.black,
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor: ColorConstants.c1C5D43,
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null && picked != _selectedDate) {
                              setState(() {
                                _selectedDate = picked;
                              });
                            }
                          },
                          child: const Text("Change", style: TextStyle(color: ColorConstants.c1C5D43)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: drugController,
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(color: Colors.black),
                        labelText: "Drug Name",
                        focusColor: Colors.black,
                        hintText: "e.g., Amoxicillin",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black)
                        ),
                        prefixIcon: Icon(Icons.medical_services_outlined,color: Colors.grey[800],),
                      ),
                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      controller: dosageController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(color: Colors.black),
                        focusColor: Colors.black,
                        labelText: "Dosage",
                        hintText: "e.g., 500 mg or 20 ml",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        prefixIcon: Icon(Icons.opacity,color: Colors.grey[800],),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Reason Dropdown
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(color: Colors.black),
                        labelText: "Reason for Treatment",
                        focusColor: Colors.black,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        prefixIcon: Icon(Icons.info_outline,color: Colors.grey[800],),
                      ),
                      value: _selectedReason,
                      hint: const Text("Select a reason"),
                      items: _treatmentReasons.map((String reason) {
                        return DropdownMenuItem<String>(
                          value: reason,
                          child: Text(reason),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedReason = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey,
                  ),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.c1C5D43,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {
                    if (drugController.text.isNotEmpty &&
                        dosageController.text.isNotEmpty &&
                        _selectedReason != null) {
                      final newTreatment = Treatment(
                        date: DateFormat('MMM dd, yyyy').format(_selectedDate),
                        drugName: drugController.text,
                        dosage: dosageController.text,
                        reason: _selectedReason!,
                      );

                      setState(() {
                        treatmentHistory.insert(0, newTreatment);
                      });

                      Navigator.pop(dialogContext);
                    } else {
                      CustomSnackbar.showSnackBar(text: 'Please fill all fields', context: context);
                    }
                  },
                  child: const Text("Save Treatment", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.cF2F2F2,
      appBar: AppBar(
        backgroundColor: ColorConstants.c1C5D43,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Animal Details",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildHeaderCard(),
          const SizedBox(height: 16),
          _buildWithdrawalStatusCard(),
          const SizedBox(height: 20),
          _buildTreatmentHistorySection(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTreatmentDialog, // Now calls the attractive dialog
        backgroundColor: ColorConstants.c1C5D43,
        child: const Icon(Icons.add, color: Colors.white,),
        tooltip: 'Add New Treatment',
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                widget.imageAsset,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.animalId,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Healthy",
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.tag, "ID: #1001"),
                  const SizedBox(height: 4),
                  _buildInfoRow(Icons.cake, "Age: 3 Years"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
      ],
    );
  }

  Widget _buildWithdrawalStatusCard() {
    return Card(
      color: Colors.green.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.green.shade200),
      ),
      elevation: 0,
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
                  Text(
                    "Safe for Market",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  Text("No active withdrawal period."),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreatmentHistorySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Treatment History",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (treatmentHistory.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Center(
              child: Text(
                "No treatment history found.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: treatmentHistory.length,
            itemBuilder: (context, index) {
              final treatment = treatmentHistory[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        treatment.date,
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        treatment.drugName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Reason: ${treatment.reason}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Dosage: ${treatment.dosage}",
                          style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
                        ),
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
}