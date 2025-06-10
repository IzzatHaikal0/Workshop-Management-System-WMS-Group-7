import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String? id;
  final String itemName;
  final String itemCategory;
  final int quantity;
  final double unitPrice;
  final String workshopOwnerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Item({
    this.id,
    required this.itemName,
    required this.itemCategory,
    required this.quantity,
    required this.unitPrice,
    required this.workshopOwnerId,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'itemCategory': itemCategory,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'workshopOwnerId': workshopOwnerId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Item.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Item(
      id: doc.id,
      itemName: data['itemName'] ?? '',
      itemCategory: data['itemCategory'] ?? '',
      quantity: data['quantity'] ?? 0,
      unitPrice: (data['unitPrice'] ?? 0.0).toDouble(),
      workshopOwnerId: data['workshopOwnerId'] ?? '',
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
    );
  }

  factory Item.fromMap(Map<String, dynamic> data, String id) {
    return Item(
      id: id,
      itemName: data['itemName'] ?? '',
      itemCategory: data['itemCategory'] ?? '',
      quantity: data['quantity'] ?? 0,
      unitPrice: (data['unitPrice'] ?? 0.0).toDouble(),
      workshopOwnerId: data['workshopOwnerId'] ?? '', // Include from Map
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
    );
  }

  Item copyWith({
    String? id,
    String? itemName,
    String? itemCategory,
    int? quantity,
    double? unitPrice,
    String? workshopOwnerId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Item(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      itemCategory: itemCategory ?? this.itemCategory,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      workshopOwnerId: workshopOwnerId ?? this.workshopOwnerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
