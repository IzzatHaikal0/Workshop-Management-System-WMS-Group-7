import 'package:flutter/material.dart';
import 'package:workshop_management_system/Controllers/ScheduleController.dart';
import 'package:workshop_management_system/Models/ScheduleModel.dart';
import 'package:intl/intl.dart';

class SelectSchedulePage extends StatelessWidget {
  SelectSchedulePage({super.key});
  final ScheduleController controller = ScheduleController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            // FOREMAN CAN VIEW ALL "ACCEPTED" SCHEDULE
            Padding(
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
              child: const Column(
                //CHANGE THIS WITH DATABASE DATA
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

            StreamBuilder<List<Schedule>>(
              stream: controller.getSchedules(),
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
                      final duration =
                          schedule.endTime.difference(schedule.startTime);
                      final totalHours = duration.isNegative
                          ? ((schedule.endTime
                                      .add(Duration(days: 1))
                                      .difference(schedule.startTime))
                                  .inMinutes /
                              60)
                          : (duration.inMinutes / 60);

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
                                  ),
                                ),
                                subtitle: Text(
                                  'Start Time: ${DateFormat('hh:mm a').format(schedule.startTime)}\n'
                                  'End Time: ${DateFormat('hh:mm a').format(schedule.endTime)}\n'
                                  'Total Hours: ${totalHours.toStringAsFixed(2)} h\n'
                                  'Salary Rate: RM ${schedule.salaryRate}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Color.fromARGB(255, 8, 8, 8),
                                  ),
                                ),
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
                                            content: Text(
                                                'Are you sure you want to accept this schedule?'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: Text('Accept',
                                                    style: TextStyle(
                                                        color: Colors.blue)),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  debugPrint(
                                                      'Accept confirmed');
                                                  // You can add your accept logic here
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(Icons.check, color: Colors.blue),
                                    label: Text('Accept',
                                        style: TextStyle(color: Colors.blue)),
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
            )
          ],
        ),
      ),
    );
  }
}
