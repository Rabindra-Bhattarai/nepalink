import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/task.dart';

class DashboardCharts extends StatelessWidget {
  final List<Task> tasks;

  const DashboardCharts({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final medicationTasks = tasks
        .where((t) => t.category == "Medication")
        .toList();
    final exerciseTasks = tasks.where((t) => t.category == "Exercise").toList();
    final checkupTasks = tasks.where((t) => t.category == "Checkup").toList();
    final reportTasks = tasks.where((t) => t.category == "Report").toList();

    final Map<String, int> tasksByCategory = {};
    for (var t in tasks) {
      tasksByCategory[t.category] = (tasksByCategory[t.category] ?? 0) + 1;
    }

    return Column(
      children: [
        _chartCard(
          "Overall Task Distribution",
          PieChart(
            PieChartData(
              sections: [
                for (var entry in tasksByCategory.entries)
                  PieChartSectionData(
                    value: entry.value.toDouble(),
                    title: entry.key,
                    color: _categoryColor(entry.key),
                    radius: 60,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        _chartCard(
          "Medication Tasks",
          BarChart(
            BarChartData(
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: medicationTasks
                          .where((t) => t.isCompleted)
                          .length
                          .toDouble(),
                      color: Colors.blue,
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                      toY: medicationTasks
                          .where((t) => !t.isCompleted && !t.isOverdue)
                          .length
                          .toDouble(),
                      color: Colors.orange,
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 2,
                  barRods: [
                    BarChartRodData(
                      toY: medicationTasks
                          .where((t) => t.isOverdue)
                          .length
                          .toDouble(),
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      switch (value.toInt()) {
                        case 0:
                          return SideTitleWidget(
                            meta: meta, // ✅ required
                            space: 5,
                            child: const Text(
                              "Completed",
                              style: TextStyle(fontSize: 10),
                            ),
                          );
                        case 1:
                          return SideTitleWidget(
                            meta: meta, // ✅ required
                            space: 5,
                            child: const Text(
                              "Pending",
                              style: TextStyle(fontSize: 10),
                            ),
                          );
                        case 2:
                          return SideTitleWidget(
                            meta: meta, // ✅ required
                            space: 5,
                            child: const Text(
                              "Overdue",
                              style: TextStyle(fontSize: 10),
                            ),
                          );
                        default:
                          return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),

        _chartCard(
          "Exercise Tasks",
          PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: exerciseTasks
                      .where((t) => t.isCompleted)
                      .length
                      .toDouble(),
                  color: Colors.orange,
                  title: "Completed",
                ),
                PieChartSectionData(
                  value: exerciseTasks
                      .where((t) => !t.isCompleted)
                      .length
                      .toDouble(),
                  color: Colors.grey,
                  title: "Pending",
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        _chartCard(
          "Checkup Tasks Over Time",
          LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  color: Colors.purple,
                  spots: [
                    for (int i = 0; i < checkupTasks.length; i++)
                      FlSpot(i.toDouble(), checkupTasks[i].isCompleted ? 1 : 0),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        _chartCard(
          "Report Tasks",
          PieChart(
            PieChartData(
              centerSpaceRadius: 40,
              sections: [
                PieChartSectionData(
                  value: reportTasks
                      .where((t) => t.isCompleted)
                      .length
                      .toDouble(),
                  color: Colors.teal,
                  title: "Completed",
                ),
                PieChartSectionData(
                  value: reportTasks
                      .where((t) => !t.isCompleted)
                      .length
                      .toDouble(),
                  color: Colors.grey,
                  title: "Pending",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _chartCard(String title, Widget child) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(height: 200, child: child),
          ],
        ),
      ),
    );
  }

  Color _categoryColor(String category) {
    switch (category) {
      case "Medication":
        return Colors.blue;
      case "Exercise":
        return Colors.orange;
      case "Checkup":
        return Colors.purple;
      case "Report":
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}
