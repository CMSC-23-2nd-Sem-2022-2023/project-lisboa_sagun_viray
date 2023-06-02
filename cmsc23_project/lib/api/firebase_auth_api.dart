import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/user/user_details.dart';
import '../models/user_model.dart';
import '../models/admin_model.dart';
import '../models/health_monitor_model.dart';

class FirebaseAuthAPI {
  // allows access to the firestore database
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  // allows authentification using the Firebase Authentication
  static final FirebaseAuth auth = FirebaseAuth.instance;

  // returns a stream of firebase user objects
  Stream<User?> getUser() {
    return auth.authStateChanges();
  }

  // adds a new document to the firestore collection "users"
  // then updates the newly added document's field id with the generated id
  Future<String> addUser(Map<String, dynamic> user) async {
    try {
      // final docRef = await db.collection("users").add(user);
      // await db.collection("users").doc(docRef.id).update({'id': docRef.id});
      await db.collection("users").doc(user["id"]).set(user);
      return "Successfully added user!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> addHealthMonitor(Map<String, dynamic> hm) async {
    try {
      await db.collection("entrance_monitor").doc(hm["id"]).set(hm);
      // final docRef = await db.collection("admin").add(admin);
      // await db.collection("admin").doc(docRef.id).update({'id': docRef.id});
      return "Successfully added healthmonitor!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> signIn(String email, String password) async {
    UserCredential credential;
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      //let's print the object returned by signInWithEmailAndPassword
      //you can use this object to get the user's id, email, etc.
      print(credential);
      return 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //possible to return something more useful
        //than just print an error message to improve UI/UX
        print('No user found for that email.');
        return 'No user found with that email';
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return 'Wrong password';
      }
    }
    return '';
  }

  Future<void> signUp(String email, String password, UserRecord u) async {
    UserCredential credential;
    try {
      // creating a new user account with an email and password
      credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("user ${u.name}'s uid is: ${credential.user!.uid}");

      // sets the credentials of the user
      UserRecord temp = UserRecord(
        id: credential.user!.uid,
        name: u.name,
        username: u.username,
        email: u.email,
        entries: u.entries,
        isUnderMonitoring: u.isUnderMonitoring,
        isQuarantined: u.isQuarantined,
        userType: u.userType,
        college: u.college,
        course: u.course,
        studno: u.studno,
        empno: u.empno,
        position: u.position,
        unit: u.unit,
      );

      addUser(temp.toJson(temp));

      //let's print the object returned by signInWithEmailAndPassword
      //you can use this object to get the user's id, email, etc.\
      print(credential);
    } on FirebaseAuthException catch (e) {
      //possible to return something more useful
      //than just print an error message to improve UI/UX
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    print('trying to signout');
    await auth.signOut();
  }
}
