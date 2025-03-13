import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firetasks/models/task_model.dart';
import 'package:firetasks/widgets/custom_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firetasks/providers/task_provider.dart'; // Import TaskProvider

class CreateTaskPage extends StatefulWidget {
  final Task? task;
  final int? taskIndex;

  const CreateTaskPage({super.key, this.task, this.taskIndex});

  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  String priority = 'Medium';
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description;
      timeController.text = widget.task!.timeAndDate;
      priority = widget.task!.priority;
      isChecked = widget.task!.isChecked;
    } else {
      timeController.text = DateFormat('yyyy-MM-dd, h:mm a').format(DateTime.now());
      isChecked = false;
    }
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );
      if (pickedTime != null) {
        final DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          timeController.text = DateFormat('yyyy-MM-dd, h:mm a').format(finalDateTime);
        });
      }
    }
  }

  Widget _buildPriorityButton(String priorityValue, Color color) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: priority == priorityValue ? color : Colors.grey.shade300,
          foregroundColor: priority == priorityValue ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          setState(() {
            priority = priorityValue;
          });
        },
        child: Text(priorityValue),
      ),
    );
  }

  Future<void> _saveOrUpdateTask() async {
    User? user = FirebaseAuth.instance.currentUser;
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();
    String timeAndDate = timeController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title and Description cannot be empty!")),
      );
      return;
    }

    Task task = Task(
      title: title,
      description: description,
      timeAndDate: timeAndDate,
      priority: priority,
      isChecked: isChecked,
    );

    // Use TaskProvider to save or update the task
    if (widget.task == null) {
      // Save new task using TaskProvider
      await context.read<TaskProvider>().saveTask(task, user!.uid);
    } else {
      // Update existing task using TaskProvider
      task.id = widget.task!.id; // Retain existing ID
      await context.read<TaskProvider>().updateTask(task);
    }

    Navigator.pop(context); // Close the screen after saving/updating
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: timeController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Time & Date',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectDateTime,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPriorityButton('High', Colors.red),
                  const SizedBox(width: 10),
                  _buildPriorityButton('Medium', Colors.orange),
                  const SizedBox(width: 10),
                  _buildPriorityButton('Low', Colors.green),
                ],
              ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: _saveOrUpdateTask,
                text: widget.task == null ? 'Done' : 'Update',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
