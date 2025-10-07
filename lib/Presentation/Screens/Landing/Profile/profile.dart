import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pashu_dhan/Core/Constants/color_constants.dart';
import '../../../../Data/datasource/local/local_datasource.dart';
import '../../../bloc/animal_bloc/animal_bloc.dart';
import '../../../bloc/animal_bloc/animal_state.dart';
import '../../../bloc/auth_bloc/auth_bloc.dart';
import '../../../bloc/auth_bloc/auth_event.dart';
import '../../../bloc/auth_bloc/auth_state.dart';
import '../../Auth/LoginScreen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool notificationsEnabled = false;
  bool darkModeEnabled = false;

  void _performLogout(BuildContext context) async {
    final localDatasource = LocalDatasource();
    await localDatasource.clearAccessToken();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Loginscreen()),
          (route) => false,
    );
  }

  void _editProfile(String currentName, String currentRole, String currentPhone) {
    TextEditingController nameController = TextEditingController(text: currentName);
    TextEditingController roleController = TextEditingController(text: currentRole);
    TextEditingController phoneController = TextEditingController(text: currentPhone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Edit Profile",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: roleController,
                decoration: InputDecoration(
                  labelText: "Role",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.c1C5D43,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  final newName = nameController.text.trim();
                  final newRole = roleController.text.trim();
                  final newPhone = phoneController.text.trim();

                  if (newName.isEmpty || newPhone.isEmpty) return;

                  // Trigger update event
                  context.read<AuthBloc>().add(UpdateProfileEvent(
                    name: newName,
                    role: newRole,
                    phoneNumber: newPhone,
                  ));

                  Navigator.pop(context);
                },
                child: const Text("Save", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        String userName = "Guest";
        String userRole = "Unknown";
        String userPhoneNumber = "";

        if (authState is UpdateProfileSuccess) {
          userName = authState.user.name ?? "Guest";
          userRole = authState.user.role;
          userPhoneNumber = authState.user.phoneNumber ?? "";
        }
        if(authState is AuthSuccess){
          userName = authState.name ?? "Guest";
          userPhoneNumber = authState.phoneNumber ?? "";
          userRole = authState.role ?? "Unknown";
        }

        return Scaffold(
          backgroundColor: ColorConstants.cF2F2F2,
          body: SafeArea(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: ColorConstants.cF2F2F2,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: const Text(
                    "Profile",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [ColorConstants.c1C5D43, ColorConstants.c0F52BA],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 46,
                              backgroundImage: NetworkImage(
                                  "https://i.pravatar.cc/150?img=5"),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => _editProfile(userName, userRole,userPhoneNumber),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.edit, size: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(userName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(userRole,
                          style:
                          const TextStyle(color: Colors.white70, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(userPhoneNumber,
                          style: const TextStyle(color: Colors.white70, fontSize: 16)),

                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Stats Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: BlocBuilder<AnimalBloc, AnimalState>(
                    builder: (context, state) {
                      int? totalCount = 0;
                      int? monthlyCount = 0;

                      if (state is AnimalSuccess) {
                        totalCount = state.totalCount;
                        monthlyCount = state.monthlyCount;
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _statCard("Total Livestock", totalCount.toString(), Icons.pets, Colors.teal),
                          _statCard("Added This Month", monthlyCount.toString(), Icons.add_circle, Colors.orange),
                          _statCard("Feed Remaining", "7 Days", Icons.inventory, Colors.green),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Quick Actions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _quickAction(Icons.edit, "Edit", () => _editProfile(userName, userRole,userPhoneNumber)),
                      _quickAction(Icons.add, "Add Animal", () {}),
                      _quickAction(Icons.bar_chart, "Reports", () {}),
                      _quickAction(Icons.settings, "Settings", () {}),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      SwitchListTile(
                        activeColor: Colors.white,
                        activeTrackColor: ColorConstants.c1C5D43,
                        inactiveThumbColor: Colors.black,
                        inactiveTrackColor: Colors.white,
                        title: const Text("Notifications"),
                        secondary: const Icon(Icons.notifications),
                        value: notificationsEnabled,
                        onChanged: (val) {
                          setState(() {
                            notificationsEnabled = val;
                          });
                        },
                      ),
                      SwitchListTile(
                        activeColor: Colors.white,
                        activeTrackColor: ColorConstants.c1C5D43,
                        inactiveThumbColor: Colors.black,
                        inactiveTrackColor: Colors.white,
                        title: const Text("Dark Mode"),
                        secondary: const Icon(Icons.dark_mode),
                        value: darkModeEnabled,
                        onChanged: (val) {
                          setState(() {
                            darkModeEnabled = val;
                          });
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.info),
                        title: const Text("About App"),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {},
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text("Logout",
                            style: TextStyle(color: Colors.red)),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                backgroundColor: ColorConstants.cFFFFFF,
                                title: const Text(
                                  "Confirm Logout ?",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: const Text(
                                    "Are you sure you want to logout?"),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.black),
                                      )),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorConstants.c1C5D43,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _performLogout(context);
                                      },
                                      child: const Text(
                                        "Logout",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ],
                              ));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            radius: 20,
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(title,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _quickAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.green[50],
            child: Icon(icon, color: Colors.green, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
