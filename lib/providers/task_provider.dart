import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firetasks/models/task_model.dart';
import 'package:firetasks/services/database.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class TaskProvider extends ChangeNotifier {
  final FirestoreMethods _firestoreMethods;
  List<Task> _tasks = [];
  bool _isLoading = false;
  StreamSubscription<List<Task>>? _tasksSubscription;

  TaskProvider()
      : _firestoreMethods = FirestoreMethods(FirebaseFirestore.instance);

  // Getters
  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  // Start listening to tasks
  void startListeningToTasks(String userUid) {
    _isLoading = true;
    notifyListeners();

    // Cancel any existing subscription
    _tasksSubscription?.cancel();

    // Start a new subscription
    _tasksSubscription = _firestoreMethods.getTasks(userUid).listen(
      (tasksList) {
        _tasks = tasksList;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Stop listening to tasks
  void stopListeningToTasks() {
    _tasksSubscription?.cancel();
    _tasksSubscription = null;
    _tasks = [];
    notifyListeners();
  }

  // Save a new task
  Future<void> saveTask(Task task, String userUid) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firestoreMethods.saveTaskData(task, userUid);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update an existing task
  Future<void> updateTask(Task task, String userUid) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firestoreMethods.updateTaskData(task, userUid);

      // Update the task in local list
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Toggle task completion status
  Future<void> toggleTaskStatus(Task task, String userUid) async {
    task.isChecked = !task.isChecked;
    await updateTask(task, userUid);
  }

  // Delete task
  Future<void> deleteTask(String taskId, String userUid) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firestoreMethods.deleteTaskData(taskId, userUid);
      _tasks.removeWhere((task) => task.id == taskId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear tasks
  void clearTasks() {
    _tasks = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _tasksSubscription?.cancel();
    super.dispose();
  }
}
