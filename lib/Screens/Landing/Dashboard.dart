
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Core/Constants/assets_constants.dart';
import '../../Core/Constants/color_constants.dart';
import 'LiveStock.dart';
import 'Profile/profile.dart';

class Dashboard extends StatefulWidget {
  final VoidCallback? goToLivestock;
  const Dashboard({super.key, this.goToLivestock});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
                      onTap: widget.goToLivestock,
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
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.green[50],
          child:SvgPicture.asset(icon, width: 24, height: 24,
            color: Colors.green,),
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
