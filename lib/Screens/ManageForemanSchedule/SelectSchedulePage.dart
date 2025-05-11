import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: SelectSchedulePage()));
}

class SelectSchedulePage extends StatelessWidget {
  const SelectSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            // FOREMAN CAN VIEW ALL "ACCEPTED" SCHEDULE
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Your Active Schedule',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade400,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column( //CHANGE THIS WITH DATABASE DATA
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tuesday, 12:30 - 16:30",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  SizedBox(height: 4),
                  Text("1st January 2025",
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade400,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Wednesday, 08:30 - 12:30",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  SizedBox(height: 4),
                  Text("2nd January 2025",
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            

            //FOREMAN CAN SCROLL ALL AVAILABLE SCHEDULE
            //START OF AVAILABLE SCHEDULE TO ACCEPT
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Schedule',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            //START OF SCHEDULE LIST
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text('Schedule 1'),
                      subtitle: Text('Date Schedule'),
                      trailing: Icon(Icons.arrow_forward),
                      leading: Icon(Icons.calendar_today),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      onTap: () {
                        debugPrint('Schedule tapped');
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Confirm Accept'),
                                    content: Text('Are you sure you want to accept this schedule?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Close the dialog
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Accept', style: TextStyle(color: Colors.blue)),
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Close the dialog
                                          debugPrint('Accept confirmed');
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                          },
                          label: Text('Accept', style: TextStyle(color: Colors.blue)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            
          ],
        ),
      ),
    );
  }
}
