import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../models/opportunity.dart';
import '../../models/volunteer_preferences.dart';
import '../../state/app_state.dart';
import '../../widgets/section_header.dart';
import '../opportunity_detail/opportunity_detail_screen.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final joined = appState.joinedOpportunities;
    final completed = appState.completedActivities;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Activities'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorColor: AppTheme.primary,
          indicatorWeight: 2.5,
          tabs: [
            Tab(text: 'Upcoming (${joined.length})'),
            Tab(text: 'Completed (${completed.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUpcomingTab(context, appState, joined),
          _buildCompletedTab(context, completed),
        ],
      ),
    );
  }

  Widget _buildUpcomingTab(BuildContext context, AppState appState, List<Opportunity> joined) {
    if (joined.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.event_available_outlined, size: 32, color: AppTheme.primary),
              ),
              const SizedBox(height: 16),
              const Text(
                'No Upcoming Activities',
                style: TextStyle(fontFamily: 'Inter', fontSize: 17, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 8),
              const Text(
                "You haven't registered for any volunteer activities yet. Find a session in Discover to get started.",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => appState.setTabIndex(0),
                child: const Text('Browse Opportunities'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionHeader(
          title: 'Registered Sessions',
          subtitle: 'Check in with organizers when you arrive on site',
          badgeText: '${joined.length}',
        ),
        ...joined.map(
          (opp) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildUpcomingCard(context, appState, opp),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingCard(BuildContext context, AppState appState, Opportunity opp) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  opp.cause,
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.primary),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.accentLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'CONFIRMED',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.primaryDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            opp.title,
            style: const TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(opp.organization, style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppTheme.textSecondary)),
          const SizedBox(height: 12),
          const Divider(color: AppTheme.border, height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 14, color: AppTheme.primary),
              const SizedBox(width: 6),
              Text(
                '${opp.dateLabel} • ${opp.timeLabel}',
                style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(opp.locationLabel, style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppTheme.textSecondary)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => OpportunityDetailScreen(opportunityId: opp.id)),
                  );
                },
                child: const Text('View Details'),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  appState.leaveOpportunity(opp.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Registration cancelled for this opportunity.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedTab(BuildContext context, List<CompletedActivity> completed) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceMuted,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: AppTheme.textSecondary),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Demonstration history records. In Stage 2, user check-ins and hours verification will sync here.',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppTheme.textSecondary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionHeader(
          title: 'Past Completed Sessions',
          badgeText: '${completed.length}',
        ),
        ...completed.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildCompletedCard(item),
            )),
      ],
    );
  }

  Widget _buildCompletedCard(CompletedActivity item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.cause,
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.primary),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified, size: 12, color: Color(0xFF2E7D32)),
                    const SizedBox(width: 4),
                    Text(
                      '${item.hours}h Credited',
                      style: const TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF2E7D32)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item.title,
            style: const TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 3),
          Text(
            item.organization,
            style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Completed on ${item.completedDateLabel} • ${item.notes}',
            style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}
