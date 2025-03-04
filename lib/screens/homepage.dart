import 'package:firetasks/models/task_model.dart';
import 'package:firetasks/screens/create_tasks.dart';
import 'package:firetasks/screens/login_page.dart';
import 'package:firetasks/widgets/custom_button.dart';
import 'package:firetasks/widgets/drawer.dart';
import 'package:firetasks/widgets/task_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> filteredTasks = [];

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
        builder: (context) => CreateTaskPage(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FireTasks"),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () => _navigateToCreateTaskPage(context)),
          const SizedBox(width: 30), 
          CustomButton(
            text: "Log In",
            onPressed: () => _navigateToLogInCreateAccountScreen(context),
          ),
          const SizedBox(width: 30),
        ],
      ),
      drawer: CustomDrawer(
        username: 'Sakib Anjum Arnab',
        email: 'arnab@example.com',
        profilePictureUrl: 'https://www.example.com/profile-picture.jpg',
        isBackupEnabled: false,
        onBackupToggle: (bool value) {
          // Handle backup toggle functionality here
        },
        onLogout: () {}, // Logout functionality here
        onExit: () => Navigator.pop(context)
      ),
      body:Padding(
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
            return Opacity(
              opacity: task.isChecked ? 0.5 : 1.0,
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
            );
          },
        ),
      ),
    );
  }
}
