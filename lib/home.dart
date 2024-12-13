import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:laundry_admin/active_order.dart';
import 'package:laundry_admin/order_history.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Overview Section (Orders Summary)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overview',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // You can replace these with dynamic data
                  _buildOrderSummaryCard('Active Orders', '45'),
                  _buildOrderSummaryCard('Completed Orders', '200'),
                  _buildOrderSummaryCard('Cancelled Orders', '12'),
                ],
              ),
            ),

            // Quick Navigation to Pending Orders and Completed Orders
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavigationCard(
                    'Pending Orders',
                    Icons.pending_actions,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ActiveOrdersPage()),
                    ),
                  ),
                  _buildNavigationCard(
                    'Completed Orders',
                    Icons.check_circle_outline,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CompletedOrdersPage()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build order summary cards
  Widget _buildOrderSummaryCard(String title, String count) {
    return Card(
      color: Colors.blueAccent,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
        subtitle: Text(count, style: const TextStyle(color: Colors.white, fontSize: 32)),
      ),
    );
  }

  // Helper method to build navigation cards
  Widget _buildNavigationCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 40),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
