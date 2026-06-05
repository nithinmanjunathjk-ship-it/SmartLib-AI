import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> notifications = [
    {'icon': Icons.warning_amber, 'color': Colors.orange, 'title': 'Due Date Reminder', 'body': '"Introduction to Algorithms" is due in 3 days.', 'time': '2 hours ago', 'read': false},
    {'icon': Icons.check_circle, 'color': Colors.green, 'title': 'Return Confirmed', 'body': '"The Pragmatic Programmer" has been returned successfully.', 'time': '2 days ago', 'read': true},
    {'icon': Icons.info, 'color': const Color(0xFF5B67CA), 'title': 'New Books Added', 'body': '5 new books added to the Computer Science section.', 'time': '3 days ago', 'read': true},
    {'icon': Icons.attach_money, 'color': Colors.red, 'title': 'Fine Due', 'body': 'You have an outstanding fine of ₹25.', 'time': '5 days ago', 'read': false},
    {'icon': Icons.calendar_month, 'color': const Color(0xFF5B67CA), 'title': 'Reservation Ready', 'body': '"Design Patterns" you reserved is now available.', 'time': '1 week ago', 'read': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5FA),
        elevation: 0,
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        actions: [
          TextButton(
            onPressed: () => setState(() {
              for (var n in notifications) n['read'] = true;
            }),
            child: const Text('Mark all read', style: TextStyle(color: Color(0xFF5B67CA), fontSize: 12)),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (_, i) {
          final n = notifications[i];
          return GestureDetector(
            onTap: () => setState(() => n['read'] = true),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: n['read'] ? Colors.white : const Color(0xFFEEF0FF),
                borderRadius: BorderRadius.circular(14),
                border: n['read'] ? null : Border.all(color: const Color(0xFF5B67CA).withOpacity(0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (n['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(n['icon'] as IconData, color: n['color'] as Color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(n['title'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
                            if (!n['read']) Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF5B67CA), shape: BoxShape.circle)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(n['body'], style: const TextStyle(color: Colors.grey, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text(n['time'], style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
