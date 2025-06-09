import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  //final String ScheduleID;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime scheduleDate;
  final int salaryRate;
  final double totalHours;
  final String? docId;
  final String status; // Default status
  final String? workshopName;
  final String? jobDescription;
  final bool isRated; // Default to 'false'

  Schedule({
    //required this.ScheduleID,
    required this.startTime,
    required this.endTime,
    required this.scheduleDate,
    required this.salaryRate,
    required this.totalHours,
    required this.docId,
    this.status = 'pending', // Default to 'pending'
    this.workshopName,
    required this.jobDescription,
    this.isRated = false // Default to 'false'
  });

  // Proper factory method
  factory Schedule.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    String? workshopName,
  }) {
    final data = doc.data();
     if (data == null) {
    throw StateError('Missing data for schedule: ${doc.id}');
  }
    return Schedule(
      //ScheduleID: doc.ScheduleID,
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      scheduleDate: (data['scheduleDate'] as Timestamp).toDate(),
      salaryRate: data['salaryRate'] ?? 0, 
      totalHours:(data['totalHours'] as num?)?.toDouble() ??0.0, 
      docId: doc.id,
      status: data['status'] ?? 'pending', 
      workshopName: workshopName, 
      jobDescription: data['jobDescription'] ?? '', 
      isRated: data['isRated'] ?? false, 
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
      status: map['status'] ?? 'pending',
      jobDescription: map['jobDescription'] ?? '',
      isRated: map['isRated'] ?? false,
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
      'status': status, 
      'jobDescription': jobDescription ?? '', 
      'isRated': isRated,
    };
  }
}
