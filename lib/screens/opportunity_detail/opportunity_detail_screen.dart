import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../models/opportunity.dart';
import '../../state/app_state.dart';

class OpportunityDetailScreen extends StatelessWidget {
  final String opportunityId;

  const OpportunityDetailScreen({
    super.key,
    required this.opportunityId,
  });

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final opp = appState.findOpportunityById(opportunityId);

    if (opp == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Opportunity Details')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Opportunity Not Found',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'The requested opportunity could not be found or may have been removed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final isSaved = appState.isSaved(opp.id);
    final isJoined = appState.isJoined(opp.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Opportunity Details'),
        actions: [
          IconButton(
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: isSaved ? AppTheme.primary : AppTheme.textPrimary,
            ),
            tooltip: isSaved ? 'Remove bookmark' : 'Bookmark opportunity',
            onPressed: () {
              appState.toggleSave(opp.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isSaved ? 'Removed from saved' : 'Saved to your bookmarks',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context, appState, opp, isJoined),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(opp),
            const SizedBox(height: 18),
            _buildMetaInfoCard(opp),
            const SizedBox(height: 20),
            _buildAboutSection(opp),
            const SizedBox(height: 20),
            _buildImpactSection(opp),
            const SizedBox(height: 20),
            _buildSkillsSection(opp),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(Opportunity opp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                opp.cause.toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: AppTheme.primary,
                ),
              ),
            ),
            if (opp.urgency != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  opp.urgency!,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryDark,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        Text(
          opp.title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.verified_outlined, size: 16, color: AppTheme.primary),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                opp.organization,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetaInfoCard(Opportunity opp) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 18, color: AppTheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${opp.dateLabel} • ${opp.timeLabel}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppTheme.border, height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.timelapse_outlined, size: 18, color: AppTheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${opp.durationHours} Hours Duration',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppTheme.border, height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 18, color: AppTheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  opp.locationLabel,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppTheme.border, height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.people_outline, size: 18, color: AppTheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${opp.currentParticipants} of ${opp.totalCapacity} volunteers joined (${opp.spotsRemaining} spots open)',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildAboutSection(Opportunity opp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About This Activity',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          opp.description,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            height: 1.5,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildImpactSection(Opportunity opp) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.accentLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.volunteer_activism_outlined, size: 20, color: AppTheme.primaryDark),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Community Impact',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  opp.impactStatement,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    height: 1.4,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection(Opportunity opp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Required Skills & Preparedness',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: opp.requiredSkills.map((skill) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check, size: 14, color: AppTheme.primary),
                  const SizedBox(width: 6),
                  Text(
                    skill,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, AppState appState, Opportunity opp, bool isJoined) {
    final String buttonText;
    final Color backgroundColor;
    final Color foregroundColor;
    final BorderSide? borderSide;

    if (isJoined) {
      buttonText = 'Joined ✓ (Tap to Cancel)';
      backgroundColor = AppTheme.surface;
      foregroundColor = AppTheme.primary;
      borderSide = const BorderSide(color: AppTheme.primary);
    } else if (!opp.isAvailable) {
      buttonText = 'Activity Closed / Unavailable';
      backgroundColor = const Color(0xFF9E9E9E);
      foregroundColor = Colors.white;
      borderSide = null;
    } else if (opp.isFull) {
      buttonText = 'Capacity Full';
      backgroundColor = const Color(0xFF9E9E9E);
      foregroundColor = Colors.white;
      borderSide = null;
    } else {
      buttonText = 'Join Opportunity • ${opp.durationHours}h';
      backgroundColor = AppTheme.primary;
      foregroundColor = Colors.white;
      borderSide = null;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (isJoined) {
                    appState.leaveOpportunity(opp.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Registration cancelled for this opportunity.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    final result = appState.tryJoinOpportunity(opp.id);
                    final String message;
                    switch (result) {
                      case JoinResult.success:
                        message = 'Successfully joined! Added to My Activities.';
                        break;
                      case JoinResult.alreadyJoined:
                        message = 'You have already joined this opportunity.';
                        break;
                      case JoinResult.full:
                        message = 'This opportunity is currently full.';
                        break;
                      case JoinResult.unavailable:
                        message = 'This opportunity is closed or no longer available.';
                        break;
                      case JoinResult.notFound:
                        message = 'Opportunity not found.';
                        break;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor,
                  foregroundColor: foregroundColor,
                  side: borderSide,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
