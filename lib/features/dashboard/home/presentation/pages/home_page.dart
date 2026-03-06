import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:nepalink/features/dashboard/home/presentation/state/home_state.dart';
import 'package:nepalink/features/dashboard/home/presentation/view_model/home_view_model.dart';
import 'package:nepalink/features/dashboard/home/presentation/widgets/activity_card.dart';
import 'package:nepalink/features/dashboard/home/presentation/widgets/vitals_chart.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // ── Proximity sensor ──
  StreamSubscription<dynamic>? _proximitySub;
  bool _isRefreshing = false; // prevent rapid double-trigger
  bool _showRefreshBadge = false; // brief visual feedback

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(homeViewModelProvider.notifier).loadActivities(),
    );
    _startProximitySensor();
  }

  // ── Listen to proximity events ──
  void _startProximitySensor() {
    try {
      _proximitySub = ProximitySensor.events.listen((int event) {
        // event > 0 means NEAR
        if (event > 0 && !_isRefreshing) {
          _proximityRefresh();
        }
      });
    } catch (e) {
      debugPrint('Proximity sensor not available: $e');
    }
  }

  // ── Refresh triggered by proximity ──
  Future<void> _proximityRefresh() async {
    _isRefreshing = true;

    // Light haptic + show badge
    await HapticFeedback.lightImpact();
    if (mounted) setState(() => _showRefreshBadge = true);

    // Load fresh data
    await ref.read(homeViewModelProvider.notifier).loadActivities();

    if (mounted) {
      setState(() => _showRefreshBadge = false);
    }

    // Cooldown — prevent re-trigger for 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    _isRefreshing = false;
  }

  @override
  void dispose() {
    _proximitySub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: Stack(
        children: [
          RefreshIndicator(
            color: const Color(0xFF2A9D7A),
            onRefresh: () =>
                ref.read(homeViewModelProvider.notifier).loadActivities(),
            child: CustomScrollView(
              slivers: [
                _buildAppBar(),
                if (state.status == HomeStatus.loading)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF2A9D7A),
                      ),
                    ),
                  )
                else if (state.status == HomeStatus.failure)
                  SliverFillRemaining(child: _buildError(state.errorMessage))
                else if (state.activities.isEmpty)
                  const SliverFillRemaining(child: _EmptyState())
                else
                  _buildContent(state),
              ],
            ),
          ),

          // ── Proximity refresh badge — top center toast ──
          if (_showRefreshBadge)
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedOpacity(
                  opacity: _showRefreshBadge ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A9D7A),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2A9D7A).withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Refreshing...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      snap: true,
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFEAEEF4)),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 52, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Good morning 👋',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF9DAAB8),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Patient Overview',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E2A38),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  // ── Proximity sensor indicator ──
                  Tooltip(
                    message: 'Bring phone close to refresh',
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2A9D7A), Color(0xFF1E7D61)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.sensors_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(HomeState state) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(delegate: SliverChildListDelegate(_buildItems(state))),
    );
  }

  List<Widget> _buildItems(HomeState state) {
    return [
      _SummaryRow(state: state),
      const SizedBox(height: 16),
      VitalsLineChart(activities: state.lastSevenDays),
      const SizedBox(height: 16),
      ActivityStatusChart(
        completed: state.completedCount,
        pending: state.pendingCount,
        cancelled: state.cancelledCount,
      ),
      const SizedBox(height: 16),
      DailyCareSummary(activities: state.activities),
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Recent Activities',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2A38),
            ),
          ),
          Text(
            '${state.activities.length} total',
            style: const TextStyle(fontSize: 12, color: Color(0xFF9DAAB8)),
          ),
        ],
      ),
      const SizedBox(height: 12),
      ...state.sorted.map((a) => ActivityCard(activity: a)),
      const SizedBox(height: 20),
    ];
  }

  Widget _buildError(String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: Color(0xFFE07070),
          ),
          const SizedBox(height: 12),
          Text(
            message ?? 'Something went wrong',
            style: const TextStyle(color: Color(0xFF6B7A8D)),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A9D7A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () =>
                ref.read(homeViewModelProvider.notifier).loadActivities(),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ── Summary stats row ──
class _SummaryRow extends StatelessWidget {
  final HomeState state;
  const _SummaryRow({required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
          label: 'Completed',
          value: state.completedCount.toString(),
          color: const Color(0xFF2A9D7A),
          icon: Icons.check_circle_outline_rounded,
        ),
        const SizedBox(width: 10),
        _StatCard(
          label: 'Pending',
          value: state.pendingCount.toString(),
          color: const Color(0xFFE09C3E),
          icon: Icons.schedule_rounded,
        ),
        const SizedBox(width: 10),
        _StatCard(
          label: 'Total',
          value: state.activities.length.toString(),
          color: const Color(0xFF5BA4CF),
          icon: Icons.list_alt_rounded,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF9DAAB8)),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9F5),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.assignment_outlined,
              size: 38,
              color: Color(0xFF2A9D7A),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No activities yet',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Activities submitted will appear here.',
            style: TextStyle(fontSize: 13, color: Color(0xFF9DAAB8)),
          ),
        ],
      ),
    );
  }
}
