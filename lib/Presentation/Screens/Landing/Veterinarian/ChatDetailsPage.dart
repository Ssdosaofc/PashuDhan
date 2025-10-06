import 'package:flutter/material.dart';

class ChatDetailsPage extends StatefulWidget {
  final String farmerName;

  const ChatDetailsPage({Key? key, required this.farmerName}) : super(key: key);

  @override
  State<ChatDetailsPage> createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  // PashuDhan theme colors
  static const Color primaryGreen = Color(0xFF2D5F4F);
  static const Color lightBeige = Color(0xFFF5E6D3);
  static const Color accentBeige = Color(0xFFE8D4B8);
  static const Color vetBubbleColor = Color(0xFF3D7A66);
  static const Color farmerBubbleColor = Color(0xFFF5E6D3);
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textGrey = Color(0xFF7F8C8D);

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

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
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

    // Auto-scroll to bottom
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

  String _formatCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
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
              decoration: BoxDecoration(
                color: lightBeige,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.farmerName[0].toUpperCase(),
                  style: TextStyle(
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
                children: [
                  Text(
                    widget.farmerName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
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
          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isVet = msg['sender'] == 'Vet';
                final showAvatar =
                    index == messages.length - 1 ||
                    messages[index + 1]['sender'] != msg['sender'];

                return _buildMessageBubble(
                  text: msg['text']!,
                  time: msg['time'] ?? '',
                  isVet: isVet,
                  showAvatar: showAvatar,
                );
              },
            ),
          ),

          // Message input area
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
          ),
        ],
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
                  widget.farmerName[0].toUpperCase(),
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

          if (isVet) const SizedBox(width: 40),
        ],
      ),
    );
  }
}
