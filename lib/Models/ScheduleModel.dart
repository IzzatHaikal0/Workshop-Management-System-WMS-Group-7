import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  //final String ScheduleID;
  final DateTime StartTime;
  final DateTime EndTime;
  final DateTime ScheduleDate;
  final int SalaryRate;
  final double TotalHours;
  final String? docId;

  Schedule({
    //required this.ScheduleID,
    required this.StartTime,
    required this.EndTime,
    required this.ScheduleDate,
    required this.SalaryRate,
    required this.TotalHours,
    required this.docId,
  });

  // Proper factory method
  factory Schedule.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Schedule(
      //ScheduleID: doc.ScheduleID,
      StartTime: (data['StartTime'] as Timestamp).toDate(),
      EndTime: (data['EndTime'] as Timestamp).toDate(),
      ScheduleDate: (data['ScheduleDate'] as Timestamp).toDate(),
      SalaryRate: data['SalaryRate'] ?? 0, // Default to 0 if not present
      TotalHours: (data['TotalHours'] as num?)?.toDouble() ?? 0.0,// Default to 0 if not present
      docId: doc.id,
    );
  }

  // Convert Schedule object to Firestore-compatible map
  Map<String, dynamic> toJson() {
    return {
      'StartTime': Timestamp.fromDate(StartTime),
      'EndTime': Timestamp.fromDate(EndTime),
      'ScheduleDate': Timestamp.fromDate(ScheduleDate),
      'SalaryRate': SalaryRate,
      'TotalHours': TotalHours,
    };
  }
}
