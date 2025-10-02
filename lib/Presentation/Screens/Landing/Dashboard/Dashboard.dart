
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pashu_dhan/Presentation/Common/custom_snackbar.dart';
import '../../../../Core/Constants/assets_constants.dart';
import '../../../../Core/Constants/color_constants.dart';
import '../LiveStock.dart';
import '../Profile/profile.dart';

class Dashboard extends StatefulWidget {
  final VoidCallback? goToLivestock;
  const Dashboard({super.key, this.goToLivestock});

  @override
  State<Dashboard> createState() => _DashboardState();
}



class _DashboardState extends State<Dashboard> {

  void _showConfirmationDialog(String animalName, BuildContext sheetContext) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Confirm Addition ?",style: TextStyle(fontWeight: FontWeight.bold),),
          content: Text("Are you sure you want to add a $animalName to your livestock?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel",style: TextStyle(color: Colors.black)),
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
              child: const Text("Confirm",style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(sheetContext).pop();
                CustomSnackbar.showSnackBar(
                  text: "$animalName added successfully!",
                  context: context,
                );
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
                            .where((animal) =>
                            animal.toLowerCase().contains(query.toLowerCase()))
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

                  // Animal List
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: filteredAnimals.length,
                      itemBuilder: (context, index) {
                        String animalName = filteredAnimals[index];
                        String imageAsset = allAnimals[animalName] ?? AssetsConstants.cow;

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
                                // Navigator.pop(context, animalName);
                                // CustomSnackbar.showSnackBar(
                                //   text: "$animalName added successfully!",
                                //   context: context,
                                // );
                                _showConfirmationDialog(animalName, context);
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
    return Stack(
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
              const Text(
                "Welcome back, Badam!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                DateFormat('MMMM dd, yyyy').format(DateTime.now()),
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),

        // White card content
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
              Container(
                padding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: ColorConstants.ebddc8,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _tabChip(Icons.task, "Tasks (3)"),
                    _tabChip(Icons.warning_amber, "Alerts (1)"),
                    _tabChip(Icons.insert_chart, "Reports"),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Info Cards
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Livestock(
                              onBack: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      },
                      child: _infoCard("Total Livestock", "452",
                          "+15 head this month", Icons.pets, Colors.teal),
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
                  _quickAction(AssetsConstants.feed, "Manage Feed"),
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

  Widget _infoCard(
      String title, String value, String subtitle, IconData icon, Color color) {
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
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold)),
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
