import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pashu_dhan/Core/Constants/assets_constants.dart';
import 'package:pashu_dhan/Core/Constants/color_constants.dart';

import '../../Common/Widgets/info_card.dart';
import 'LoginScreen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final CarouselSliderController _controller = CarouselSliderController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text('PashuDhan',style: TextStyle(color: ColorConstants.c1C5D43,fontSize: 25,
          fontWeight: FontWeight.w900),),backgroundColor: ColorConstants.ebddc8,),
      backgroundColor: ColorConstants.ebddc8,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Center(
                  child: PageStorage(
                    bucket: PageStorageBucket(),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CarouselSlider(
                            items: AssetsConstants.msgs.map((e)=>
                                InfoCard(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Image.asset(e['link'],
                                            height: 175,
                                          ),
                                          if(currentIndex == 0)
                                            Text('Welcome to PashuDhan',style: TextStyle(color: ColorConstants.c1C5D43,
                                              fontWeight: FontWeight.w700,fontSize: 25),
                                          ),
                                          Text(e['msg'],
                                            style: TextStyle(color: ColorConstants.c1C5D43,
                                                fontWeight: FontWeight.normal,fontSize: 15),
                                            textAlign: TextAlign.center,)
                                        ],
                                      ),
                                    )
                                )
                            ).toList(),
                            options: CarouselOptions(
                                height: MediaQuery.of(context).size.height*0.75,
                                enlargeCenterPage: true,
                                enableInfiniteScroll: false,
                                onPageChanged: (index, reason){
                                  setState(() {
                                    currentIndex = index;
                                  });
                                }
                            ),
                          ),
                          // SizedBox(height: 0.025*MediaQuery.of(context).size.height,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: AssetsConstants.msgs.asMap().entries.map((entry) {
                              return GestureDetector(
                                onTap: () => _controller.animateToPage(entry.key),
                                child: Container(
                                  width: MediaQuery.of(context).size.height*0.01,
                                  height: MediaQuery.of(context).size.height*0.01,
                                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(currentIndex == entry.key ? 0.9 : 0.4)),
                                ),
                              );
                            }).toList(),
                          ),
                        ]),
                  )
              ),
            ),
            (currentIndex == AssetsConstants.msgs.length-1)?Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Loginscreen())),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Image.asset('assets/images/start.png',width: 130,),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0,right: 10.0),
                        child: Row(
                          children: [
                            Text('Start',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w700),),
                            SizedBox(width: 10,),
                            Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ):SizedBox(height: 70,)
          ],
        ),
      ),

    );
  }
}
