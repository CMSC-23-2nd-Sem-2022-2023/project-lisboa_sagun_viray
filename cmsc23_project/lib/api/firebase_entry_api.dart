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

  Stream<QuerySnapshot> getAllStudents() {
    return db
        .collection("users")
        .where("userType", isEqualTo: "student")
        .snapshots();
  }

  Stream<QuerySnapshot> getQuarantinedStudents() {
    return db
        .collection("users")
        .where("userType", isEqualTo: "student")
        .where("isQuarantined", isEqualTo: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getUnderMonitoringStudents() {
    return db
        .collection("users")
        .where("userType", isEqualTo: "student")
        .where("isUnderMonitoring", isEqualTo: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getPendingDeleteEntries() {
    return db
        .collection("entries")
        .where("status", isEqualTo: "pendingDelete")
        .snapshots();
  }

  Stream<QuerySnapshot> getPendingEditEntries() {
    return db
        .collection("entries")
        .where("status", isEqualTo: "pendingDelete")
        .snapshots();
  }

  Future<String> deletePendingEntries() async {
    CollectionReference entriesCollection = db.collection("entries");

    await entriesCollection
        .where("status", isEqualTo: "pending")
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot document) {
        entriesCollection.doc(document.id).update({"status": "deleted"});
      });
    });

    return 'successfully deleted pending entry';
  }

  Future<String> AddToQuarantine(String studno) async {
    CollectionReference entriesCollection = db.collection("users");

    await entriesCollection
        .where("studno", isEqualTo: studno)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot document) {
        entriesCollection.doc(document.id).update({"isQuarantined": true});
      });
    });
    return 'successfully put student into quarantine';
  }

  Future<int> GetQuarantineCount(String studno) async {
    CollectionReference entriesCollection = db.collection("users");

    QuerySnapshot snapshot =
        await entriesCollection.where("studno", isEqualTo: studno).get();

    int count = 0;
    for (DocumentSnapshot document in snapshot.docs) {
      await entriesCollection.doc(document.id).update({"isQuarantined": true});
      count++;
    }

    return count;
  }

  Future<String> RemoveFromQuarantine(String studno) async {
    CollectionReference entriesCollection = db.collection("users");

    await entriesCollection
        .where("studno", isEqualTo: studno)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot document) {
        entriesCollection.doc(document.id).update({"isQuarantined": false});
      });
    });

    return 'successfully removed student from quarantine';
  }

  Future<String> replacePendingEntries(String id1, String id2) async {
    CollectionReference entriesCollection = db.collection("entries");

    DocumentSnapshot snapshot1 = await entriesCollection.doc(id1).get();
    DocumentSnapshot snapshot2 = await entriesCollection.doc(id2).get();

    if (snapshot1.exists && snapshot2.exists) {
      Map<String, dynamic> data2 = snapshot2.data()
          as Map<String, dynamic>; // Explicitly cast to Map<String, dynamic>
      await entriesCollection.doc(id1).set(data2);
      await entriesCollection.doc(id2).delete(); // Delete snapshot2

      return 'Successfully replaced content of $id1 with $id2 and deleted $id2';
    } else {
      return 'Document with ID $id1 or $id2 does not exist';
    }
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
}
