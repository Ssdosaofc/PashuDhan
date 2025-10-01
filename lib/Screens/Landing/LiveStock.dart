import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Core/Constants/assets_constants.dart';
import '../../Core/Constants/color_constants.dart';

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
    'Cow - A003',
    'Goat - B102',
    'Sheep - C306',
    'Cow - A001',
    'Cow - A002',
    'Goat - B101',
    'Sheep - C305',
    'Cow - A003',
    'Goat - B102',
    'Sheep - C306',
  ];

  List<String> _filteredList = [];

  @override
  void initState() {
    super.initState();
    _filteredList = _livestockList;
  }

  void _filterLivestock(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredList = _livestockList;
      } else {
        _filteredList = _livestockList
            .where((item) =>
            item.toLowerCase().contains(query.toLowerCase().trim()))
            .toList();
      }
    });
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
                } else {
                  imageAsset = AssetsConstants.sheeps;
                }

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Image.asset(
                      imageAsset,
                      width: 40,
                      height: 40,
                    ),
                    title: Text(item),
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
