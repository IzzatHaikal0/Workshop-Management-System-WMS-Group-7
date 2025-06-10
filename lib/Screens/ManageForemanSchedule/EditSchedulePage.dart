import 'package:flutter/material.dart';
import 'package:workshop_management_system/Controllers/ScheduleController.dart';
import 'package:workshop_management_system/Models/ScheduleModel.dart';
import 'package:workshop_management_system/Screens/ManageForemanSchedule/ListSchedulePage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditSchedulePage extends StatelessWidget {
  final String docId;

  EditSchedulePage({super.key, required this.docId});
  final ScheduleController controller = ScheduleController();
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Selected Schedule')),
      body: FutureBuilder<Schedule?>(
        future: controller.getScheduleById(docId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Schedule not found'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: DatePickerExample(
                schedule: snapshot.data!,
                currentUserId: currentUserId,
              ),
            );
          }
        },
      ),
    );
  }
}

class DatePickerExample extends StatefulWidget {
  final Schedule schedule;
  final String currentUserId;
  const DatePickerExample({
    super.key,
    required this.schedule,
    required this.currentUserId,
  });

  @override
  State<DatePickerExample> createState() => _DatePickerExampleState();
}

class _DatePickerExampleState extends State<DatePickerExample> {
  DateTime? scheduleDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  int? salaryRate;
  int? scheduleID;
  String? jobDescription;

  @override
  void initState() {
    super.initState();
    scheduleDate = widget.schedule.scheduleDate;
    startTime = TimeOfDay.fromDateTime(widget.schedule.startTime);
    endTime = TimeOfDay.fromDateTime(widget.schedule.endTime);
    salaryRate = widget.schedule.salaryRate;
  }

  Future<void> _selectTime(String type) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (type == 'start') startTime = picked;
        if (type == 'end') endTime = picked;
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: scheduleDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => scheduleDate = picked);
    }
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return 'Select Time';
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  //THE SCHEDULE CARD
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            scheduleDate != null
                ? 'Selected Date: ${scheduleDate!.day}/${scheduleDate!.month}/${scheduleDate!.year}'
                : 'No date selected',
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: _selectDate,
            child: const Text('Select Date'),
          ),
          const SizedBox(height: 20),
          Card(
            //REQUIRED START TIME
            child: ListTile(
              title: const Text('Start Time'),
              subtitle: Text(formatTime(startTime)),
              trailing: const Icon(Icons.access_time),
              onTap: () => _selectTime('start'),
            ),
          ),
          Card(
            //REQUIRED END TIME
            child: ListTile(
              title: const Text('End Time'),
              subtitle: Text(formatTime(endTime)),
              trailing: const Icon(Icons.access_time),
              onTap: () => _selectTime('end'),
            ),
          ),
          Card(
            //CALULATE TOTAL WORKING HOURS (START TIME - END TIME)
            child: ListTile(
              title: const Text('Total Hours'),
              subtitle:
                  (startTime != null && endTime != null)
                      ? Text(
                        '${_calculateTotalHours(startTime!, endTime!).toStringAsFixed(2)} h',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 245, 0, 0),
                        ),
                      )
                      : const Text('Not set'),
              trailing: const Icon(Icons.access_time),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Salary Rate (Per Hour)'),
              subtitle: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter salary rate',
                ),
                onChanged: (value) {
                  setState(() {
                    salaryRate = int.tryParse(value);
                  });
                },
              ),
              trailing: const Icon(Icons.attach_money),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Job Task Description'),
              subtitle: TextFormField(
                decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter job details',
                ),
                onChanged: (value) {
                setState(() {
                    jobDescription = value;
                  });
                },
              ),
              trailing: const Icon(Icons.note_add),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton.icon(
                onPressed: _onCancel,
                label: Text('Cancel', style: TextStyle(color: Colors.red)),
              ),
              OutlinedButton.icon(
                onPressed: _onSave,
                label: Text('Save', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //CALCULATE TOTAL HOURS AND RETURN
  double _calculateTotalHours(TimeOfDay start, TimeOfDay end) {
    final now = DateTime.now();
    final startDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      start.hour,
      start.minute,
    );
    final endDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      end.hour,
      end.minute,
    );

    // Handle overnight shifts (e.g., 10 PM to 6 AM)
    final duration =
        endDateTime.isAfter(startDateTime)
            ? endDateTime.difference(startDateTime)
            : endDateTime
                .add(const Duration(days: 1))
                .difference(startDateTime);

    // ignore: non_constant_identifier_names
    final TotalMinutes = duration.inMinutes;
    // ignore: non_constant_identifier_names
    final TotalHours = TotalMinutes / 60;

    return double.parse(TotalHours.toStringAsFixed(2));
  }

  //SAVE THE SCHEDULE
  void _onSave() {
    if (scheduleDate != null && startTime != null && endTime != null) {
      //final now = DateTime.now();

      // Combine selected date with time of day
      final DateTime startDateTime = DateTime(
        scheduleDate!.year,
        scheduleDate!.month,
        scheduleDate!.day,
        startTime!.hour,
        startTime!.minute,
      );

      final DateTime endDateTime = DateTime(
        scheduleDate!.year,
        scheduleDate!.month,
        scheduleDate!.day,
        endTime!.hour,
        endTime!.minute,
      );

      final schedule = Schedule(
        scheduleDate: scheduleDate!,
        startTime: startDateTime,
        endTime: endDateTime,
        salaryRate: salaryRate ?? 0,
        totalHours: _calculateTotalHours(startTime!, endTime!),
        docId: widget.schedule.docId, // Firestore will generate this
        //TotalHours: _calculateTotalHours(StartTime!, EndTime!),
        jobDescription:jobDescription ?? '',
      );

      ScheduleController().editSchedule(schedule);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Schedule saved successfully')),
      );

      Navigator.pop(
        context,
        MaterialPageRoute(builder: (context) => ListSchedulePage(workshopOwnerId: widget.currentUserId)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
    }
  }

  //CANCEL THE PROCESS
  void _onCancel() {
     Navigator.pop(
      context,
      MaterialPageRoute(builder: (context) => ListSchedulePage(workshopOwnerId: widget.currentUserId,)),
    );
  }
}
