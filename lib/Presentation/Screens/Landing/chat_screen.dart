import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pashu_dhan/Presentation/Common/Widgets/primary_button.dart';

import '../../../Core/Constants/assets_constants.dart';
import '../../../Core/Constants/color_constants.dart';
import '../../../Domain/entities/treatment_entity.dart';
import '../../bloc/animal_bloc/animal_bloc.dart';
import '../../bloc/animal_bloc/animal_event.dart';
import '../../bloc/animal_bloc/animal_state.dart';
import '../../bloc/treatment_bloc/treatment_bloc.dart';
import '../../bloc/treatment_bloc/treatment_event.dart';
import 'Farmer Chat/ai_assistant_screen.dart';
import 'Farmer Chat/farmer_history_screen.dart';
import 'Veterinarian/ChatDetailsPage.dart';

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
  void dispose() {
    setState(() {
      loading=true;
    });
    super.dispose();
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
                FarmerChatScreen(),FarmerHistoryScreen()
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

  final List<Map<String, dynamic>> messages = [
    {
      'sender': 'Vet',
      'text': 'Hello, how can I help you today?',
      'time': '09:15 AM',
    }
  ];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      messages.add({
        'sender': 'Farmer',
        'text': _controller.text.trim(),
        'time': _formatCurrentTime(),
      });
      _controller.clear();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    _simulateVetResponse( _controller.text.trim());
  }

  void _simulateVetResponse(String userMessage) async {

    Future.delayed(const Duration(seconds: 3), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    setState(() {
      messages.add({
        'sender': 'Vet',
        'text': 'Typing...',
        'time': _formatCurrentTime(),
        'typing': true,
      });
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      messages.removeWhere((msg) => msg['typing'] == true);
    });

    final reply = "Reading your current symptoms, this the recommendation";

    setState(() {
      messages.add({
        'sender': 'Vet',
        'text': reply,
        'time': _formatCurrentTime(),
      });
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    final vetPrescription = {
      "animal": "Cow",
      "disease": "Foot and Mouth Disease",
      "prescription": "Vaccinate with FMD vaccine.",
      "dosage":"2",
      "when": "After food",
      "duration": "7"
    };

    setState(() {
      messages.add({
        'sender': 'Vet',
        'type': 'prescription',
        'data': vetPrescription,
        'time': _formatCurrentTime(),
      });
    });

  }

  String _generateTreatment(String message) {
    message = message.toLowerCase();

    if (message.contains('fever') || message.contains('hot')) {
      return "It seems your animal has a fever. Please provide Paracetamol syrup (5ml twice daily) and keep it hydrated.";
    } else if (message.contains('cough') || message.contains('cold')) {
      return "For cough or cold, give warm water and 5ml VetCough syrup twice a day. Keep the animal in a warm place.";
    } else if (message.contains('injury') || message.contains('wound')) {
      return "Clean the wound with antiseptic and apply Betadine twice daily. If swelling persists, give Meloxicam injection (1ml/10kg).";
    } else if (message.contains('diarrhea') || message.contains('loose')) {
      return "For diarrhea, give oral rehydration solution and Norfloxacin (1 tablet twice daily). Avoid milk for 24 hours.";
    } else if (message.contains('milk') || message.contains('udder')) {
      return "It may be mastitis. Use Mastiguard ointment and inject Amoxicillin for 3 days. Consult local vet if it worsens.";
    } else {
      final responses = [
        "Please share more details about symptoms and duration.",
        "Could you specify the animal’s age and recent feed?",
        "Try isolating the animal and monitoring temperature for 24 hours.",
        "Apply basic first aid and ensure clean water access."
      ];
      return responses[Random().nextInt(responses.length)];
    }
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.cF2F2F2,
      body: RefreshIndicator(
        color: ColorConstants.c1C5D43,
        onRefresh: () async {
          setState(() {
            loading = true;
          });
          await Future.delayed(Duration(seconds: 2));
          setState(() {
            delay = Random().nextInt(10) + 1;
            loading = false;
          });
        },
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: loading?[
              CircularProgressIndicator(color: ColorConstants.c1C5D43,),
              SizedBox(height: 20,),
              Text('Connecting you to the nearest Vet...')
            ]:(delay<6)?[
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isVet = msg['sender'] == 'Vet';

                    if (msg['type'] == 'prescription') {
                      return _buildPrescriptionBubble(msg['data'], msg['time']);
                    } else {
                      final showAvatar = index == messages.length - 1 ||
                          messages[index + 1]['sender'] != msg['sender'];
                      return _buildMessageBubble(
                        text: msg['text']!,
                        time: msg['time'] ?? '',
                        isVet: !isVet,
                        showAvatar: showAvatar,
                      );
                    }
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.attach_file, color: primaryGreen),
                        onPressed: () {},
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: lightBeige.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Type your message...',
                              hintStyle: TextStyle(
                                color: textGrey.withOpacity(0.6),
                                fontSize: 15,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                            ),
                            maxLines: null,
                            textCapitalization: TextCapitalization.sentences,
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: primaryGreen,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: _sendMessage,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]:[
              Icon(Icons.health_and_safety_sharp,size: 200,),
              Text('No Vet Available Currently',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600),),
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: PrimaryButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => AiAssistantScreen())),
                    text: "Talk to AI Assistant"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble({
    required String text,
    required String time,
    required bool isVet,
    required bool showAvatar,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
        isVet ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isVet && showAvatar) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: accentBeige,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  'Dr'.toUpperCase(),
                  style: TextStyle(
                    color: primaryGreen,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ] else if (!isVet) ...[
            const SizedBox(width: 40),
          ],
          if (isVet) const SizedBox(width: 40),
          Flexible(
            child: Column(
              crossAxisAlignment:
              isVet ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isVet ? vetBubbleColor : farmerBubbleColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isVet ? 16 : 4),
                      bottomRight: Radius.circular(isVet ? 4 : 16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 15,
                      color: isVet ? Colors.white : textDark,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    time,
                    style: TextStyle(
                      fontSize: 11,
                      color: textGrey.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // if (isVet) const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildPrescriptionBubble(Map<String, dynamic> data, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 40, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Prescription",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder.all(color: Colors.grey.shade300),
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(),
                  },
                  children: [
                    TableRow(children: [
                      _tableCell("Animal"),
                      _tableValue(data["animal"]),
                    ]),
                    TableRow(children: [
                      _tableCell("Disease"),
                      _tableValue(data["disease"]),
                    ]),
                    TableRow(children: [
                      _tableCell("Prescription"),
                      _tableValue(data["prescription"]),
                    ]),
                    TableRow(children: [
                      _tableCell("Dosage"),
                      _tableValue(data["dosage"]+' times in a day'),
                    ]),
                    TableRow(children: [
                      _tableCell("When"),
                      _tableValue(data["when"]),
                    ]),
                    TableRow(children: [
                      _tableCell("Duration"),
                      _tableValue(data["duration"]+' days'),
                    ]),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      print(data);
                      context
                          .read<AnimalBloc>()
                          .add(FetchAnimalIdsByNameEvent(data["animal"]));
                      _showAnimalBottomSheet(context,data);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.c1C5D43,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Add to Treatment",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              time,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAnimalBottomSheet(BuildContext context, Map<String, dynamic> data) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocBuilder<AnimalBloc, AnimalState>(
          builder: (context, state) {
            if (state is AnimalIdsLoading) {
              return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()));
            } else if (state is AnimalIdsLoaded) {
              final ids = state.ids;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Select ${data["animal"]} ID",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: ids.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          tileColor: Colors.white,
                          title: Text("Animal ID: ${ids[index]}"),
                          leading: const Icon(Icons.pets, color: Colors.green),
                          onTap: () {
                            context.read<TreatmentBloc>().add(AddTreatmentEvent(
                              TreatmentEntity(
                                treatmentId:ids[index],
                                animal: data["animal"],
                              disease: data["disease"],
                              prescription: data["prescription"],
                              dosage: data["dosage"],
                              when: data["when"],
                              duration: data["duration"]
                              )
                            ));
                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Treatment added for Animal ID: ${ids[index]}"),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            } else if (state is AnimalIdsError) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            }
            return const SizedBox(height: 200);
          },
        );
      },
    );
  }


  Widget _tableCell(String text) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
  );

  Widget _tableValue(String text) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(text),
  );

}




