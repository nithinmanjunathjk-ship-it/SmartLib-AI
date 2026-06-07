import 'package:flutter/material.dart';

class MyFinesScreen extends StatelessWidget {
  const MyFinesScreen({super.key});

  final List<Map<String, dynamic>> fines = const [
    {'book': 'Data Structures', 'days': 5, 'amount': 25.0, 'paid': false, 'date': 'May 10, 2026'},
    {'book': 'Computer Networks', 'days': 2, 'amount': 10.0, 'paid': true, 'date': 'Apr 5, 2026'},
    {'book': 'Operating Systems', 'days': 3, 'amount': 15.0, 'paid': true, 'date': 'Mar 18, 2026'},
  ];

  @override
  Widget build(BuildContext context) {
    final unpaid = fines.where((f) => !f['paid']).toList();
    final paid = fines.where((f) => f['paid']).toList();
    final totalDue = unpaid.fold(0.0, (sum, f) => sum + (f['amount'] as double));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5FA),
        elevation: 0,
        title: const Text('My Fines', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total due card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF5B67CA), Color(0xFF8B95E0)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Amount Due', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 6),
                  Text('₹${totalDue.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: totalDue > 0 ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Payment feature coming soon!'), backgroundColor: Color(0xFF5B67CA)),
                      );
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF5B67CA),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Pay Now', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            if (unpaid.isNotEmpty) ...[
              const Text('Unpaid Fines', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...unpaid.map((f) => _FineCard(fine: f)),
              const SizedBox(height: 16),
            ],

            if (paid.isNotEmpty) ...[
              const Text('Paid Fines', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...paid.map((f) => _FineCard(fine: f)),
            ],
          ],
        ),
      ),
    );
  }
}

class _FineCard extends StatelessWidget {
  final Map<String, dynamic> fine;
  const _FineCard({required this.fine});

  @override
  Widget build(BuildContext context) {
    final paid = fine['paid'] as bool;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: paid ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(paid ? Icons.check_circle : Icons.warning_amber, color: paid ? Colors.green : Colors.red),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fine['book'], style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('${fine['days']} days overdue • ${fine['date']}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹${(fine['amount'] as double).toStringAsFixed(0)}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: paid ? Colors.grey : Colors.red)),
              Text(paid ? 'Paid' : 'Due', style: TextStyle(fontSize: 11, color: paid ? Colors.green : Colors.red)),
            ],
          ),
        ],
      ),
    );
  }
}
