import 'package:flutter/material.dart';
import 'package:workshop_management_system/Screens/ManagePayment/PaymentProcessPage.dart';


class ListOfPayment extends StatelessWidget {
  const ListOfPayment({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> payments = [
      {
        'name': 'Ahmad Albab bin Mahmud',
        'role': 'Foreman',
        'status': 'Pending',
        'isPaid': false
      },
      {
        'name': 'ali haidar bin ali baba',
        'role': 'Foreman',
        'status': 'Pending',
        'isPaid': false
      },
      {
        'name': 'abdul kamil bin kamal',
        'role': 'Foreman',
        'status': 'Completed',
        'isPaid': true
      },
    ];

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text('Payment', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.notifications_none, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: payments.length,
              itemBuilder: (context, index) {
                final payment = payments[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.purple.shade100,
                          child: Text(payment['name'][0].toUpperCase()),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                payment['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                payment['role'],
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: payment['status'] == 'Pending'
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.fiber_manual_record,
                                      size: 12,
                                      color: payment['status'] == 'Pending'
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      payment['status'].toLowerCase(),
                                      style: TextStyle(
                                        color: payment['status'] == 'Pending'
                                            ? Colors.red
                                            : Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                       ElevatedButton(
  onPressed: payment['isPaid']
      ? null
      : () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentProcessPage(
                name: payment['name'],
                workingHours: 8, // example: you can make this dynamic later
                ratePerHour: 10.0, // example rate, can be from payment data
              ),
            ),
          );
        },
  style: ElevatedButton.styleFrom(
    backgroundColor: payment['isPaid'] ? Colors.grey : Colors.blue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
  child: Text(payment['isPaid'] ? 'paid' : 'pay'),
),

                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
