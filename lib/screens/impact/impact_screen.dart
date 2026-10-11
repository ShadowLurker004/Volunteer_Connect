import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../models/volunteer_preferences.dart';
import '../../state/app_state.dart';
import '../../widgets/section_header.dart';
import '../../widgets/stat_card.dart';

class ImpactScreen extends StatelessWidget {
  const ImpactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final totalHours = appState.totalCompletedHours;
    final completed = appState.completedActivities;
    final joined = appState.joinedOpportunities;

    final causesSupported = completed.map((e) => e.cause).toSet().length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Impact & Service Hours'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNoticeBanner(),
          const SizedBox(height: 16),
          _buildStatsGrid(totalHours, completed.length, causesSupported, joined.length),
          const SizedBox(height: 24),
          _buildCauseBreakdown(completed),
          const SizedBox(height: 24),
          _buildMilestones(totalHours, causesSupported),
          const SizedBox(height: 24),
          _buildRecentLog(completed),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildNoticeBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.accentLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.5)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, size: 18, color: AppTheme.primaryDark),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Sample impact metrics are demonstrated from verified local activity seeds.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(double totalHours, int completedCount, int causesCount, int upcomingCount) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.35,
      children: [
        StatCard(
          value: '${totalHours.toStringAsFixed(1)}h',
          label: 'Total Hours Served',
          icon: Icons.timer_outlined,
          caption: 'VERIFIED',
        ),
        StatCard(
          value: '$completedCount',
          label: 'Sessions Completed',
          icon: Icons.task_alt_outlined,
        ),
        StatCard(
          value: '$causesCount',
          label: 'Causes Supported',
          icon: Icons.favorite_border_rounded,
        ),
        StatCard(
          value: '$upcomingCount',
          label: 'Upcoming Registered',
          icon: Icons.schedule_outlined,
        ),
      ],
    );
  }
  Widget _buildCauseBreakdown(List<CompletedActivity> completed) {
    final Map<String, double> causeHours = {};
    for (final c in completed) {
      causeHours[c.cause] = (causeHours[c.cause] ?? 0.0) + c.hours;
    }
    final total = causeHours.values.fold<double>(0.0, (sum, val) => sum + val);

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
          const SectionHeader(
            title: 'Contribution by Cause',
            subtitle: 'Hours logged across local community sectors',
          ),
          ...causeHours.entries.map((entry) {
            final percentage = total > 0 ? (entry.value / total) : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        '${entry.value.toStringAsFixed(1)} hrs (${(percentage * 100).toInt()}%)',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: percentage,
                      minHeight: 7,
                      backgroundColor: AppTheme.background,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMilestones(double totalHours, int causesSupported) {
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
          const SectionHeader(
            title: 'Volunteer Recognition',
            subtitle: 'Milestones earned through dedicated community service',
          ),
          Row(
            children: [
              Expanded(
                child: _buildBadge(
                  icon: Icons.workspace_premium,
                  title: '10+ Hours',
                  isEarned: totalHours >= 10.0,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildBadge(
                  icon: Icons.public,
                  title: '3+ Causes',
                  isEarned: causesSupported >= 3,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildBadge(
                  icon: Icons.star_border,
                  title: '25+ Hours',
                  isEarned: totalHours >= 25.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildBadge({
    required IconData icon,
    required String title,
    required bool isEarned,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isEarned ? AppTheme.primaryContainer : AppTheme.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEarned ? AppTheme.primaryLight : AppTheme.border,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 22,
            color: isEarned ? AppTheme.primary : AppTheme.textTertiary,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isEarned ? AppTheme.primaryDark : AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentLog(List<CompletedActivity> completed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Verified Activity Log',
          subtitle: 'Detailed record of completed volunteer assignments',
        ),
        ...completed.map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(Icons.check, size: 18, color: AppTheme.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${item.organization} • ${item.completedDateLabel}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '+${item.hours}h',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.statusSuccess,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
