import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../Core/Constants/assets_constants.dart';
import '../../../Core/Constants/color_constants.dart';
import 'Dashboard/animal_dashboard.dart';

class Livestock extends StatefulWidget {
  final VoidCallback? onBack;
  const Livestock({super.key, this.onBack});

  @override
  State<Livestock> createState() => _LivestockState();
}

class _LivestockState extends State<Livestock> {
  final List<String> _livestockList = [
    'Cow - A001',
    'Cow - A002',
    'Goat - B101',
    'Sheep - C305',
    'Hen - A003',
    'Goat - B102',
    'Sheep - C306',
    'Buffalo - A001',
    'Duck - A002',
    'Horse - B101',
    'Sheep - C305',
    'Cow - A003',
    'Goat - B102',
    'Camel - C306',
  ];

  List<String> _filteredList = [];
  String _selectedSort = "NewToOld";

  @override
  void initState() {
    super.initState();
    _filteredList = List.from(_livestockList);
    // _applySorting();
  }

  void _filterLivestock(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredList = List.from(_livestockList);
      } else {
        _filteredList = _livestockList
            .where((item) =>
            item.toLowerCase().contains(query.toLowerCase().trim()))
            .toList();
      }
      _applySorting();
    });
  }

  void _applySorting() {
    if (_selectedSort == "NewToOld") {
      _filteredList = _filteredList.reversed.toList();
    } else if (_selectedSort == "OldToNew") {
      _filteredList = _filteredList.reversed.toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.cF2F2F2,
      appBar: AppBar(
        backgroundColor: ColorConstants.c1C5D43,
        leading: IconButton(
          icon: Image.asset(
            AssetsConstants.left_arrow,
            width: 24,
            height: 24,
            color: Colors.white,
          ),
          onPressed: () {
            if (widget.onBack != null) {
              widget.onBack!();
            }
          },
        ),
        title: const Text(
          "Livestock",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filterLivestock,
              decoration: InputDecoration(
                hintText: "Search livestock...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                fillColor: ColorConstants.cFAFAFA,
                filled: true,
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                ChoiceChip(
                  label: Text(
                    "New to Old",
                    style: TextStyle(
                      color: _selectedSort == "NewToOld" ? Colors.white : Colors.black,
                    ),
                  ),
                  selected: _selectedSort == "NewToOld",
                  selectedColor: Colors.black,
                  checkmarkColor: Colors.white,
                  backgroundColor: Colors.white,
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedSort = "NewToOld";
                      _applySorting();
                    });
                  },
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: Text(
                    "Old to New",
                    style: TextStyle(
                      color: _selectedSort == "OldToNew" ? Colors.white : Colors.black,
                    ),
                  ),
                  selected: _selectedSort == "OldToNew",
                  selectedColor: Colors.black,
                  checkmarkColor: Colors.white,
                  backgroundColor: Colors.white,
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedSort = "OldToNew";
                      _applySorting();
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),


          Expanded(
            child: _filteredList.isEmpty
                ? const Center(
              child: Text("No livestock found"),
            )
                : ListView.builder(
              itemCount: _filteredList.length,
              itemBuilder: (context, index) {
                final item = _filteredList[index];

                String imageAsset;
                if (item.toLowerCase().contains('cow')) {
                  imageAsset = AssetsConstants.cow;
                } else if (item.toLowerCase().contains('goat')) {
                  imageAsset = AssetsConstants.goat;
                } else if (item.toLowerCase().contains('sheep')) {
                  imageAsset = AssetsConstants.sheeps;
                } else if (item.toLowerCase().contains('duck')) {
                  imageAsset = AssetsConstants.duck;
                } else if (item.toLowerCase().contains('camel')) {
                  imageAsset = AssetsConstants.camel;
                } else if (item.toLowerCase().contains('horse')) {
                  imageAsset = AssetsConstants.horse;
                } else if (item.toLowerCase().contains('hen')) {
                  imageAsset = AssetsConstants.hen;
                } else {
                  imageAsset = AssetsConstants.female_buffalo;
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnimalDetailScreen(
                          animalId: item,
                          imageAsset: imageAsset,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              imageAsset,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Healthy | ID #${index + 1001}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              size: 18, color: Colors.grey[400]),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
