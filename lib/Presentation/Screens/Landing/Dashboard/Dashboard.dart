import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Core/Constants/assets_constants.dart';
import '../../../../Core/Constants/color_constants.dart';
import '../../../../Data/datasource/local/local_datasource.dart';
import '../../../Common/custom_snackbar.dart';
import '../../../bloc/animal_bloc/animal_bloc.dart';
import '../../../bloc/animal_bloc/animal_event.dart';
import '../../../bloc/animal_bloc/animal_state.dart';
import '../../../bloc/auth_bloc/auth_bloc.dart';
import '../../../bloc/auth_bloc/auth_event.dart';
import '../../../bloc/auth_bloc/auth_state.dart';
import '../LiveStock.dart';
import '../Profile/profile.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  final VoidCallback? goToLivestock;
  const Dashboard({super.key, this.goToLivestock});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late var farName="Guest";

  @override
  void initState() {
    super.initState();
    context.read<AnimalBloc>().add(GetAnimalsEvent());
    printToken();
    fetchProfile();
  }

  void printToken() async {
    final localDatasource = LocalDatasource();
    final token = await localDatasource.getAccessToken();
    print("Tokeeeen: $token");
  }

  Future<void> fetchProfile() async {
    final localDatasource = LocalDatasource();
    final token = await localDatasource.getAccessToken();

    if (token == null) {
      print("⚠️ No token found. User might not be logged in.");
      return;
    }

    final url = Uri.parse("http://10.0.2.2:5000/api/auth/profile");

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ Profile fetched: $data");
        farName=data['name'];
        context.read<AuthBloc>().add(ProfileFetched(
          role: data['role'] ?? "Unknown",
          name: data['name'] ?? "Guest",
          phoneNumber: data['phoneNumber'] ?? "",
        ));



      } else if (response.statusCode == 401) {
        print("❌ Unauthorized - token invalid or expired");
      } else {
        print("❌ Failed to fetch profile: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("⚠️ Error fetching profile: $e");
    }
  }



  void _showConfirmationDialog(String animalName, String animalType, BuildContext sheetContext) {

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Confirm Addition ?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text("Are you sure you want to add a $animalName to your livestock?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel", style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Confirm", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(sheetContext).pop();

                context.read<AnimalBloc>().add(AddAnimalEvent(
                  name: animalName,
                  type: animalType,
                ));
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddAnimalSheet() {
    final TextEditingController searchController = TextEditingController();

    final Map<String, String> allAnimals = {
      "Cow": AssetsConstants.cow,
      "Goat": AssetsConstants.goat,
      "Sheep": AssetsConstants.sheeps,
      "Buffalo": AssetsConstants.female_buffalo,
      "Hen": AssetsConstants.hen,
      "Camel": AssetsConstants.camel,
      "Horse": AssetsConstants.horse,
      "Duck": AssetsConstants.duck,
    };

    List<String> filteredAnimals = allAnimals.keys.toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: ColorConstants.cF2F2F2,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Add Animal",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: searchController,
                    onChanged: (query) {
                      setState(() {
                        filteredAnimals = allAnimals.keys
                            .where((animal) => animal.toLowerCase().contains(query.toLowerCase()))
                            .toList();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search animal...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: filteredAnimals.length,
                      itemBuilder: (context, index) {
                        final animalName = filteredAnimals[index];
                        final imageAsset = allAnimals[animalName] ?? AssetsConstants.cow;

                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: Image.asset(
                              imageAsset,
                              width: 48,
                              height: 48,
                              fit: BoxFit.contain,
                            ),
                            title: Text(animalName,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                            trailing: IconButton(
                              icon: const Icon(Icons.add_circle, color: Colors.teal, size: 28),
                              onPressed: () {
                                _showConfirmationDialog(animalName, animalName, context);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AnimalBloc, AnimalState>(
          listener: (context, state) {
            if (state is AnimalSuccess && state.animal != null) {
              CustomSnackbar.showSnackBar(
                text: "${state.animal!.name} added successfully!",
                context: context,
              );
            } else if (state is AnimalFailure) {
              CustomSnackbar.showSnackBar(
                text: "Failed to add animal: ${state.error}",
                context: context,
              );
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is UpdateProfileSuccess) {
              CustomSnackbar.showSnackBar(
                text: "Profile updated successfully! Welcome ${state.user.name}",
                context: context,
              );
            } else if (state is UpdateProfileFailure) {
              CustomSnackbar.showSnackBar(
                text: "Failed to update profile: ${state.error}",
                context: context,
              );
            }
          },
        ),
      ],
      child: Stack(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: ColorConstants.c1C5D43,
            ),
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(AssetsConstants.cow,width: 40,height: 40,),
                        const Text(
                          "PashuDhan",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(AssetsConstants.notification, width: 24, height: 24,),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ProfilePage()),
                            );
                          },
                          child: const CircleAvatar(
                            backgroundImage: NetworkImage(
                              "https://i.pravatar.cc/150?img=5",
                            ),
                            radius: 18,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 16),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    String user = "Guest";
                    if (state is UpdateProfileSuccess) {
                      user = state.user.name ?? "Guest";
                    }
                    return Text(
                      "Welcome back, $farName!",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 6),
                Text(
                  DateFormat('MMMM dd, yyyy').format(DateTime.now()),
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 180),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                )
              ],
            ),
            child: ListView(
              padding: const EdgeInsets.only(left: 16,right: 16,top: 16),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<AnimalBloc, AnimalState>(
                        builder: (context, state) {
                          int? totalCount = 0;
                          int? monthlyCount=0;

                          if (state is AnimalSuccess) {
                            totalCount = state.totalCount;
                            monthlyCount = state.monthlyCount;
                          }

                          return _infoCard(
                            "Total Livestock",
                            totalCount.toString(),
                            "+${monthlyCount.toString()} head this month",
                            Icons.pets,
                            Colors.teal,
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 12),
                    Expanded(
                      child: _infoCard("Feed Remaining (Days)", "7",
                          "Order soon", Icons.inventory, Colors.orange),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Text("Quick Actions",
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _quickAction(AssetsConstants.add, "Add Animal"),
                    _quickAction(AssetsConstants.health, "New Health Log"),
                    _quickAction(AssetsConstants.calendar, "View Calendar"),
                  ],
                ),

                const SizedBox(height: 20),

                Text("Recent Activity",
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                _activityItem("Vaccination: Herd A (Cattle)", true),
                _activityItem("Birth: Lamb (ID: #L-2023-045)", false),
                _activityItem("Feed Low: Barn C (Goats)", false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabChip(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.black54, size: 18),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _infoCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 8),
              Text(value,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          Text(subtitle,
              style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        ],
      ),
    );
  }

  Widget _quickAction(String icon, String label) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (label == "Add Animal") {
              _showAddAnimalSheet();
            }
          },
          child: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.green[50],
            child: SvgPicture.asset(
              icon,
              width: 28,
              height: 28,
              color: Colors.green,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _activityItem(String text, bool success) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(success ? Icons.check_circle : Icons.error_outline,
          color: success ? Colors.green : Colors.orange),
      title: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }
}
