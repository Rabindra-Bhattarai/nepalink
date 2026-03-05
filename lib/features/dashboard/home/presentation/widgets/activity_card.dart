import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nepalink/features/dashboard/home/domain/entities/activity_entity.dart';

class ActivityCard extends StatelessWidget {
  final ActivityEntity activity;

  const ActivityCard({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    activity.description,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E2A38),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _StatusBadge(status: activity.status),
              ],
            ),

            const SizedBox(height: 8),

            // Date
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 13,
                  color: Color(0xFF9DAAB8),
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormat('dd MMM yyyy').format(activity.date),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9DAAB8),
                  ),
                ),
              ],
            ),

            // Vitals summary if available
            if (activity.vitalSigns != null) ...[
              const SizedBox(height: 12),
              const Divider(color: Color(0xFFEAEEF4), height: 1),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (activity.vitalSigns!.heartRate != null)
                    _VitalChip(
                      icon: Icons.favorite_outline,
                      label: '${activity.vitalSigns!.heartRate!.toInt()} bpm',
                      color: const Color(0xFFE07070),
                    ),
                  if (activity.vitalSigns!.bloodPressure != null)
                    _VitalChip(
                      icon: Icons.water_drop_outlined,
                      label: activity.vitalSigns!.bloodPressure!,
                      color: const Color(0xFF5BA4CF),
                    ),
                  if (activity.vitalSigns!.temperature != null)
                    _VitalChip(
                      icon: Icons.thermostat_outlined,
                      label:
                          '${activity.vitalSigns!.temperature!.toStringAsFixed(1)}°C',
                      color: const Color(0xFFE09C3E),
                    ),
                  if (activity.vitalSigns!.spo2 != null)
                    _VitalChip(
                      icon: Icons.air_outlined,
                      label: '${activity.vitalSigns!.spo2!.toInt()}% SpO2',
                      color: const Color(0xFF2A9D7A),
                    ),
                ],
              ),
            ],

            // Pain level if available
            if (activity.medicalTracking?.painLevel != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    'Pain: ',
                    style: TextStyle(fontSize: 12, color: Color(0xFF9DAAB8)),
                  ),
                  _PainIndicator(level: activity.medicalTracking!.painLevel!),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = {
      'completed': (const Color(0xFF2A9D7A), const Color(0xFFE8F4F0)),
      'pending': (const Color(0xFFE09C3E), const Color(0xFFFDF3E3)),
      'cancelled': (const Color(0xFFE07070), const Color(0xFFFDECEC)),
    };
    final pair =
        colors[status] ?? (const Color(0xFF9DAAB8), const Color(0xFFF4F7FB));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: pair.$2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status[0].toUpperCase() + status.substring(1),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: pair.$1,
        ),
      ),
    );
  }
}

class _VitalChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _VitalChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PainIndicator extends StatelessWidget {
  final double level;
  const _PainIndicator({required this.level});

  @override
  Widget build(BuildContext context) {
    final clamped = level.clamp(0, 10);
    final color = clamped <= 3
        ? const Color(0xFF2A9D7A)
        : clamped <= 6
        ? const Color(0xFFE09C3E)
        : const Color(0xFFE07070);

    return Row(
      children: List.generate(10, (i) {
        return Container(
          width: 14,
          height: 8,
          margin: const EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
            color: i < clamped ? color : const Color(0xFFEAEEF4),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
