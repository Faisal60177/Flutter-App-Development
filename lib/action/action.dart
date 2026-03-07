import 'package:cloud_firestore/cloud_firestore.dart';

class TaskAction{

  static final taskCollection=FirebaseFirestore.instance.collection('task');

  // Fetch Stream Task List
  static Stream<QuerySnapshot<Map<String,dynamic>>> fetchTasks(){
    return taskCollection.snapshots();
  }


}