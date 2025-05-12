// ListSchedulePage.dart
import 'package:flutter/material.dart';
import 'package:workshop_management_system/Screens/ManageForemanSchedule/AddSchedulePage.dart';
import 'package:workshop_management_system/Screens/ManageForemanSchedule/EditSchedulePage.dart';
import 'package:workshop_management_system/Controllers/ScheduleController.dart';
import 'package:workshop_management_system/Models/ScheduleModel.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Foreman Schedule Page')),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            //CURRENT SCHEDULE TITLE
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Current Schedule',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  //ADD SCHEDULE BUTTON (DIRECT TO ADD SCHEDULE PAGE)
                  FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddSchedulePage()),
                      );
                      debugPrint('Add button tapped');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.all(5),
                      foregroundColor: Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: Text(
                      'Add',
                      style: TextStyle(fontSize: 16),
                    ),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditSchedulePage()), // Navigate to edit page
                            );
                          },
                          label: Text('Edit',
                              style: TextStyle(color: Colors.blue)),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Delete'),
                                  content: Text(
                                      'Are you sure you want to delete this schedule?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Delete',
                                          style: TextStyle(color: Colors.red)),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                        debugPrint('Delete confirmed');
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          label: Text('Delete',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

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
                            debugPrint('Edit tapped');
                          },
                          label: Text('Edit',
                              style: TextStyle(color: Colors.blue)),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            debugPrint('Delete tapped');
                          },
                          label: Text('Delete',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
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
                            debugPrint('Edit tapped');
                          },
                          label: Text('Edit',
                              style: TextStyle(color: Colors.blue)),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            debugPrint('Delete tapped');
                          },
                          label: Text('Delete',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
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
                            debugPrint('Edit tapped');
                          },
                          label: Text('Edit',
                              style: TextStyle(color: Colors.blue)),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            debugPrint('Delete tapped');
                          },
                          label: Text('Delete',
                              style: TextStyle(color: Colors.red)),
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
