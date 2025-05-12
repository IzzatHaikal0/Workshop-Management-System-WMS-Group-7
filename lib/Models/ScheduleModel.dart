class ScheduleModel {
  final String id;
  final String title;
  final String date;

  ScheduleModel({required this.id, required this.title, required this.date});

  factory ScheduleModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return ScheduleModel(
      id: id,
      title: map['title'] ?? '',
      date: map['date'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date,
    };
  }
}
