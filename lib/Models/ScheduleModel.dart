import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  //final String ScheduleID;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime scheduleDate;
  final int salaryRate;
  final double totalHours;
  final String? docId;

  Schedule({
    //required this.ScheduleID,
    required this.startTime,
    required this.endTime,
    required this.scheduleDate,
    required this.salaryRate,
    required this.totalHours,
    required this.docId,
  });

  // Proper factory method
  factory Schedule.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Schedule(
      //ScheduleID: doc.ScheduleID,
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      scheduleDate: (data['scheduleDate'] as Timestamp).toDate(),
      salaryRate: data['salaryRate'] ?? 0, // Default to 0 if not present
      totalHours: (data['totalHours'] as num?)?.toDouble() ??
          0.0, // Default to 0 if not present
      docId: doc.id,
    );
  }

  factory Schedule.fromMap(Map<String, dynamic> map, String docId) {
    return Schedule(
      scheduleDate: (map['scheduleDate'] as Timestamp).toDate(),
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: (map['endTime'] as Timestamp).toDate(),
      salaryRate: map['salaryRate'] ?? 0,
      totalHours: (map['totalHours'] ?? 0).toDouble(),
      docId: docId,
    );
  }

  // Convert Schedule object to Firestore-compatible map
  Map<String, dynamic> toJson() {
    return {
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'scheduleDate': Timestamp.fromDate(scheduleDate),
      'salaryRate': salaryRate,
      'totalHours': totalHours,
    };
  }
}
