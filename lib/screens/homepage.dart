import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firetasks/models/task_model.dart';
import 'package:firetasks/models/user_model.dart';
import 'package:firetasks/screens/create_tasks.dart';
import 'package:firetasks/screens/login_page.dart';
import 'package:firetasks/services/authentication.dart';
import 'package:firetasks/widgets/custom_button.dart';
import 'package:firetasks/widgets/drawer.dart';
import 'package:firetasks/services/database.dart'; 
import 'package:firetasks/widgets/task_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> filteredTasks = [];
  UserModel? userModel;
  bool isLoading = true;
  User? user = FirebaseAuth.instance.currentUser;
  final FirestoreMethods _firestoreMethods = FirestoreMethods(FirebaseFirestore.instance); 

  void _navigateToLogInCreateAccountScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginCreateAccountScreen(),
      ),
    );
  }

  void _navigateToCreateTaskPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateTaskPage(),
      ),
    );
  }

  void _signOutUser() async {
    FirebaseAuthMethods(FirebaseAuth.instance).signOut(context);
  }
  
  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchTasks(user!.uid);
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      UserModel? fetchedUser = await _firestoreMethods.getUserData(user!.uid);
      if (fetchedUser != null) {
        setState(() {
          userModel = fetchedUser;
          isLoading = false;
        });
      }
    }
  }

  void _fetchTasks(String userUid) {
  FirebaseFirestore.instance
      .collection('tasks')
      .doc(userUid)
      .collection('userTasks')
      .snapshots()
      .listen((snapshot) {
    setState(() {
      filteredTasks = snapshot.docs.map((doc) => Task.fromMapObject(doc.data())).toList();
    });
  });
}

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FireTasks"),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () => _navigateToCreateTaskPage(context)),
          const SizedBox(width: 30),
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
             builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return const SizedBox(
                    width: 15); // Empty space instead of button
              } else {
                return CustomButton(
                  onPressed: () => _navigateToLogInCreateAccountScreen(context),
                  text: 'Login',
                );
              }
            },
          ),
          const SizedBox(width: 30),
        ],
      ),
      drawer: userModel == null 
    ? null  // Prevents opening the drawer when userModel is null
    : CustomDrawer(
        userModel: userModel!,
        onLogout: _signOutUser,
        onExit: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: filteredTasks.isEmpty ? 1 : filteredTasks.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 5 / 5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            if (filteredTasks.isEmpty) {
              return GestureDetector(
                onTap: () => _navigateToCreateTaskPage(context),
                child: TaskCard(
                  task: Task(
                    id: 0,
                    title: 'Welcome to task manager',
                    description: 'Add your tasks.',
                    timeAndDate: '',
                    priority: '',
                    isChecked: false,
                  ),
                  onCheckboxChanged: null,
                  onDelete: null,
                ),
              );
            }
            final task = filteredTasks[index];
            return DragTarget<Task>(
              onAcceptWithDetails: (draggedTask) {
                setState(() {
                  int oldIndex = filteredTasks.indexOf(draggedTask as Task);
                  filteredTasks.removeAt(oldIndex);
                  filteredTasks.insert(index, draggedTask as Task);
                });
              },
              builder: (context, candidateData, rejectedData) {
                return Opacity(
                  opacity: task.isChecked ? 0.5 : 1.0,
                  child: Draggable<Task>(
                    data: task,
                    feedback: Material(
                      child: TaskCard(
                        task: task,
                        onCheckboxChanged: null,
                        onDelete: null,
                      ),
                    ),
                    childWhenDragging: const SizedBox.shrink(),
                    child: GestureDetector(
                      onTap: () {},
                      child: TaskCard(
                        task: task,
                        onCheckboxChanged: (value) {
                          setState(() {
                            task.isChecked = value ?? false;
                          });
                        },
                        onDelete: () {},
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
