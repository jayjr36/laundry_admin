import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Card buildOrderCard(
    {required String orderId,
    required DateTime timestamp,
    required String status,
    required List<Map<String, dynamic>> items,
    required double totalPrice,
    required QueryDocumentSnapshot order}) {
  // Define status color mapping
  final statusColor = {
    'completed': Colors.green,
    'cancelled': Colors.red,
    'pending': Colors.orange,
  };

  return Card(
    elevation: 5,
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Date and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date: ${DateFormat.yMMMd().add_jm().format(timestamp)}',
                style: const TextStyle(color: Colors.grey),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor[status.toLowerCase()] ?? Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const Divider(height: 20),

          // Order Items
          Column(
            children: items.map((item) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item['item'],
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    'x${item['quantity']}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),

          const Divider(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Dropdown for status
              DropdownButton<String>(
                value: status,
                items: ['pending', 'received', 'in-progress', 'complete']
                    .map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(
                      status[0].toUpperCase() +
                          status.substring(1), // Capitalize
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: (newStatus) async {
                  if (newStatus != null) {
                    try {
                      await order.reference.update({'status': newStatus});
                    } catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                    }
                  }
                },
                underline: const SizedBox(),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ),

              // Total price display
              Text(
                'Total: TZS ${totalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
