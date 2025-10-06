
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../Core/Constants/assets_constants.dart';
import '../../../Core/Constants/color_constants.dart';

bool loading=true;
int delay = 5;

class ChatScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const ChatScreen({super.key,this.onBack});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin{

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    delay = Random().nextInt(10) + 1;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(Duration(seconds: delay), () {
      setState(() {
        loading=false;
      });
    });
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
            if (widget.onBack != null) {
              widget.onBack!();
            }
          },
        ),
        title: const Text(
          "Talk to Vet",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          TabBar(
              controller: _tabController,
              labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: Colors.green,
              tabs: [
                Tab(text: "Chat"),
                Tab(text: "History")
              ]),
          SizedBox(height: 20,),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                FarmerChatScreen()
              ],
            ),
          )
        ],
      ),
    );
  }
}

class FarmerChatScreen extends StatefulWidget {
  const FarmerChatScreen({super.key});

  @override
  State<FarmerChatScreen> createState() => _FarmerChatScreenState();
}

class _FarmerChatScreenState extends State<FarmerChatScreen> {
  @override
  Widget build(BuildContext context) {
    return loading?Scaffold(
      backgroundColor: ColorConstants.cF2F2F2,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: ColorConstants.c1C5D43,),
          SizedBox(height: 20,),
          Text('Connecting you to the nearest Vet...')
        ],
      ),
    ):(delay<6)?Column(

    ):Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

      ],
    );
  }
}

class FarmerHistoryScreen extends StatefulWidget {
  const FarmerHistoryScreen({super.key});

  @override
  State<FarmerHistoryScreen> createState() => _FarmerHistoryScreenState();
}

class _FarmerHistoryScreenState extends State<FarmerHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}



