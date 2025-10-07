import 'package:flutter/material.dart';
import 'package:pashu_dhan/Presentation/Screens/Landing/Veterinarian/ChatDetailsPage.dart';

import '../Profile/vet_profile.dart';

class ChatsPage extends StatelessWidget {
  // PashuDhan theme colors
  static const Color primaryGreen = Color(0xFF2D5F4F);
  static const Color lightBeige = Color(0xFFF5E6D3);
  static const Color accentBeige = Color(0xFFE8D4B8);
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textGrey = Color(0xFF7F8C8D);

  final List<Map<String, String>> chats = [
    {
      'name': 'Farmer Ramesh',
      'lastMessage': 'Thank you for the medicine advice!',
      'time': '09:15 AM',
      'unread': '0',
    },
    {
      'name': 'Farmer Sita',
      'lastMessage': 'My goat has a fever, what should I do?',
      'time': 'Yesterday',
      'unread': '2',
    },
    {
      'name': 'Farmer Mohan',
      'lastMessage': 'Can you recommend feed for cows?',
      'time': '2 days ago',
      'unread': '0',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryGreen,
        title: const Text(
          'Chats',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VetProfilePage()),
              );
            },
            child: const CircleAvatar(
              backgroundImage: NetworkImage(
                "https://i.pravatar.cc/150?img=5",
              ),
              radius: 18,
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body:
          chats.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: chats.length,
                separatorBuilder:
                    (_, __) => Divider(
                      height: 1,
                      indent: 80,
                      endIndent: 16,
                      color: Colors.grey[200],
                    ),
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  final hasUnread = chat['unread'] != '0';
                  final unreadCount = int.tryParse(chat['unread'] ?? '0') ?? 0;

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  ChatDetailsPage(farmerName: chat['name']!),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          // Avatar
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  primaryGreen,
                                  primaryGreen.withOpacity(0.7),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                chat['name']![0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Chat details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      chat['name']!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            hasUnread
                                                ? FontWeight.w700
                                                : FontWeight.w600,
                                        color: textDark,
                                      ),
                                    ),
                                    Text(
                                      chat['time']!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            hasUnread ? primaryGreen : textGrey,
                                        fontWeight:
                                            hasUnread
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        chat['lastMessage']!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              hasUnread ? textDark : textGrey,
                                          fontWeight:
                                              hasUnread
                                                  ? FontWeight.w500
                                                  : FontWeight.normal,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (hasUnread && unreadCount > 0)
                                      Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: primaryGreen,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          unreadCount.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryGreen,
        child: const Icon(Icons.add_comment, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No chats yet',
            style: TextStyle(
              fontSize: 18,
              color: textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a conversation with farmers',
            style: TextStyle(fontSize: 14, color: textGrey),
          ),
        ],
      ),
    );
  }
}
