import 'package:flutter/material.dart';
import 'package:workshop_management_system/Controllers/ScheduleController.dart';
import 'package:workshop_management_system/Models/ScheduleModel.dart';
import 'package:workshop_management_system/Screens/ManageForemanSchedule/ListSchedulePage.dart';

/*void main() {
  runApp(const MaterialApp(home: AddSchedulePage()));
}*/

class AddSchedulePage extends StatelessWidget {
  AddSchedulePage({super.key});
  final ScheduleController controller = ScheduleController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Schedule')),
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
  DateTime? ScheduleDate;
  TimeOfDay? StartTime;
  TimeOfDay? EndTime;
  int? SalaryRate;

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2021, 7, 25),
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null) {
      setState(() {
        ScheduleDate = pickedDate;
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
        if (type == 'start') StartTime = picked;
        if (type == 'end') EndTime = picked;
      });
    }
  }

    // Function to show dialog for salary input
  void _selectSalaryRate() {
    final TextEditingController salaryController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Salary Rate (Per Hour)'),
          content: TextField(
            controller: salaryController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Salary Rate',
             
            ),

          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  // Try to parse the entered value as an integer
                  SalaryRate = int.tryParse(salaryController.text);
                  if (SalaryRate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid salary rate')),
                    );
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
  String formatTime(TimeOfDay? time) {
    if (time == null) return 'Select Time';
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            ScheduleDate != null
                ? 'Selected Date: ${ScheduleDate!.day}/${ScheduleDate!.month}/${ScheduleDate!.year}'
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
              subtitle: Text(formatTime(StartTime)),
              trailing: const Icon(Icons.access_time),
              onTap: () => _selectTime('start'),
            ),
          ),
          Card(
            //REQUIRED END TIME
            child: ListTile(
              title: const Text('End Time'),
              subtitle: Text(formatTime(EndTime)),
              trailing: const Icon(Icons.access_time),
              onTap: () => _selectTime('end'),
            ),
          ),
          Card(
            //CALULATE TOTAL WORKING HOURS (START TIME - END TIME)
            child: ListTile(
              title: const Text('Total Hours'),
              subtitle: (StartTime != null && EndTime != null)
                  ? Text(
                      '${_calculateTotalHours(StartTime!, EndTime!).toStringAsFixed(2)} h',
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
            // SALARY RATE
            child: ListTile(
              title: const Text('Salary Rate (Per Hour)'),
              subtitle: Text(
                SalaryRate != null
                    ? 'RM ${SalaryRate.toString()}'
                    : 'Enter Salary Rate',
              ),
              trailing: const Icon(Icons.attach_money),
              onTap: () => _selectSalaryRate(),
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
          )
        ],
      ),
    );
  }

  //CALCULATE TOTAL HOURS AND RETURN
  double _calculateTotalHours(TimeOfDay start, TimeOfDay end) {
    final now = DateTime.now();
    final startDateTime =
        DateTime(now.year, now.month, now.day, start.hour, start.minute);
    final endDateTime =
        DateTime(now.year, now.month, now.day, end.hour, end.minute);

    // Handle overnight shifts (e.g., 10 PM to 6 AM)
    final duration = endDateTime.isAfter(startDateTime)
        ? endDateTime.difference(startDateTime)
        : endDateTime.add(const Duration(days: 1)).difference(startDateTime);

    // ignore: non_constant_identifier_names
    final TotalMinutes = duration.inMinutes;
    // ignore: non_constant_identifier_names
    final TotalHours = TotalMinutes / 60;

    return double.parse(TotalHours.toStringAsFixed(2));
  }

  //FIX THE BUTTON REDIRECTION
  //SAVE THE SCHEDULE
  void _onSave() {
    if (ScheduleDate != null && StartTime != null && EndTime != null) {
      //final now = DateTime.now();

      // Combine selected date with time of day
      final DateTime startDateTime = DateTime(
        ScheduleDate!.year,
        ScheduleDate!.month,
        ScheduleDate!.day,
        StartTime!.hour,
        StartTime!.minute,
      );

      final DateTime endDateTime = DateTime(
        ScheduleDate!.year,
        ScheduleDate!.month,
        ScheduleDate!.day,
        EndTime!.hour,
        EndTime!.minute,
      );

      final schedule = Schedule(
        ScheduleDate: ScheduleDate!,
        StartTime: startDateTime,
        EndTime: endDateTime,
        SalaryRate: SalaryRate ?? 0,
        //TotalHours: _calculateTotalHours(StartTime!, EndTime!),
      );

      ScheduleController().addSchedule(schedule);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Schedule saved successfully')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ListSchedulePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
    }
  }

  //CANCEL THE PROCESS
  void _onCancel() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ListSchedulePage()),
    );
  }
}
