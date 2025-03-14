import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firetasks/models/task_model.dart';
import 'package:firetasks/models/user_model.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore;
  FirestoreMethods(this._firestore);
  final CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('tasks');


  // Save user data to Firestore
  Future<void> saveUserData(UserModel user, String uid) async {
    try {
      await _firestore.collection('users').doc(uid).set(user.toMap());
      print("User data saved successfully.");
    } catch (e) {
      print("Error saving user data: $e");
    }
  }

  // Fetch user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return null;
  }

  Future<void> saveTaskData(Task task, String userUid) async {
  try {
    CollectionReference userTasksCollection =
        tasksCollection.doc(userUid).collection('userTasks');

    String taskUid = userTasksCollection.doc().id; // Generate document ID
    task.id = taskUid; // Store actual document ID

    await userTasksCollection.doc(taskUid).set(task.toMap());

    print("Task data saved successfully with ID: $taskUid");
  } catch (e) {
    print("Error saving task data: $e");
  }
}


  // Read tasks from Firestore for a specific user
 Stream<List<Task>> getTasks(String userUid) {
  return tasksCollection
      .doc(userUid)
      .collection('userTasks')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return Task.fromMapObject(doc.data() as Map<String, dynamic>)
        ..id = doc.id; // Assign actual Firestore ID
    }).toList();
  });
}


  // Update task data in Firestore
  Future<void> updateTaskData(Task task, String userUid) async {
    try {
      // await tasksCollection.doc(task.id.toString()).update(task.toMap());
      await tasksCollection.doc(userUid).collection('userTasks').doc(task.id.toString()).update(task.toMap());
      print("Task data updated successfully.");
    } catch (e) {
      print("Error updating task data: $e");
    }
  }

  // Delete task data from Firestore
  Future<void> deleteTaskData(String id, String userUid) async {
  try {
    // await tasksCollection.doc(id).delete();
    await tasksCollection.doc(userUid).collection('userTasks').doc(id.toString()).delete();
    print("Task data deleted successfully.");
  } catch (e) {
    print("Error deleting task data: $e");
  }
}
}
