import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // PashuDhan theme colors
  static const Color primaryGreen = Color(0xFF2D5F4F);
  static const Color lightBeige = Color(0xFFF5E6D3);
  static const Color accentBeige = Color(0xFFE8D4B8);
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textGrey = Color(0xFF7F8C8D);

  String selectedFilter = 'All';

  final List<Map<String, String>> history = [
    {
      'farmer': 'Farmer Ramesh',
      'animal': 'Cow',
      'disease': 'Mastitis',
      'recommendation': 'Antibiotics, regular cleaning',
      'date': '2025-09-28',
      'status': 'Completed',
    },
    {
      'farmer': 'Farmer Sita',
      'animal': 'Goat',
      'disease': 'Fever',
      'recommendation': 'Paracetamol, hydration',
      'date': '2025-09-25',
      'status': 'Follow-up',
    },
    {
      'farmer': 'Farmer Mohan',
      'animal': 'Buffalo',
      'disease': 'Foot Rot',
      'recommendation': 'Topical ointment, keep dry',
      'date': '2025-09-20',
      'status': 'Completed',
    },
    {
      'farmer': 'Farmer Priya',
      'animal': 'Cow',
      'disease': 'Bloat',
      'recommendation': 'Immediate treatment, diet change',
      'date': '2025-09-15',
      'status': 'Completed',
    },
  ];

  IconData _getAnimalIcon(String animal) {
    switch (animal.toLowerCase()) {
      case 'cow':
        return Icons.pets;
      case 'goat':
        return Icons.outdoor_grill;
      case 'buffalo':
        return Icons.park;
      default:
        return Icons.pets;
    }
  }

  Color _getStatusColor(String status) {
    return status == 'Follow-up' ? Colors.orange : Colors.green;
  }

  List<Map<String, String>> get filteredHistory {
    if (selectedFilter == 'All') return history;
    return history.where((item) => item['animal'] == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryGreen,
        title: const Text(
          'Consultation History',
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
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Cow'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Goat'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Buffalo'),
                ],
              ),
            ),
          ),

          // Summary stats
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryGreen, primaryGreen.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: primaryGreen.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Total',
                  history.length.toString(),
                  Icons.history,
                ),
                Container(width: 1, height: 40, color: Colors.white30),
                _buildStatItem('This Month', '4', Icons.calendar_today),
                Container(width: 1, height: 40, color: Colors.white30),
                _buildStatItem(
                  'Follow-ups',
                  history
                      .where((h) => h['status'] == 'Follow-up')
                      .length
                      .toString(),
                  Icons.schedule,
                ),
              ],
            ),
          ),

          // History list
          Expanded(
            child:
                filteredHistory.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredHistory.length,
                      itemBuilder: (context, index) {
                        final item = filteredHistory[index];
                        return _buildHistoryCard(item);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryGreen : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : textGrey,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showDetailsBottomSheet(context, item),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: lightBeige,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _getAnimalIcon(item['animal']!),
                        color: primaryGreen,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['farmer']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                item['animal']!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: textGrey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('•', style: TextStyle(color: textGrey)),
                              const SizedBox(width: 8),
                              Text(
                                _formatDate(item['date']!),
                                style: TextStyle(fontSize: 12, color: textGrey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          item['status']!,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item['status']!,
                        style: TextStyle(
                          color: _getStatusColor(item['status']!),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.medical_services,
                            size: 16,
                            color: textGrey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Disease: ',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: textGrey,
                            ),
                          ),
                          Text(
                            item['disease']!,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: textDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.description, size: 16, color: textGrey),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              item['recommendation']!,
                              style: TextStyle(
                                fontSize: 13,
                                color: textGrey,
                                height: 1.4,
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
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No consultations yet',
            style: TextStyle(
              fontSize: 18,
              color: textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your consultation history will appear here',
            style: TextStyle(fontSize: 14, color: textGrey),
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    final dateTime = DateTime.parse(date);
    final now = DateTime.now();
    final difference = now.difference(dateTime).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '$difference days ago';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Options',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.date_range, color: primaryGreen),
                  title: const Text('By Date Range'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.medical_services, color: primaryGreen),
                  title: const Text('By Disease Type'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.person, color: primaryGreen),
                  title: const Text('By Farmer'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
    );
  }

  void _showDetailsBottomSheet(BuildContext context, Map<String, String> item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: lightBeige,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _getAnimalIcon(item['animal']!),
                        color: primaryGreen,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['farmer']!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${item['animal']} • ${_formatDate(item['date']!)}',
                            style: TextStyle(fontSize: 14, color: textGrey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildDetailRow('Disease', item['disease']!),
                const SizedBox(height: 12),
                _buildDetailRow('Recommendation', item['recommendation']!),
                const SizedBox(height: 12),
                _buildDetailRow('Status', item['status']!),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.chat),
                        label: const Text('Message'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryGreen,
                          side: BorderSide(color: primaryGreen),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.phone),
                        label: const Text('Call'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: textDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
 