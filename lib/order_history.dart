import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CompletedOrdersPage extends StatelessWidget {
  const CompletedOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = 'exampleUserId'; // Replace with actual user ID from FirebaseAuth
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed & Cancelled Orders'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(userId)
            .collection('myorders')
            .where('status', whereIn: ['completed', 'cancelled'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No completed or cancelled orders.'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final orderId = order['orderId'];
              final status = order['status'];

              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 5,
                child: ListTile(
                  title: Text('Order ID: $orderId'),
                  subtitle: Text('Status: $status'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
