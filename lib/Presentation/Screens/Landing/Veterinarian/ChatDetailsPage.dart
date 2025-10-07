import 'package:flutter/material.dart';
import 'package:pashu_dhan/Presentation/Common/Widgets/round_button.dart';
import 'package:pashu_dhan/Presentation/Screens/Landing/Veterinarian/HistoryPage.dart';
import '../../../../Core/Constants/color_constants.dart';

const Color primaryGreen = Color(0xFF2D5F4F);
const Color lightBeige = Color(0xFFF5E6D3);
const Color accentBeige = Color(0xFFE8D4B8);
const Color vetBubbleColor = Color(0xFF3D7A66);
const Color farmerBubbleColor = Color(0xFFF5E6D3);
const Color textDark = Color(0xFF2C3E50);
const Color textGrey = Color(0xFF7F8C8D);

class ChatDetailsPage extends StatefulWidget {
  final String farmerName;

  const ChatDetailsPage({Key? key, required this.farmerName}) : super(key: key);

  @override
  State<ChatDetailsPage> createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  final List<Map<String, dynamic>> messages = [
    {
      'sender': 'Vet',
      'text': 'Hello, how can I help you today?',
      'time': '09:15 AM',
    },
    {
      'sender': 'Farmer',
      'text': 'My goat has a fever, what should I do?',
      'time': '09:16 AM',
    },
    {
      'sender': 'Vet',
      'text':
      'Give paracetamol (500mg) and keep the goat well hydrated. Monitor the temperature every 4 hours.',
      'time': '09:18 AM',
    },
    {
      'sender': 'Farmer',
      'text': 'Thank you for the advice!',
      'time': '09:20 AM',
    },
  ];

  final TextEditingController _animalController = TextEditingController();
  final TextEditingController _diseaseController = TextEditingController();
  final TextEditingController _prescriptionController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _whenController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _animalController.dispose();
    _diseaseController.dispose();
    _prescriptionController.dispose();
    _dosageController.dispose();
    _whenController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      messages.add({
        'sender': 'Vet',
        'text': _controller.text.trim(),
        'time': _formatCurrentTime(),
      });
      _controller.clear();
    });

    _scrollToBottom();
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showAttachmentSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorConstants.cF2F2F2,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Attachments",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RoundButton(
                      icon: Icons.image_outlined, label: "Image", onTap: () {}),
                  RoundButton(
                      icon: Icons.file_present_outlined,
                      label: "File",
                      onTap: () {}),
                  RoundButton(
                      icon: Icons.medical_information_outlined,
                      label: "Prescription",
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              backgroundColor: ColorConstants.cFFFFFF,
                              title: const Text(
                                "Add Prescription",
                                style:
                                TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildTextField(_animalController,
                                        "Enter animal name"),
                                    const SizedBox(height: 12),
                                    _buildTextField(_diseaseController,
                                        "Enter disease name"),
                                    const SizedBox(height: 12),
                                    _buildTextField(_prescriptionController,
                                        "Prescribe the treatment"),
                                    const SizedBox(height: 12),
                                    _buildTextField(_dosageController,
                                        "Dosage (times per day)"),
                                    const SizedBox(height: 12),
                                    _buildTextField(_whenController,
                                        "When to give (e.g. after food)"),
                                    const SizedBox(height: 12),
                                    _buildTextField(_durationController,
                                        "Duration (days)"),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.black),
                                    )),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      ColorConstants.c1C5D43,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _addPrescription();
                                    },
                                    child: const Text(
                                      "Prescribe",
                                      style:
                                      TextStyle(color: Colors.white),
                                    )),
                              ],
                            ));
                      }),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  void _addPrescription() {
    final animal = _animalController.text.trim();
    final disease = _diseaseController.text.trim();
    final recommendation = _prescriptionController.text.trim();
    final dosage = _dosageController.text.trim();
    final when = _whenController.text.trim();
    final duration = _durationController.text.trim();

    if (animal.isEmpty || disease.isEmpty || recommendation.isEmpty) return;

    setState(() {
      messages.add({
        'sender': 'Vet',
        'type': 'prescription',
        'animal': animal,
        'disease': disease,
        'recommendation': recommendation,
        'dosage': dosage,
        'when': when,
        'duration': duration,
        'time': _formatCurrentTime(),
      });
    });

    history.add({
      'farmer': widget.farmerName,
      'animal': animal,
      'disease': disease,
      'recommendation': recommendation,
      'dosage': dosage,
      'when': when,
      'duration': duration,
      'date': '2025-09-25',
      'status': 'Pending',
    });

    _scrollToBottom();
  }

  Widget _buildPrescriptionBubble({
    required String animal,
    required String disease,
    required String prescription,
    required String dosage,
    required String when,
    required String duration,
    required String time,
    required bool isVet,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
      child: Row(
        mainAxisAlignment:
        isVet ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isVet)
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8),
              decoration: const BoxDecoration(
                color: accentBeige,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.pets, color: primaryGreen, size: 18),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: vetBubbleColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Prescription Summary",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildPrescriptionRow("Animal:", animal),
                    _buildPrescriptionRow("Disease:", disease),
                    _buildPrescriptionRow("Treatment:", prescription),
                    _buildPrescriptionRow("Dosage:", "$dosage times/day"),
                    _buildPrescriptionRow("When:", when),
                    _buildPrescriptionRow("Duration:", "$duration days"),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        time,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: lightBeige,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.farmerName[0].toUpperCase(),
                  style: const TextStyle(
                    color: primaryGreen,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Active now',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isVet = msg['sender'] == 'Vet';
                final type = msg['type'] ?? 'text';
                final showAvatar = index == messages.length - 1 ||
                    messages[index + 1]['sender'] != msg['sender'];

                if (type == 'prescription') {
                  return _buildPrescriptionBubble(
                    animal: msg['animal'] ?? '',
                    disease: msg['disease'] ?? '',
                    prescription: msg['recommendation'] ?? '',
                    dosage: msg['dosage'] ?? '',
                    when: msg['when'] ?? '',
                    duration: msg['duration'] ?? '',
                    time: msg['time'] ?? '',
                    isVet: isVet,
                  );
                } else {
                  return _buildMessageBubble(
                    text: msg['text'] ?? '',
                    time: msg['time'] ?? '',
                    isVet: isVet,
                    showAvatar: showAvatar,
                  );
                }
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
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
              icon: const Icon(Icons.attach_file, color: primaryGreen),
              onPressed: () => _showAttachmentSheet(),
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
              decoration: const BoxDecoration(
                color: primaryGreen,
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
              decoration: const BoxDecoration(
                color: accentBeige,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.farmerName[0].toUpperCase(),
                  style: const TextStyle(
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
        ],
      ),
    );
  }
}
