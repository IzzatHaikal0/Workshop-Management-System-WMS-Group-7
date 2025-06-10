import 'package:cloud_firestore/cloud_firestore.dart';


class Item {
  final String id;
  final String itemName;
  final String itemCategory;
  final int quantity;
  final double unitPrice;
  final DateTime createdAt;
  final DateTime updatedAt;

  Item({
    required this.id,
    required this.itemName,
    required this.itemCategory,
    required this.quantity,
    required this.unitPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] ?? '',
      itemName: json['itemName'] ?? '',
      itemCategory: json['itemCategory'] ?? '',
      quantity: json['quantity'] is int
          ? (json['quantity'] as int).toDouble() 
          : (json['quantity'] ?? 0.0),
      unitPrice: (json['unitPrice'] is int) 
          ? (json['unitPrice'] as int).toDouble() 
          : json['unitPrice'] ?? 0.0,
      createdAt: json['createdAt'] is Timestamp 
          ? (json['createdAt'] as Timestamp).toDate() 
          : DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] is Timestamp 
          ? (json['updatedAt'] as Timestamp).toDate() 
          : DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // We don't include id in toJson because Firestore manages that separately
      'itemName': itemName,
      'itemCategory': itemCategory,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Item copyWith({
    String? id,
    String? itemName,
    String? itemCategory,
    int? quantity,
    double? unitPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Item(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      itemCategory: itemCategory ?? this.itemCategory,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}