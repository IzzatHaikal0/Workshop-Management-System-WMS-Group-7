import 'package:flutter/material.dart';
import 'package:workshop_management_system/Controllers/ScheduleController.dart';
import 'package:workshop_management_system/Models/ScheduleModel.dart';
import 'package:workshop_management_system/Screens/ManageForemanSchedule/AddSchedulePage.dart';
import 'package:workshop_management_system/Screens/ManageForemanSchedule/EditSchedulePage.dart';
import 'package:intl/intl.dart';
//import 'package:firebase_auth/firebase_auth.dart';


class ListSchedulePage extends StatelessWidget {
  ListSchedulePage({super.key, required String workshopOwnerId});
  final ScheduleController controller = ScheduleController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Foreman Schedule Page')),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Current Schedule',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
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
                    child: Text('Add', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
            StreamBuilder<List<Schedule>>(
              stream: controller.getSchedulesByOwnerId(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No schedule available.'));
                } else {
                  List<Schedule> schedules = snapshot.data!;

                  return Column(
                    children: schedules.map((schedule) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(
                                    'Schedule Date: ${DateFormat('yyyy-MM-dd').format(schedule.scheduleDate)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 8, 8, 8),
                                    )),

                                //WAN FIX ISSUE WITH OVERNIGHT SCHEDULE (IT PRINTING NEGATIVE HOURS)
                                subtitle: Text(
                                  'Start Time: ${DateFormat('hh:mm a').format(schedule.startTime)}\n'
                                  'End Time: ${DateFormat('hh:mm a').format(schedule.endTime)}\n'
                                  'Total Hours: ${((schedule.endTime.difference(schedule.startTime).inMinutes) / 60).toStringAsFixed(2)} h\n'
                                  'Salary Rate: RM ${schedule.salaryRate}\n'
                                  'Job Description: ${schedule.jobDescription}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Color.fromARGB(255, 8, 8, 8),
                                  ),
                                ),
                                //subtitle: Text(schedule.date),
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
                                  
                                  FilledButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditSchedulePage(
                                                  docId: schedule.docId!),
                                        ), // Navigate to edit page
                                      );
                                    },
                                    style: FilledButton.styleFrom(
                                      padding: EdgeInsets.all(1),
                                      foregroundColor: Colors.blue,
                                    ),
                                    label: Text('Edit',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  SizedBox(width: 8),
                                  FilledButton.icon(
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
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                                onPressed: () async {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                  debugPrint(
                                                      'Delete confirmed');
                                                  controller.deleteSchedule(schedule.docId!);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    label: Text('Delete',
                                        style: TextStyle(color: Colors.white)),
                                    
                                    style: FilledButton.styleFrom(
                                      padding: EdgeInsets.all(1),
                                      backgroundColor: Colors.red,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
