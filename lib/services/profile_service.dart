import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> fetchForemanProfile(String foremanId) async {
    final doc = await _firestore.collection('foremen').doc(foremanId).get();
    return doc.exists ? doc.data() : null;
  }

  Future<Map<String, dynamic>?> fetchWorkshopOwnerProfile(
    String ownerId,
  ) async {
    final doc =
        await _firestore.collection('workshop_owners').doc(ownerId).get();
    return doc.exists ? doc.data() : null;
  }
}
