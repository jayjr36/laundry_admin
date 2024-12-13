import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:laundry_admin/model/orderCard.dart';

class ActiveOrdersPage extends StatelessWidget {
  const ActiveOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final userId = 'exampleUserId';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Orders'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collectionGroup('myorders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No pending orders.'));
          }

          // Filter documents manually
          final orders = snapshot.data!.docs.where((doc) {
            final status = doc['status'];
            return status != null &&
                ['pending', 'received', 'in-progress'].contains(status);
          }).toList();

          if (orders.isEmpty) {
            return const Center(child: Text('No pending orders.'));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final orderId = order.id;
              final orderData = order.data() as Map<String, dynamic>;
              final timestamp = (orderData['timestamp'] as Timestamp).toDate();
              final status = orderData['status'];
              final items = List<Map<String, dynamic>>.from(orderData['items']);
              final totalPrice = orderData['totalPrice'] ?? 0.0;

              return buildOrderCard(
                order: order,
                orderId: orderId,
                timestamp: timestamp,
                status: status,
                items: items,
                totalPrice: totalPrice,
              );
            },
          );
        },
      ),
    );
  }
}
