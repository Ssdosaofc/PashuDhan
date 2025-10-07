import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pashu_dhan/Presentation/Common/custom_snackbar.dart';
import 'package:pashu_dhan/Presentation/Screens/Landing/HomeScreen.dart';

import '../../../Core/Constants/assets_constants.dart';
import '../../../Core/Constants/color_constants.dart';
import '../../Common/Widgets/info_card.dart';
import '../../Common/Widgets/primary_button.dart';
import '../../Common/Widgets/text_box.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/auth_bloc/auth_event.dart';
import '../../bloc/auth_bloc/auth_state.dart';
import '../Landing/Dashboard/Dashboard.dart';
import 'LoginScreen.dart';
import 'package:geolocator/geolocator.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}


class _SignupscreenState extends State<Signupscreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  int range = 1;
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  String getRoleFromRange(int range) {
    switch (range) {
      case 1:
        return 'Farmer';
      case 2:
        return 'Shopkeeper';
      case 3:
        return 'Veterinarian';
      default:
        return 'Farmer';
    }
  }

  void _signup() {
    if (latitude == null || longitude == null) {
      CustomSnackbar.showSnackBar(text: 'Could not get location. Please wait or check location settings.', context: context);
      _determinePosition();
      return;
    }

    final roleStr = getRoleFromRange(range);
    context.read<AuthBloc>().add(
      SignupEvent(
        emailController.text.trim(),
        passwordController.text,
        confirmPasswordController.text,
        roleStr,
        latitude!,
        longitude!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            AssetsConstants.texture,
            fit: BoxFit.fitHeight,
            height: double.maxFinite,
            width: double.maxFinite,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: InfoCard(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthSuccess) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => HomeScreen()),
                                (route) => false,
                          );
                          CustomSnackbar.showSnackBar(text: 'Signup Successful', context: context);
                        } else if (state is AuthFailure) {
                          CustomSnackbar.showSnackBar(text: state.error, context: context);
                        }
                      },
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome to PashuDhan!',
                              style: TextStyle(
                                  color: ColorConstants.c1C5D43,
                                  fontSize: 27,
                                  fontWeight: FontWeight.w900),
                            ),
                            Text(
                              'Sign Up to Get Started.',
                              style: TextStyle(
                                  color: ColorConstants.c1C5D43,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 25),
                            TextInputField(
                              label: 'Email',
                              hint: 'johnsmith18@example.com',
                              controller: emailController,
                              prefixIcon: Icons.email_outlined,
                            ),
                            const SizedBox(height: 15),
                            TextInputField(
                              label: 'Password',
                              hint: '••••••',
                              controller: passwordController,
                              prefixIcon: Icons.password_outlined,
                              obscure: true,
                            ),
                            const SizedBox(height: 15),
                            TextInputField(
                              label: 'Confirm Password',
                              hint: '••••••',
                              controller: confirmPasswordController,
                              prefixIcon: Icons.password_outlined,
                              obscure: true,
                            ),
                            const SizedBox(height: 15),
                            Container(
                              width: double.maxFinite,
                              height: 50,
                              decoration: BoxDecoration(
                                border:
                                Border.all(color: ColorConstants.c999999),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 15),
                                  Text(
                                    'Sign up as:',
                                    style: TextStyle(
                                        color: ColorConstants.c999999),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: DropdownButton(
                                      value: range,
                                      isExpanded: true,
                                      menuMaxHeight: 200,
                                      style: const TextStyle(color: Colors.black),
                                      dropdownColor: Colors.white,
                                      icon: const Icon(
                                        Icons.arrow_drop_down_outlined,
                                        color: Colors.black,
                                      ),
                                      items: const [
                                        DropdownMenuItem(
                                            value: 1,
                                            child: Text(
                                              'Farmer',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                        DropdownMenuItem(
                                            value: 2,
                                            child: Text(
                                              'Shopkeeper',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                        DropdownMenuItem(
                                            value: 3,
                                            child: Text(
                                              'Veterinarian',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                      ],
                                      onChanged: (v) {
                                        setState(() {
                                          range = v!;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                ],
                              ),
                            ),
                            const SizedBox(height: 25),
                            PrimaryButton(
                              onPressed: () {
                                _signup();
                              },
                              text: "Sign Up",
                            ),
                            const SizedBox(height: 15),
                            TextButton(
                              onPressed: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Loginscreen())),
                              child: Text(
                                'Already have an account? Login',
                                style: TextStyle(
                                    color: Colors.grey[800], fontSize: 15),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
