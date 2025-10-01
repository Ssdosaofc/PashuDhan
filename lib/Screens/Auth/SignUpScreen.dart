
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pashu_dhan/Screens/Auth/LoginScreen.dart';

import '../../Core/Constants/assets_constants.dart';
import '../../Core/Constants/color_constants.dart';
import '../../Core/Widgets/info_card.dart';
import '../../Core/Widgets/primary_button.dart';
import '../../Core/Widgets/text_box.dart';
import '../Landing/Dashboard.dart';

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
            padding: EdgeInsets.all(15.0),
            child: Center(
                child: InfoCard(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0,
                            // horizontal: 30.0
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Welcome to PashuDhan!',
                                style: TextStyle(color: ColorConstants.c1C5D43,fontSize: 27,
                                    fontWeight: FontWeight.w900)),
                            Text('Sign Up to Get Started.',
                                style: TextStyle(color: ColorConstants.c1C5D43,fontSize: 20,
                                    fontWeight: FontWeight.w800)),
                            SizedBox(height: 25,),
                            TextInputField(
                              label: 'Email',
                              hint: 'johnsmith18@example.com',
                              controller: emailController,
                              prefixIcon: Icons.email_outlined,
                            ),
                            SizedBox(height: 15,),
                            TextInputField(
                              label: 'Password',
                              hint: '••••••',
                              controller: passwordController,
                              prefixIcon: Icons.password_outlined,
                              obscure: true,
                            ),
                            SizedBox(height: 15,),
                            TextInputField(
                              label: 'Confirm Password',
                              hint: '••••••',
                              controller: confirmPasswordController,
                              prefixIcon: Icons.password_outlined,
                              obscure: true,
                            ),
                            SizedBox(height: 15,),
                            Container(
                              width: double.maxFinite,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(color: ColorConstants.c999999),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: 15,),
                                  Text('Sign up as:',style: TextStyle(color: ColorConstants.c999999,)),
                                  SizedBox(width: 15,),
                                  Expanded(
                                    child: DropdownButton(
                                        value: range,
                                        isExpanded: true,
                                        menuWidth: 250,
                                        style: TextStyle(color: Colors.black),
                                        dropdownColor: Colors.white,
                                        icon: Icon(Icons.arrow_drop_down_outlined,color: Colors.black,),
                                        items: [
                                          DropdownMenuItem(
                                              value: 1,
                                              child: Text('Farmer',style: TextStyle(color: Colors.black),)
                                          ),
                                          DropdownMenuItem(
                                              value: 2,
                                              child: Text('Shopkeeper',style: TextStyle(color: Colors.black))
                                          ),
                                          DropdownMenuItem(
                                              value: 3, child: Text('Veterinarian',style: TextStyle(color: Colors.black))
                                          ),
                                        ],
                                        onChanged: (v){
                                          setState(() {
                                            range = v!;
                                          });
                                        }
                                    ),
                                  ),
                                  SizedBox(width: 20,),
                                ],
                              ),
                            ),
                            SizedBox(height: 25,),
                            PrimaryButton(
                                onPressed: (){
                                  switch(range){
                                    case 1:Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
                                        Dashboard()), (Route<dynamic> route) => false);
                                    case 2:Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
                                        Dashboard()), (Route<dynamic> route) => false);
                                    case 3:Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
                                        Dashboard()), (Route<dynamic> route) => false);
                                  }
                                },
                                text: "Sign Up"
                            ),
                            SizedBox(height: 15,),
                            TextButton(
                                onPressed: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Loginscreen())),
                                child: Text('Already have an account? Login',
                                  style: TextStyle(color: Colors.grey[800],fontSize: 15),)
                            )
                          ],
                        ),
                      ),
                    )
                )

            ),
          ),
        ],
      ),
    );
  }
}
