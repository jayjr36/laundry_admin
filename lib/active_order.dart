import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('status', whereIn: ['pending', 'received', 'in-progress'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No pending orders.'));
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
                  trailing: DropdownButton<String>(
                    value: status,
                    items: ['pending', 'received', 'in-progress', 'complete']
                        .map((status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                    onChanged: (newStatus) {
                      FirebaseFirestore.instance
                          .collection('orders')
                          .doc(order['userId'])
                          .collection('myorders')
                          .doc(order.id)
                          .update({'status': newStatus});
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
