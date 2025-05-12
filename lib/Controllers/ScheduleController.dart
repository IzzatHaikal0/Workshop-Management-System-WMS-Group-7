import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/ScheduleModel.dart';

class ScheduleController {
  static final _collection = FirebaseFirestore.instance.collection('schedules');

  static Future<void> addSchedule(ScheduleModel schedule) async {
    await _collection.add(schedule.toMap());
  }

  static Stream<List<ScheduleModel>> getSchedules() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ScheduleModel.fromMap(data, id: doc.id); // Ensure ID is included
      }).toList();
    });
  }

  static Future<void> deleteSchedule(String id) async {
    await _collection.doc(id).delete();
  }

  static Future<void> updateSchedule(String id, ScheduleModel schedule) async {
    await _collection.doc(id).update(schedule.toMap());
  }
}
