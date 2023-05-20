import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/user_details.dart';
import '../models/user_model.dart';

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
  Future<String> addUser(Map<String, dynamic> todo) async {
    try {
      final docRef = await db.collection("users").add(todo);
      await db.collection("users").doc(docRef.id).update({'id': docRef.id});
      return "Successfully added user!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<void> signIn(String email, String password) async {
    UserCredential credential;
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      //let's print the object returned by signInWithEmailAndPassword
      //you can use this object to get the user's id, email, etc.
      print(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //possible to return something more useful
        //than just print an error message to improve UI/UX
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signUp(String email, String password, UserRecord u) async {
    UserCredential credential;
    try {
      // creating a new user account with an email and password
      credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // sets the credentials of the user
      UserRecord temp = UserRecord(
        id: credential.user!.uid,
        fname: u.fname,
        lname: u.lname,
        email: u.email,
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
    await auth.signOut();
  }
}
