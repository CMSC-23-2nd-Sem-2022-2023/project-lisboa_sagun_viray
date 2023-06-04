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
    return db
        .collection("entries")
        .where("status", whereIn: ["pendingEdit", "clone"]).snapshots();
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
        .where("status", isEqualTo: "pendingEdit")
        .snapshots();
  }

  Stream<QuerySnapshot> getAllPendingEntries() {
    return db
        .collection("entries")
        .where("status", whereIn: ["clone", "pendingDelete"]).snapshots();
  }

  Future<String> deletePendingEntries(String? id) async {
    CollectionReference entriesCollection = db.collection("entries");

    await entriesCollection.doc(id).update({"status": "deleted"});

    return 'successfully deleted pending entry';
  }

  Future<String> addToQuarantine(String studno) async {
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

  Future<String> turnToAdmin(String studno) async {
    CollectionReference entriesCollection = db.collection("users");

    await entriesCollection
        .where("studno", isEqualTo: studno)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot document) {
        entriesCollection.doc(document.id).update({"userType": "admin"});
      });
    });
    return 'successfully turned student to admin';
  }

  Future<String> turnToEntranceMonitor(String studno) async {
    CollectionReference entriesCollection = db.collection("users");

    await entriesCollection
        .where("studno", isEqualTo: studno)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot document) {
        entriesCollection.doc(document.id).update({"userType": "monitor"});
      });
    });
    return 'successfully turned student to monitor';
  }

  Future<String> turnToPendingDelete(String? id) async {
    CollectionReference entriesCollection = db.collection("entries");

    await entriesCollection.doc(id).update({"status": "pendingDelete"});
    return 'successfully put entry to pending delete';
  }

  Future<String> turnToPendingEdit(String? id) async {
    CollectionReference entriesCollection = db.collection("entries");

    await entriesCollection.doc(id).update({"status": "pendingEdit"});
    return 'successfully put entry to pending edit';
  }

  Future<int> getQuarantineCount(String studno) async {
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

  Future<String> removeFromQuarantine(String studno) async {
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
      Map<String, dynamic> data2 = snapshot2.data() as Map<String, dynamic>;
      String preserveId = snapshot1.id; // Get the original 'id' field value

      data2['id'] =
          preserveId; // Set the 'id' field in data2 to the original 'id' value

      // Remove the 'id' and 'status' fields from data2, so they won't be overwritten
      data2.remove('id');
      data2.remove('status');

      await entriesCollection
          .doc(id1)
          .set(data2); // Replace the content of id1 with data2
      await entriesCollection.doc(id2).delete(); // Delete snapshot2
      await entriesCollection.doc(id1).update({'status': 'open'});
      return 'Successfully replaced content of $id1 with $id2 and deleted $id2';
    } else {
      return 'Document with ID $id1 or $id2 does not exist';
    }
  }

  Stream<QuerySnapshot> getEntries(String UID) {
    final refs = db.collection('entries');
    return refs
        .where('UID', isEqualTo: UID)
        .where('status', isNotEqualTo: 'clone')
        .snapshots();
  }

  Stream<QuerySnapshot> getClone(String id) {
    return db
        .collection('entries')
        .where('replacementId', isEqualTo: id)
        .snapshots();
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
