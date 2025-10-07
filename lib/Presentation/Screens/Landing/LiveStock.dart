import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pashu_dhan/Presentation/Common/custom_snackbar.dart';
import '../../../Core/Constants/assets_constants.dart';
import '../../../Core/Constants/color_constants.dart';
import '../../../Presentation/bloc/animal_bloc/animal_bloc.dart';
import '../../../Presentation/bloc/animal_bloc/animal_event.dart';
import '../../../Presentation/bloc/animal_bloc/animal_state.dart';
import '../../Common/Widgets/livestock_card.dart';
import 'Dashboard/animal_dashboard.dart';

class Livestock extends StatefulWidget {
  final VoidCallback? onBack;
  const Livestock({super.key, this.onBack});

  @override
  State<Livestock> createState() => _LivestockState();
}

class _LivestockState extends State<Livestock> {
  String _searchQuery = "";
  String _selectedSort = "NewToOld";

  @override
  void initState() {
    super.initState();
    context.read<AnimalBloc>().add(GetAnimalsEvent());
  }

  void _filterLivestock(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _changeSort(String sort) {
    setState(() {
      _selectedSort = sort;
    });
  }

  String _getImageForAnimal(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('cow')) return AssetsConstants.cow;
    if (lower.contains('goat')) return AssetsConstants.goat;
    if (lower.contains('sheep')) return AssetsConstants.sheeps;
    if (lower.contains('duck')) return AssetsConstants.duck;
    if (lower.contains('camel')) return AssetsConstants.camel;
    if (lower.contains('horse')) return AssetsConstants.horse;
    if (lower.contains('hen')) return AssetsConstants.hen;
    return AssetsConstants.female_buffalo;
  }

  List<dynamic> _applySorting(List<dynamic> animals) {
    if (_selectedSort == "NewToOld") {
      return animals.reversed.toList();
    } else {
      return animals;
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
            widget.onBack?.call();
          },
        ),
        title: const Text(
          "Livestock",
          style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
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

          // Sorting chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                ChoiceChip(
                  label: Text(
                    "New to Old",
                    style: TextStyle(
                      color: _selectedSort == "NewToOld"
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  selected: _selectedSort == "NewToOld",
                  selectedColor: Colors.black,
                  checkmarkColor: Colors.white,
                  backgroundColor: Colors.white,
                  shape: StadiumBorder(
                    side: BorderSide(color: Colors.black, width: 1),
                  ),
                  onSelected: (selected) => _changeSort("NewToOld"),
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: Text(
                    "Old to New",
                    style: TextStyle(
                      color: _selectedSort == "OldToNew"
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  selected: _selectedSort == "OldToNew",
                  selectedColor: Colors.black,
                  checkmarkColor: Colors.white,
                  backgroundColor: Colors.white,
                  shape: StadiumBorder(
                    side: BorderSide(color: Colors.black, width: 1),
                  ),
                  onSelected: (selected) => _changeSort("OldToNew"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: BlocListener<AnimalBloc, AnimalState>(
              listener: (context, state) {
                if (state is AnimalSuccess && state.lastAction==AnimalAction.delete) {
                  CustomSnackbar.showSnackBar(text: "Deleted successfully", context: context);
                } else if (state is AnimalFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error: ${state.error}"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: BlocBuilder<AnimalBloc, AnimalState>(
                builder: (context, state) {
                  if (state is AnimalLoading) {
                    return const Center(child: CircularProgressIndicator(color: ColorConstants.c1C5D43,));
                  } else if (state is AnimalFailure) {
                    return Center(child: Text("Error: ${state.error}"));
                  } else if (state is AnimalSuccess) {
                    List animals = state.animals ?? [];
                    if (_searchQuery.isNotEmpty) {
                      animals = animals
                          .where((a) => a.name
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()))
                          .toList();
                    }
                    animals = _applySorting(animals);

                    if (animals.isEmpty) {
                      return const Center(child: Text("No livestock found"));
                    }

                    return ListView.builder(
                      itemCount: animals.length,
                      itemBuilder: (context, index) {
                        final animal = animals[index];

                        return LivestockCard(
                          animal: animal,
                          onDelete: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                backgroundColor: ColorConstants.cFFFFFF,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                title: const Text(
                                  "Delete Animal?",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: Text("Are you sure you want to delete ${animal.name}?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text("Cancel", style: TextStyle(color: ColorConstants.c000000)),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text("Delete", style: TextStyle(color: Colors.white)),
                                    onPressed: () => Navigator.of(context).pop(true),
                                  ),
                                ],
                              ),
                            );
                            if (confirm ?? false) {
                              context.read<AnimalBloc>().add(DeleteAnimalEvent(animalId: animal.id));
                            }
                          },
                          onTap: () {
                            final imageAsset = _getImageForAnimal(animal.name);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnimalDetailScreen(
                                  animalId: animal.id,
                                  imageAsset: imageAsset,
                                  animal: animal,),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
