import 'package:cloud_firestore/cloud_firestore.dart';

/// REPRESENTS AN ITEM REQUEST RECORD IN THE SYSTEM
class Request {
  final String? id;
  final String itemName;
  final int quantity;
  final String requestedBy;
  final String status; // pending, accepted, rejected
  final DateTime requestDate;
  final String? notes;
  final String? approvedBy;
  final DateTime? approvedDate;
  final DateTime? shippedDate;

  Request({
    this.id,
    required this.itemName,
    required this.quantity,
    required this.requestedBy,
    required this.status,
    required this.requestDate,
    this.notes,
    this.approvedBy,
    this.approvedDate,
    this.shippedDate,
  });

  /// CONVERTS REQUEST OBJECT INTO A MAP FOR FIRESTORE
  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'quantity': quantity,
      'requestedBy': requestedBy,
      'status': status,
      'requestDate': requestDate,
      'notes': notes,
      'approvedBy': approvedBy,
      'approvedDate': approvedDate,
      'shippedDate': shippedDate,
    };
  }

  /// CREATES A REQUEST OBJECT FROM A FIRESTORE DOCUMENT SNAPSHOT
  factory Request.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Request(
      id: doc.id,
      itemName: data['itemName'] ?? '',
      quantity: data['quantity'] ?? 0,
      requestedBy: data['requestedBy'] ?? '',
      status: data['status'] ?? 'pending',
      requestDate: data['requestDate']?.toDate() ?? DateTime.now(),
      notes: data['notes'],
      approvedBy: data['approvedBy'],
      approvedDate: data['approvedDate']?.toDate(),
      shippedDate: data['shippedDate']?.toDate(),
    );
  }

  /// CREATES A REQUEST OBJECT FROM A RAW MAP AND A GIVEN ID
  factory Request.fromMap(Map<String, dynamic> data, String id) {
    return Request(
      id: id,
      itemName: data['itemName'] ?? '',
      quantity: data['quantity'] ?? 0,
      requestedBy: data['requestedBy'] ?? '',
      status: data['status'] ?? 'pending',
      requestDate: data['requestDate']?.toDate() ?? DateTime.now(),
      notes: data['notes'],
      approvedBy: data['approvedBy'],
      approvedDate: data['approvedDate']?.toDate(),
      shippedDate: data['shippedDate']?.toDate(),
    );
  }

  /// RETURNS A NEW REQUEST OBJECT WITH UPDATED VALUES
  Request copyWith({
    String? id,
    String? itemName,
    int? quantity,
    String? requestedBy,
    String? status,
    DateTime? requestDate,
    String? notes,
    String? approvedBy,
    DateTime? approvedDate,
    DateTime? shippedDate,
  }) {
    return Request(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      requestedBy: requestedBy ?? this.requestedBy,
      status: status ?? this.status,
      requestDate: requestDate ?? this.requestDate,
      notes: notes ?? this.notes,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedDate: approvedDate ?? this.approvedDate,
      shippedDate: shippedDate ?? this.shippedDate,
    );
  }
}
