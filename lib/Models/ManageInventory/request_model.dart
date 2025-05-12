/*import 'package:cloud_firestore/cloud_firestore.dart';

class ItemRequest {
  final String id;
  final String itemName;
  final int quantity;
  final String requestedBy; //workshop owner ID
  final String requestedTo; //workshop owner ID
  final DateTime requestDate;
  final String status;

  ItemRequest({
     required this.id,
    required this.itemName,
    required this.quantity,
    required this.requestedBy,
    required this.requestedTo,
    required this.requestDate,
    required this.status, //required String requestBy, required String requestTo,
  });

  factory ItemRequest.fromJson(Map<String, dynamic> json) {
    return ItemRequest(
      id: json['id'] ?? '',
      itemName: json['itemName'] ?? '',
      quantity: json['quantity'] is int
          ? (json['quantity'] as int).toDouble() 
          : (json['quantity'] ?? 0.0),
      requestedBy: json['requestedBy'] ?? '',
      requestedTo: json['requestedTo'] ?? '',
      requestDate: json['requestDate'] is Timestamp 
          ? (json['requestDate'] as Timestamp).toDate() 
          : DateTime.parse(json['requestDate']),
      status: RequestStatusExtension.fromString(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // We don't include id in toJson because Firestore manages that separately
      'itemName': itemName,
      'quantity': quantity,
      'requestedBy': requestedBy,
      'requestedTo': requestedTo,
      'requestDate': requestDate.toIso8601String(),
      'status': status.toString().split('.').last,
    };
  }

  ItemRequest copyWith({
    String? id,
    String? itemName,
    int? quantity,
    String? requestedBy,
    String? requestedTo,
    DateTime? requestDate,
    String? status,
  }) {
    return ItemRequest(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      requestedBy: requestedBy ?? this.requestedBy,
      requestedTo: requestedTo ?? this.requestedTo,
      requestDate: requestDate ?? this.requestDate,
      status: status ?? this.status,
      
    );
  }

}
enum RequestStatus {
  pending,
  approved,
  rejected,
  shipped,
  completed
}

// Extension for request status methods
extension RequestStatusExtension on RequestStatus {
  String get name {
    return toString().split('.').last;
  }

  String get displayName {
    return name[0].toUpperCase() + name.substring(1);
  }

  static RequestStatus fromString(String status) {
    return RequestStatus.values.firstWhere(
      (e) => e.toString().split('.').last == status,
      orElse: () => RequestStatus.pending,
    );
  }
}
*//*
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemRequest {
  final String id;
  final String itemName;
  final int quantity;
  final String requestedBy; //workshop owner ID
  final String requestedTo; //workshop owner ID
  final DateTime requestDate;
  //final String status;

  ItemRequest({
    required this.id,
    required this.itemName,
    required this.quantity,
    required this.requestedBy,
    required this.requestedTo,
    required this.requestDate,
   // required this.status, //required String requestBy, required String requestTo,
  });

  factory ItemRequest.fromJson(Map<String, dynamic> json) {
    return ItemRequest(
      id: json['id'] ?? '',
      itemName: json['itemName'] ?? '',
      quantity: json['quantity'] is int
          ? (json['quantity'] as int).toDouble() 
          : (json['quantity'] ?? 0.0),
      requestedBy: json['requestedBy'] ?? '',
      requestedTo: json['requestedTo'] ?? '',
      requestDate: json['requestDate'] is Timestamp 
          ? (json['requestDate'] as Timestamp).toDate() 
          : DateTime.parse(json['requestDate']),
     // status: RequestStatusExtension.fromString(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // We don't include id in toJson because Firestore manages that separately
      'itemName': itemName,
      'quantity': quantity,
      'requestedBy': requestedBy,
      'requestedTo': requestedTo,
      'requestDate': requestDate.toIso8601String(),
      //'status': status.toString().split('.').last,
    };
  }

  ItemRequest copyWith({
    String? id,
    String? itemName,
    int? quantity,
    String? requestedBy,
    String? requestedTo,
    DateTime? requestDate,
   // String? status,
  }) {
    return ItemRequest(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      requestedBy: requestedBy ?? this.requestedBy,
      requestedTo: requestedTo ?? this.requestedTo,
      requestDate: requestDate ?? this.requestDate,
      //status: status ?? this.status,
      
    );
  }

}
/*enum RequestStatus {
  pending,
  approved,
  rejected,
  shipped,
  completed
}

// Extension for request status methods
extension RequestStatusExtension on RequestStatus {
  String get name {
    return toString().split('.').last;
  }

  String get displayName {
    return name[0].toUpperCase() + name.substring(1);
  }

  static RequestStatus fromString(String status) {
    return RequestStatus.values.firstWhere(
      (e) => e.toString().split('.').last == status,
      orElse: () => RequestStatus.pending,
    );
  }
}
*/
*/


