import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseEntryAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> addEntry(Map<String, dynamic> entry) async {
    try {
      final docRef = await db.collection("entries").add(entry);
      await db.collection("entries").doc(docRef.id).update({'id': docRef.id});
      return "Successfully added entry!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllEntries() {
    return db.collection("entries").snapshots();
  }

  Stream<QuerySnapshot> getEntries(String UID) {
    return db.collection('entries').where('UID', isEqualTo: UID).snapshots();
  }

  // Stream<QuerySnapshot> getMyEntries(){

  // }

  Future<String> deleteEntry(String? id) async {
    try {
      await db.collection("entries").doc(id).delete();

      return "Successfully deleted entry!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<List<DocumentSnapshot>> getEntriesForUser(String userId) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('entries')
          .where('UID', isEqualTo: userId)
          .get();

      return querySnapshot.docs;
    } catch (e) {
      // Handle any errors that occur during the query
      print('Error getting entries for user: $e');
      return [];
    }
  }
}
