import 'package:flutter/material.dart';
import 'package:i_supply_order_tracker/services/fcm_service.dart';
import 'package:i_supply_order_tracker/viewmodel/order_viewmodel.dart';
import 'package:provider/provider.dart';
import '../model/order_status_enum.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/notification_service.dart';

class OrderTrackerScreen extends StatelessWidget {
  const OrderTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm=Provider.of<OrderViewModel>(context);
    final currentStatus=vm.status;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: null,
        ),
        title: Text(
        'Order Tracker',
        style: GoogleFonts.lexend(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),

      centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.local_shipping_outlined,
                            size: 26,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 16),
                         Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pharma Seller',
                              style: GoogleFonts.lexend(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Order #123456789',
                              style: GoogleFonts.lexend(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Image.asset(
                          'assets/logos/isupply_logo_blue.png',
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Status Section
                   Text(
                    'Status',
                    style: GoogleFonts.lexend(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,

                    ),
                  ),

                  const SizedBox(height: 24),

                  // Status Timeline
                  _buildStatusTimeline(vm),

                  const SizedBox(height: 40),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Confirm Button
                        _buildActionButton(
                          'Confirm',
                          const Color(0xFF82D0F5),
                          currentStatus == OrderStatus.pending
                              ? () => vm.updateStatus(OrderStatus.confirmed)
                              : null,
                        ),

                        const SizedBox(height: 12),

                        // Ship Button
                        _buildActionButton(
                          'Ship',
                          const Color(0xFF82D0F5),
                          currentStatus == OrderStatus.confirmed
                              ? () => vm.updateStatus(OrderStatus.shipped)
                              : null,
                        ),

                        const SizedBox(height: 12),

                        // Deliver Button
                        _buildActionButton(
                          'Deliver',
                          const Color(0xFF82D0F5),
                          currentStatus == OrderStatus.shipped
                              ? () => vm.updateStatus(OrderStatus.delivered)
                              : null,
                        ),

                        const SizedBox(height: 12),

                        // Cancel Button
                        _buildActionButton(
                          'Cancel',
                          const Color(0xFFE57373),
                          currentStatus != OrderStatus.delivered
                              ? () => _showCancelDialog(context, vm)
                              : null,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),

                ],

              ),
            ),
          ),

          // Action Buttons
        ],
      ),

      // Bottom Navigation Bar
    );
  }

  Widget _buildStatusTimeline(OrderViewModel vm){
    final trackableStatuses = [
      OrderStatus.pending,
      OrderStatus.confirmed,
      OrderStatus.shipped,
      OrderStatus.delivered,
    ];

    return Column(
      children: trackableStatuses.asMap().entries.map((entry) {
        final index = entry.key;
        final status = entry.value;
        final isCompleted = vm.status.indexInTrack >= status.indexInTrack;
        final isLast = index == trackableStatuses.length - 1;

        return Row(
          children: [
            Column(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  child: Center(
                    child: Icon(
                      status.icon,
                     size:   24,
                      color: isCompleted ? Colors.black : Colors.grey[400],

                    ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2.5,
                    height: 60,
                    color: isCompleted ? Colors.black : Colors.grey[400],
                  ),
              ],
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status.label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isCompleted ? Colors.black : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Order ${status.label.toLowerCase()}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildActionButton(String text, Color backgroundColor, VoidCallback? onPressed, {Color? textColor}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor ?? Colors.black87,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          disabledBackgroundColor: Colors.grey[300],
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
  void _showCancelDialog(BuildContext context, OrderViewModel vm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Order'),
          content: const Text('Are you sure you want to cancel this order?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                vm.cancelOrder();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );}
}