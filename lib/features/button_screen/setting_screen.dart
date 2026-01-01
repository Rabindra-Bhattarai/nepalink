import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final List<Map<String, String>> _tasks = [];

  void _addTaskDialog() {
    final formKey = GlobalKey<FormState>();
    final TextEditingController titleController = TextEditingController();
    final TextEditingController timeController = TextEditingController();
    final TextEditingController noteController = TextEditingController();
    String? selectedStatus;
    String amPm = "AM"; // default

    // Formatter: auto insert ":" after 2 digits
    final timeFormatter = [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
      LengthLimitingTextInputFormatter(5),
      TextInputFormatter.withFunction((oldValue, newValue) {
        String text = newValue.text;
        if (text.length == 2 && !text.contains(":")) {
          text = "$text:";
        }
        return TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      }),
    ];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add New Task"),
        content: SingleChildScrollView(
          child: SizedBox(
            width: double.maxFinite,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Task Title
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: "Task Title"),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 12),

                  // Manual Time Input + AM/PM dropdown
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: timeController,
                          decoration: const InputDecoration(
                            labelText: "Time (HH:MM)",
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: timeFormatter,
                          validator: (value) => value == null || value.isEmpty
                              ? "Required"
                              : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: amPm,
                        items: const [
                          DropdownMenuItem(value: "AM", child: Text("AM")),
                          DropdownMenuItem(value: "PM", child: Text("PM")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            amPm = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Status Dropdown
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Status"),
                    items: const [
                      DropdownMenuItem(
                        value: "Pending",
                        child: Text("Pending"),
                      ),
                      DropdownMenuItem(
                        value: "Completed",
                        child: Text("Completed"),
                      ),
                    ],
                    onChanged: (value) => selectedStatus = value,
                    validator: (value) => value == null ? "Required" : null,
                  ),
                  const SizedBox(height: 12),

                  // Additional Note
                  TextFormField(
                    controller: noteController,
                    decoration: const InputDecoration(
                      labelText: "Additional Note (optional)",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                setState(() {
                  _tasks.add({
                    "title": titleController.text,
                    "time": "${timeController.text} $amPm",
                    "status": selectedStatus!,
                    "note": noteController.text,
                  });
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _addTaskButton(),
            const SizedBox(height: 20),
            Expanded(child: _taskList()), // ✅ prevents overflow
          ],
        ),
      ),
    );
  }

  Widget _addTaskButton() {
    return SizedBox(
      width: double.infinity, // ✅ ensures button fits screen width
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _addTaskDialog,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Add New Task",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _taskList() {
    if (_tasks.isEmpty) {
      return const Center(child: Text("No tasks added yet."));
    }

    return ListView.builder(
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.check_circle, color: Colors.green),
            title: Text(task["title"]!),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Time: ${task["time"]}"),
                Text("Status: ${task["status"]}"),
                if (task["note"]!.isNotEmpty) Text("Note: ${task["note"]}"),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  _tasks.removeAt(index);
                });
              },
            ),
          ),
        );
      },
    );
  }
}
