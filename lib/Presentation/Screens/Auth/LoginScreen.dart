
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Core/Constants/assets_constants.dart';
import '../../../Core/Constants/color_constants.dart';

import '../../Common/Widgets/info_card.dart';
import '../../Common/Widgets/primary_button.dart';
import '../../Common/Widgets/text_box.dart';
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
                // height: 400,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0,
                            // horizontal: 30.0
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Namaste!',
                                style: TextStyle(color: ColorConstants.c1C5D43,fontSize: 35,
                                    fontWeight: FontWeight.w900)),
                            Text('Login to Get Started.',
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
                                  Text('Role:',style: TextStyle(color: ColorConstants.c999999,)),
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
                                        HomeScreen()), (Route<dynamic> route) => false);
                                    case 2:Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
                                        HomeScreen()), (Route<dynamic> route) => false);
                                    case 3:Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
                                        HomeScreen()), (Route<dynamic> route) => false);
                                  }
                                },
                                text: "Login"
                            ),
                            SizedBox(height: 15,),
                            TextButton(
                              onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => Signupscreen())),
                                child: Text('Don\'t have an account? Sign up',
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
