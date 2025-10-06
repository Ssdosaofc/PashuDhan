import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pashu_dhan/Presentation/Common/custom_snackbar.dart';

import '../../../Core/Constants/assets_constants.dart';
import '../../../Core/Constants/color_constants.dart';
import '../../../Data/datasource/local/local_datasource.dart';
import '../../Common/Widgets/info_card.dart';
import '../../Common/Widgets/primary_button.dart';
import '../../Common/Widgets/text_box.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/auth_bloc/auth_event.dart';
import '../../bloc/auth_bloc/auth_state.dart';
import '../Landing/Dashboard/Dashboard.dart';
import '../Landing/HomeScreen.dart';
import 'SignUpScreen.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final localDatasource = LocalDatasource();

  int range = 1;

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
                          final token = state.token;
                          localDatasource.writeAccessToken(token!);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => HomeScreen()),
                                (route) => false,
                          );
                          CustomSnackbar.showSnackBar(text: 'Login Successful', context: context);
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
                              'Namaste!',
                              style: TextStyle(
                                  color: ColorConstants.c1C5D43,
                                  fontSize: 35,
                                  fontWeight: FontWeight.w900),
                            ),
                            Text(
                              'Login to Get Started.',
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
                            Container(
                              width: double.maxFinite,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(color: ColorConstants.c999999),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 15),
                                  Text('Role:',
                                      style: TextStyle(
                                          color: ColorConstants.c999999)),
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
                                              style:
                                              TextStyle(color: Colors.black),
                                            )),
                                        DropdownMenuItem(
                                            value: 2,
                                            child: Text(
                                              'Shopkeeper',
                                              style:
                                              TextStyle(color: Colors.black),
                                            )),
                                        DropdownMenuItem(
                                            value: 3,
                                            child: Text(
                                              'Veterinarian',
                                              style:
                                              TextStyle(color: Colors.black),
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
                                final roleStr = getRoleFromRange(range);
                                context.read<AuthBloc>().add(
                                  LoginEvent(
                                    emailController.text.trim(),
                                    passwordController.text,
                                    roleStr,
                                  ),
                                );
                              },
                              text: "Login",
                            ),
                            const SizedBox(height: 15),
                            TextButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const Signupscreen())),
                              child: Text(
                                'Don\'t have an account? Sign up',
                                style: TextStyle(
                                    color: Colors.grey[800], fontSize: 15),
                              ),
                            )
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
