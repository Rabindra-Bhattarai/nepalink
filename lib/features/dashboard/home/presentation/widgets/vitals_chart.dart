import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nepalink/features/dashboard/home/domain/entities/activity_entity.dart';

// ─────────────────────────────────────────────
//  Vitals Line Chart (HR, Temp, SpO2)
// ─────────────────────────────────────────────
class VitalsLineChart extends StatefulWidget {
  final List<ActivityEntity> activities;
  const VitalsLineChart({Key? key, required this.activities}) : super(key: key);

  @override
  State<VitalsLineChart> createState() => _VitalsLineChartState();
}

class _VitalsLineChartState extends State<VitalsLineChart> {
  int _selected = 0; // 0=HR, 1=Temp, 2=SpO2

  final _tabs = ['Heart Rate', 'Temperature', 'SpO2'];
  final _colors = [
    const Color(0xFFE07070),
    const Color(0xFFE09C3E),
    const Color(0xFF2A9D7A),
  ];
  final _units = ['bpm', '°C', '%'];

  List<FlSpot> _spots() {
    final sorted = [...widget.activities]
      ..sort((a, b) => a.date.compareTo(b.date));

    final List<FlSpot> spots = [];
    for (int i = 0; i < sorted.length; i++) {
      final v = sorted[i].vitalSigns;
      if (v == null) continue;
      double? value;
      if (_selected == 0) value = v.heartRate;
      if (_selected == 1) value = v.temperature;
      if (_selected == 2) value = v.spo2;
      if (value != null) spots.add(FlSpot(i.toDouble(), value));
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final spots = _spots();
    final color = _colors[_selected];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vital Signs Trend',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2A38),
            ),
          ),
          const SizedBox(height: 12),

          // Tab selector
          Row(
            children: List.generate(_tabs.length, (i) {
              final active = i == _selected;
              return GestureDetector(
                onTap: () => setState(() => _selected = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: active ? _colors[i] : const Color(0xFFF4F7FB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _tabs[i],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: active ? Colors.white : const Color(0xFF9DAAB8),
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 16),

          if (spots.isEmpty)
            const SizedBox(
              height: 140,
              child: Center(
                child: Text(
                  'No data yet',
                  style: TextStyle(color: Color(0xFF9DAAB8)),
                ),
              ),
            )
          else
            SizedBox(
              height: 140,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) =>
                        FlLine(color: const Color(0xFFEAEEF4), strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (v, _) => Text(
                          v.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF9DAAB8),
                          ),
                        ),
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: color,
                      barWidth: 2.5,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: color,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: color.withOpacity(0.08),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 4),
          Text(
            'Unit: ${_units[_selected]}',
            style: const TextStyle(fontSize: 11, color: Color(0xFF9DAAB8)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Activity Status Pie Chart
// ─────────────────────────────────────────────
class ActivityStatusChart extends StatelessWidget {
  final int completed;
  final int pending;
  final int cancelled;

  const ActivityStatusChart({
    Key? key,
    required this.completed,
    required this.pending,
    required this.cancelled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = completed + pending + cancelled;
    if (total == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Activity Status',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2A38),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                height: 90,
                width: 90,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 22,
                    sections: [
                      if (completed > 0)
                        PieChartSectionData(
                          value: completed.toDouble(),
                          color: const Color(0xFF2A9D7A),
                          radius: 28,
                          title: '',
                        ),
                      if (pending > 0)
                        PieChartSectionData(
                          value: pending.toDouble(),
                          color: const Color(0xFFE09C3E),
                          radius: 28,
                          title: '',
                        ),
                      if (cancelled > 0)
                        PieChartSectionData(
                          value: cancelled.toDouble(),
                          color: const Color(0xFFE07070),
                          radius: 28,
                          title: '',
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Legend(
                      color: const Color(0xFF2A9D7A),
                      label: 'Completed',
                      count: completed,
                    ),
                    const SizedBox(height: 8),
                    _Legend(
                      color: const Color(0xFFE09C3E),
                      label: 'Pending',
                      count: pending,
                    ),
                    const SizedBox(height: 8),
                    _Legend(
                      color: const Color(0xFFE07070),
                      label: 'Cancelled',
                      count: cancelled,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  final int count;
  const _Legend({
    required this.color,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            '$label ($count)',
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7A8D)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Daily Care Summary Bar Chart
// ─────────────────────────────────────────────
class DailyCareSummary extends StatelessWidget {
  final List<ActivityEntity> activities;
  const DailyCareSummary({Key? key, required this.activities})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Count how many activities have each daily care field filled
    int meals = 0, hydration = 0, hygiene = 0, mobility = 0, sleep = 0;
    for (final a in activities) {
      final d = a.dailyCare;
      if (d == null) continue;
      if (d.meals?.isNotEmpty == true) meals++;
      if (d.hydration?.isNotEmpty == true) hydration++;
      if (d.hygiene?.isNotEmpty == true) hygiene++;
      if (d.mobility?.isNotEmpty == true) mobility++;
      if (d.sleepQuality?.isNotEmpty == true) sleep++;
    }

    final items = [
      ('Meals', meals, const Color(0xFF2A9D7A)),
      ('Hydration', hydration, const Color(0xFF5BA4CF)),
      ('Hygiene', hygiene, const Color(0xFFE09C3E)),
      ('Mobility', mobility, const Color(0xFF9B7FD4)),
      ('Sleep', sleep, const Color(0xFFE07070)),
    ];

    final total = activities.length == 0 ? 1 : activities.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Care Summary',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2A38),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tracked across all activities',
            style: TextStyle(fontSize: 11, color: Color(0xFF9DAAB8)),
          ),
          const SizedBox(height: 16),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.$1,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7A8D),
                        ),
                      ),
                      Text(
                        '${item.$2}/$total',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: item.$3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: item.$2 / total,
                      minHeight: 6,
                      backgroundColor: const Color(0xFFEAEEF4),
                      valueColor: AlwaysStoppedAnimation<Color>(item.$3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
