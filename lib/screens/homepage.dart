import 'package:firetasks/models/task_model.dart';
import 'package:firetasks/providers/auth_provider.dart';
import 'package:firetasks/providers/task_provider.dart';
import 'package:firetasks/providers/user_provider.dart';
import 'package:firetasks/screens/create_tasks.dart';
import 'package:firetasks/screens/login_page.dart';
import 'package:firetasks/widgets/custom_button.dart';
import 'package:firetasks/widgets/drawer.dart';
import 'package:firetasks/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Initialize providers after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeProviders();
    });
  }

  void _initializeProviders() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    if (authProvider.isAuthenticated) {
      String uid = authProvider.user!.uid;
      userProvider.fetchUserData(uid);
      taskProvider.startListeningToTasks(uid);
    } else {
      userProvider.clearUserData();
      taskProvider.clearTasks();
    }
  }

  void _navigateToLogInCreateAccountScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginCreateAccountScreen(),
      ),
    );
  }

  void _navigateToCreateTaskPage(BuildContext context, {Task? task}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTaskPage(task: task),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<AuthProvider, UserProvider, TaskProvider>(
      builder: (context, authProvider, userProvider, taskProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("FireTasks"),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _navigateToCreateTaskPage(context),
              ),
              const SizedBox(width: 30),
              authProvider.isAuthenticated
                  ? const SizedBox(width: 15)
                  : CustomButton(
                      onPressed: () => _navigateToLogInCreateAccountScreen(context),
                      text: 'Login',
                    ),
              const SizedBox(width: 30),
            ],
          ),
          drawer: userProvider.userModel == null
              ? null
              : CustomDrawer(
                  userModel: userProvider.userModel!,
                  onLogout: () => authProvider.signOut(context),
                  onExit: () => Navigator.pop(context),
                ),
          body: authProvider.isLoading || userProvider.isLoading || taskProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    itemCount: taskProvider.tasks.isEmpty ? 1 : taskProvider.tasks.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 5 / 5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      if (taskProvider.tasks.isEmpty) {
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
                      final task = taskProvider.tasks[index];
                      return GestureDetector(
                        onTap: () => _navigateToCreateTaskPage(context, task: task),
                        child: Opacity(
                          opacity: task.isChecked ? 0.5 : 1.0,
                          child: TaskCard(
                            task: task,
                            onCheckboxChanged: (value) {
                              if (value != null) {
                                task.isChecked = value;
                                taskProvider.updateTask(task);
                              }
                            },
                            onDelete: () {}
                          ),
                        ),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }

  @override
  void dispose() {
    // Stop listening to tasks when the widget is disposed
    Provider.of<TaskProvider>(context, listen: false).stopListeningToTasks();
    super.dispose();
  }
}