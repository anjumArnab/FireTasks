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

  // Save task data to Firestore
  Future<void> saveTaskData(Task task, String userUid) async {
  try {
    // Create a reference to the user's task subcollection
    CollectionReference userTasksCollection = tasksCollection
        .doc(userUid)
        .collection('userTasks');

    // Generate a new document ID for the task
    String taskUid = userTasksCollection.doc().id;

    // Save the task data to Firestore
    await userTasksCollection.doc(taskUid).set(task.toMap());

    print("Task data saved successfully with ID: $taskUid");
  } catch (e) {
    print("Error saving task data: $e");
  }
}


  // Read tasks from Firestore
  Stream<List<Task>> getTasks() {
    return tasksCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromMapObject(doc.data() as Map<String, dynamic>)
          ..id = doc.id.hashCode; // Assign Firestore doc ID as hashCode
      }).toList();
    });
  }

  // Update task data in Firestore
  Future<void> updateTaskData(Task task) async {
    try {
      await tasksCollection.doc(task.id.toString()).update(task.toMap());
      print("Task data updated successfully.");
    } catch (e) {
      print("Error updating task data: $e");
    }
  }

  // Delete task data from Firestore
  Future<void> deleteTaskData(int id) async {
    try {
      await tasksCollection.doc(id.toString()).delete();
      print("Task data deleted successfully.");
    } catch (e) {
      print("Error deleting task data: $e");
    }
  }
}
