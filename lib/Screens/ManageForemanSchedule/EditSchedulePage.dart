import 'package:flutter/material.dart';
//import 'package:workshop_management_system/Screens/ManageForemanSchedule/ListSchedulePage.dart';

void main() {
  runApp(const MaterialApp(home: EditSchedulePage()));
}

class EditSchedulePage extends StatelessWidget {
  const EditSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Selected Schedule')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: DatePickerExample(),
      ),
    );
  }
}

class DatePickerExample extends StatefulWidget {
  const DatePickerExample({super.key});

  @override
  State<DatePickerExample> createState() => _DatePickerExampleState();
}

class _DatePickerExampleState extends State<DatePickerExample> {
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  TimeOfDay? breakTime;

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2021, 7, 25),
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
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
        if (type == 'break') breakTime = picked;
      });
    }
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return 'Select Time';
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
/*
//FIX THE BUTTON REDIRECTION
  //SAVE THE SCHEDULE
  void _onSave() {
    // Dummy save action
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Schedule saved (dummy action)')),
    );
  }

  //CANCEL THE PROCESS
  void _onCancel() { 
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SchedulePage()),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            selectedDate != null
                ? 'Selected Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                : 'No date selected',
          ),
          const SizedBox(height: 10),
          OutlinedButton(
              onPressed: _selectDate, child: const Text('Select Date')),
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
              subtitle: (startTime != null && endTime != null)
                  ? Text(
                      _calculateTotalHours(startTime!, endTime!),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 245, 0, 0),
                      ),
                    )
                  : const Text('Not set'),
              trailing: const Icon(Icons.access_time),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  debugPrint('Delete tapped');
                },
                label: Text('Cancel', style: TextStyle(color: Colors.red)),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  debugPrint('Edit tapped');
                },
                label: Text('Save', style: TextStyle(color: Colors.blue)),
              ),
            ],
          )
        ],
      ),
    );
  }

  //CALCULATE TOTAL HOURS AND RETURN
  String _calculateTotalHours(TimeOfDay start, TimeOfDay end) {
    final now = DateTime.now();
    final startDateTime =
        DateTime(now.year, now.month, now.day, start.hour, start.minute);
    final endDateTime =
        DateTime(now.year, now.month, now.day, end.hour, end.minute);

    // Handle overnight shifts (e.g., 10 PM to 6 AM)
    final duration = endDateTime.isAfter(startDateTime)
        ? endDateTime.difference(startDateTime)
        : endDateTime.add(const Duration(days: 1)).difference(startDateTime);

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    return '${hours}h ${minutes}m';
  }
}
