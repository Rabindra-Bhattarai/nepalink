import 'package:flutter/material.dart';
import 'package:nepalink/features/dashboard/tasks/domain/entities/task_entity.dart';
import 'package:intl/intl.dart';

class TaskCreateDialog extends StatefulWidget {
  final TaskEntity? task; // null for create, non-null for edit

  const TaskCreateDialog({super.key, this.task});

  @override
  State<TaskCreateDialog> createState() => _TaskCreateDialogState();
}

class _TaskCreateDialogState extends State<TaskCreateDialog> {
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  String _status = "pending";

  // Vital signs (stored as strings in TaskEntity)
  String? _bp;
  String? _hr;
  String? _temp;
  String? _spo2;

  // Daily care fields
  late TextEditingController _mealsController;
  late TextEditingController _hydrationController;
  late TextEditingController _hygieneController;

  @override
  void initState() {
    super.initState();
    final task = widget.task;

    _descriptionController = TextEditingController(
      text: task?.description ?? "",
    );
    _selectedDate = task?.date ?? DateTime.now();
    _status = task?.status ?? "pending";

    _bp = task?.vitalSigns?["bloodPressure"];
    _hr = task?.vitalSigns?["heartRate"];
    _temp = task?.vitalSigns?["temperature"];
    _spo2 = task?.vitalSigns?["spo2"];

    _mealsController = TextEditingController(
      text: task?.dailyCare?["meals"] ?? "",
    );
    _hydrationController = TextEditingController(
      text: task?.dailyCare?["hydration"] ?? "",
    );
    _hygieneController = TextEditingController(
      text: task?.dailyCare?["hygiene"] ?? "",
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _mealsController.dispose();
    _hydrationController.dispose();
    _hygieneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[400]!, Colors.blue[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isEditing ? Icons.edit_rounded : Icons.add_task_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      isEditing ? "Edit Task" : "Create New Task",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    onPressed: () => Navigator.pop(context, null),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description Field
                    _buildTextField(
                      controller: _descriptionController,
                      label: "Task Description",
                      icon: Icons.description_rounded,
                      hint: "Enter task details...",
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),

                    // Date Picker
                    _buildDatePicker(context),
                    const SizedBox(height: 20),

                    // Status Dropdown
                    _buildStatusDropdown(),
                    const SizedBox(height: 24),

                    // Vital Signs Section
                    _buildSectionHeader(
                      'Vital Signs',
                      Icons.monitor_heart_rounded,
                      Colors.red,
                    ),
                    const SizedBox(height: 12),
                    _buildVitalSignsGrid(),
                    const SizedBox(height: 24),

                    // Daily Care Section
                    _buildSectionHeader(
                      'Daily Care',
                      Icons.medical_services_rounded,
                      Colors.green,
                    ),
                    const SizedBox(height: 12),
                    _buildDailyCareFields(),
                  ],
                ),
              ),
            ),

            // Footer Actions
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, null),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        side: BorderSide(color: Colors.grey[300]!),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _saveTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isEditing ? Icons.check_rounded : Icons.add_rounded,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isEditing ? "Save Changes" : "Create Task",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.blue[600]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          labelStyle: TextStyle(color: Colors.grey[700]),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.calendar_today_rounded,
              color: Colors.blue[600],
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Task Date',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('EEE, MMM dd, yyyy').format(_selectedDate),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit_calendar_rounded, color: Colors.blue[600]),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Colors.blue[600]!,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                setState(() => _selectedDate = picked);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown() {
    final statusColors = {
      "pending": Colors.blue,
      "in-progress": Colors.lightBlue,
      "completed": Colors.green,
      "cancelled": Colors.red,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: DropdownButtonFormField<String>(
        value: _status,
        decoration: InputDecoration(
          labelText: 'Task Status',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.flag_rounded, color: statusColors[_status]),
        ),
        items: ["pending", "in-progress", "completed", "cancelled"]
            .map(
              (s) => DropdownMenuItem(
                value: s,
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: statusColors[s],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      s.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        onChanged: (val) => setState(() => _status = val!),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildVitalSignsGrid() {
    return Column(
      children: [
        _buildVitalDropdown(
          label: "Blood Pressure",
          icon: Icons.favorite_rounded,
          value: _bp,
          items: ["110/70", "120/80", "130/90", "140/95"],
          onChanged: (val) => setState(() => _bp = val),
          color: Colors.red,
        ),
        const SizedBox(height: 12),
        _buildVitalDropdown(
          label: "Heart Rate",
          icon: Icons.monitor_heart_rounded,
          value: _hr,
          items: ["60", "65", "70", "72", "75", "80", "85", "90"],
          suffix: "bpm",
          onChanged: (val) => setState(() => _hr = val),
          color: Colors.pink,
        ),
        const SizedBox(height: 12),
        _buildVitalDropdown(
          label: "Temperature",
          icon: Icons.thermostat_rounded,
          value: _temp,
          items: ["36.5", "36.8", "37.0", "37.2", "37.5"],
          suffix: "°C",
          onChanged: (val) => setState(() => _temp = val),
          color: Colors.deepOrange,
        ),
        const SizedBox(height: 12),
        _buildVitalDropdown(
          label: "SpO₂",
          icon: Icons.water_drop_rounded,
          value: _spo2,
          items: ["95", "96", "97", "98", "99", "100"],
          suffix: "%",
          onChanged: (val) => setState(() => _spo2 = val),
          color: Colors.lightBlue,
        ),
      ],
    );
  }

  Widget _buildVitalDropdown({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required Color color,
    String suffix = "",
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            hint: Text(
              'Select $label',
              style: TextStyle(fontSize: 13, color: Colors.grey[400]),
            ),
            items: items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      "$item $suffix",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDailyCareFields() {
    return Column(
      children: [
        _buildCareField(
          controller: _mealsController,
          label: "Meals",
          icon: Icons.restaurant_rounded,
          hint: "e.g., Breakfast, Lunch, Dinner",
          color: Colors.green,
        ),
        const SizedBox(height: 12),
        _buildCareField(
          controller: _hydrationController,
          label: "Hydration",
          icon: Icons.local_drink_rounded,
          hint: "e.g., Water intake details",
          color: Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildCareField(
          controller: _hygieneController,
          label: "Hygiene",
          icon: Icons.clean_hands_rounded,
          hint: "e.g., Bath, oral care",
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildCareField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: color, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          labelStyle: TextStyle(color: color),
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
      ),
    );
  }

  void _saveTask() {
    final newTask = TaskEntity(
      id: widget.task?.id ?? "",
      memberId: widget.task?.memberId ?? "",
      nurseId: widget.task?.nurseId ?? "",
      description: _descriptionController.text.trim(),
      date: _selectedDate,
      status: _status,
      vitalSigns: {
        "bloodPressure": _bp ?? "",
        "heartRate": _hr ?? "",
        "temperature": _temp ?? "",
        "spo2": _spo2 ?? "",
      },
      dailyCare: {
        "meals": _mealsController.text.trim(),
        "hydration": _hydrationController.text.trim(),
        "hygiene": _hygieneController.text.trim(),
      },
      medicalTracking: widget.task?.medicalTracking,
      collaboration: widget.task?.collaboration,
      safetyVerification: widget.task?.safetyVerification,
    );

    Navigator.pop(context, newTask);
  }
}
