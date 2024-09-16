import 'package:flutter/material.dart';

class ViewActiveJobScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('#524587'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back action
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {
              // Handle phone call action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service List
            ServiceItem(
              title: 'Apartment',
              subtitle: 'Suited for repair or replacement',
              price: '\$49',
            ),
            ServiceItem(
              title: 'Waste Pipe Leakage',
              subtitle: 'Suited for repair or replacement',
              price: '\$29',
            ),

            SizedBox(height: 16.0),

            // Booking Details
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '#524587',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Chip(
                        label: Text('Accepted'),
                        backgroundColor: Colors.blue[100],
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Tyrone Mitchell\nRight Joy Pvt. Ltd.\n1534 Single Street, USA',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),

            // Cancellation Policy
            Container(
              decoration: BoxDecoration(
                color: Colors.red[50],
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Cancellation Policy\n\nIf you cancel less than 24 hours before your booking, you may be charged a cancellation fee up to the full amount of the services booked.',
                style: TextStyle(color: Colors.red),
              ),
            ),

            SizedBox(height: 16.0),

            // Order Summary
            Text(
              'Order Summary',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            OrderSummaryRow(label: 'Subtotal', amount: '\$156.00'),
            OrderSummaryRow(label: 'Est. Tax', amount: '\$12.00'),
            Divider(),
            OrderSummaryRow(label: 'Total', amount: '\$168', isTotal: true),

            Spacer(),

            // Cancel Booking Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.blue),
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  // Handle cancel booking action
                },
                child: Text(
                  'Cancel Booking',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for Service Item
class ServiceItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;

  ServiceItem({required this.title, required this.subtitle, required this.price});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
      trailing: Text(
        price,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
      ),
    );
  }
}

// Widget for Order Summary Row
class OrderSummaryRow extends StatelessWidget {
  final String label;
  final String amount;
  final bool isTotal;

  OrderSummaryRow({required this.label, required this.amount, this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
          ),
          Text(
            amount,
            style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
