import 'package:flutter/material.dart';
import '../api/firebase_entry_api.dart';
// import '../api/firebase_todo_api.dart';
import '../models/entry_model.dart';
// import '../models/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EntryListProvider with ChangeNotifier {
  late FirebaseEntryAPI firebaseService;
  late Stream<QuerySnapshot> _entriesStream;
  late Stream<QuerySnapshot> _myEntriesStream;
  Future<List<DocumentSnapshot>>? _userEntryStream;

  Entry? _selectedEntry;
  String? _toEdit;

  EntryListProvider() {
    firebaseService = FirebaseEntryAPI();
    fetchEntries();
  }

  // getter
  Stream<QuerySnapshot> get entries => _entriesStream;
  Stream<QuerySnapshot> get myentries => _myEntriesStream;
  Future<List<DocumentSnapshot>>? get userEntries => _userEntryStream;
  Entry get selected => _selectedEntry!;
  String? get replacement => _toEdit;

  changeSelectedEntry(Entry entry) {
    _selectedEntry = entry;
  }

  void setToEdit(String? newToEdit) {
    _toEdit = newToEdit;
    notifyListeners();
  }

  void fetchEntries() {
    _entriesStream = firebaseService.getAllEntries();
    notifyListeners();
  }

  void fetchMyEntries(String UID) async {
    _myEntriesStream = await firebaseService.getEntries(UID);
    notifyListeners();
  }

  Stream<QuerySnapshot> getEntries(String UID) {
    Stream<QuerySnapshot> uEntries = firebaseService.getEntries(UID);
    notifyListeners();
    return uEntries;
  }

  void addEntry(Entry entry) async {
    String message = await firebaseService.addEntry(entry.toJson(entry));
    print(message);
    notifyListeners();
  }

  // void editTodo(int index, String newTitle) {
  //   // _todoList[index].title = newTitle;
  //   print("Edit");
  //   notifyListeners();
  // }

  void deleteEntry() async {
    String message = await firebaseService.deleteEntry(_selectedEntry!.UID);
    print(message);
    notifyListeners();
  }

  void entryPendingDelete(String? id) async {
    String message = await firebaseService.turnToPendingDelete(id);
    print(message);
    notifyListeners();
  }

  void entryPendingEdit(String? id) async {
    String message = await firebaseService.turnToPendingEdit(id);
    print(message);
    notifyListeners();
  }

  void adminDelete(String? id) async {
    String message = await firebaseService.deletePendingEntries(id);
    print(message);
    notifyListeners();
  }

  void adminTurnToPendingDelete(String? id) async {
    String message = await firebaseService.turnToPendingDelete(id);
    print(message);
    notifyListeners();
  }

  void adminReplaceEntry(String? id1, String? id2) async {
    String message = await firebaseService.replacePendingEntries(id1!, id2!);
    print(message);
    notifyListeners();
  }

  Stream<QuerySnapshot> getPendingEditEntries() {
    Stream<QuerySnapshot> pendingEntries =
        firebaseService.getPendingEditEntries();
    // notifyListeners();
    return pendingEntries;
  }

  Stream<QuerySnapshot> getPendingDeleteEntries() {
    Stream<QuerySnapshot> pendingEntries =
        firebaseService.getPendingDeleteEntries();
    // notifyListeners();
    return pendingEntries;
  }

  Stream<QuerySnapshot> getAllPendingEntries() {
    Stream<QuerySnapshot> pendingEntries =
        firebaseService.getAllPendingEntries();
    print("successfully got pending entries");
    // notifyListeners();
    return pendingEntries;
  }
}
