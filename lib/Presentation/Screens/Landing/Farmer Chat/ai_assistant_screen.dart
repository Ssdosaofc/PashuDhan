import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/Constants/assets_constants.dart';
import '../../../../Core/Constants/color_constants.dart';
import '../../../bloc/animal_bloc/animal_bloc.dart';
import '../../../bloc/animal_bloc/animal_event.dart';
import '../../../bloc/animal_bloc/animal_state.dart';
import '../Veterinarian/ChatDetailsPage.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  late List<Map<String, dynamic>> messages;

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final Dio _dio = Dio();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final userMessage = _controller.text.trim();
    setState(() {
      messages.add({
        'sender': 'Farmer',
        'text': userMessage,
        'time': _formatCurrentTime(),
      });
      _controller.clear();
    });

    Future.delayed(const Duration(milliseconds: 200), _scrollToBottom);
    _aiResponse(userMessage);
  }

  void _aiResponse(String userMessage) async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      messages.add({
        'sender': 'Vet',
        'text': 'Typing...',
        'time': _formatCurrentTime(),
        'typing': true,
      });
    });

    await Future.delayed(const Duration(seconds: 2));

    final response = await _dio.post(
      'http://127.0.0.1:5001/generate',
      data: jsonEncode({'prompt': userMessage}),
      options: Options(
        // contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );

    print(response.data);
    final pres = response.data["result"];
    setState(() => messages.removeWhere((msg) => msg['typing'] == true));

    final reply =
        "Reading your current symptoms, here is the recommendation for the next few days:";
    setState(() {
      messages.add({
        'sender': 'Vet',
        'text': reply,
        'time': _formatCurrentTime(),
      });
    });

    Future.delayed(const Duration(milliseconds: 200), _scrollToBottom);

    await Future.delayed(const Duration(seconds: 2));
    final vetPrescription = {
      "animal": pres["animal"],
      "disease": pres["disease"],
      "prescription": pres["prescription"],
      "dosage": pres["dosage"],
      "when": pres["when"],
      "duration": pres["duration"],
    };

    setState(() {
      messages.add({
        'sender': 'Vet',
        'type': 'prescription',
        'data': vetPrescription,
        'time': _formatCurrentTime(),
      });
    });

    Future.delayed(const Duration(milliseconds: 200), _scrollToBottom);
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    messages = [
      {
        'sender': 'Vet',
        'text': 'Hello, how can I help you today?',
        'time': _formatCurrentTime(),
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.cF2F2F2,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Image.asset(
            AssetsConstants.left_arrow,
            width: 24,
            height: 24,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "AI Vet Assistant",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
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
                }

                return _buildMessageBubble(
                  text: msg['text'] ?? '',
                  time: msg['time'] ?? '',
                  isVet: isVet,
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble({
    required String text,
    required String time,
    required bool isVet,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
        isVet ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isVet)
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8),
              decoration: const BoxDecoration(
                color: accentBeige,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy_outlined),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment:
              isVet ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isVet ? Colors.green : farmerBubbleColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isVet ? 4 : 16),
                      bottomRight: Radius.circular(isVet ? 16 : 4),
                    ),
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
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    color: textGrey.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
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
                      _tableValue('${data["dosage"]} times a day'),
                    ]),
                    TableRow(children: [
                      _tableCell("When"),
                      _tableValue(data["when"]),
                    ]),
                    TableRow(children: [
                      _tableCell("Duration"),
                      _tableValue('${data["duration"]} days'),
                    ]),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Prescription added to treatment list"),
                        ),
                      );
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

  void _showAnimalBottomSheet(BuildContext context) {
    showModalBottomSheet(
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
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Select Animal ID",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: ids.length,
                      itemBuilder: (context, index) {
                        print(ids[index]);
                        return ListTile(
                          title: Text("Animal ID: ${ids[index]}"),
                          leading: const Icon(Icons.pets, color: Colors.green),
                          onTap: () {
                            Navigator.pop(context);

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
      style: const TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black),
    ),
  );

  Widget _tableValue(String text) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(text),
  );

  Widget _buildMessageInput() {
    return Container(
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
              icon: const Icon(Icons.attach_file, color: Colors.green),
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
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
