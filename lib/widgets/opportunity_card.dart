import 'package:flutter/material.dart';
import '../app/app_theme.dart';
import '../models/opportunity.dart';

class OpportunityCard extends StatelessWidget {
  final Opportunity opportunity;
  final bool isSaved;
  final bool isJoined;
  final VoidCallback onTap;
  final VoidCallback onSaveToggle;

  const OpportunityCard({
    super.key,
    required this.opportunity,
    required this.isSaved,
    required this.isJoined,
    required this.onTap,
    required this.onSaveToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isJoined ? AppTheme.primaryLight : AppTheme.border,
              width: isJoined ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 10),
              _buildContent(),
              const SizedBox(height: 10),
              const Divider(color: AppTheme.border, height: 1),
              const SizedBox(height: 10),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppTheme.primaryContainer,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            opportunity.cause,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
            ),
          ),
        ),
        if (opportunity.urgency != null) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.accentLight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              opportunity.urgency!,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryDark,
              ),
            ),
          ),
        ],
        const Spacer(),
        if (isJoined) ...[
          const Text(
            'Joined ✓',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(width: 4),
        ],
        IconButton(
          tooltip: isSaved ? 'Remove bookmark' : 'Bookmark opportunity',
          icon: Icon(
            isSaved ? Icons.bookmark : Icons.bookmark_border,
            color: isSaved ? AppTheme.primary : AppTheme.textSecondary,
            size: 20,
          ),
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.all(4),
          onPressed: onSaveToggle,
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          opportunity.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          opportunity.organization,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_today_outlined, size: 13, color: AppTheme.textSecondary),
            const SizedBox(width: 5),
            Text(
              opportunity.dateLabel,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.schedule_outlined, size: 13, color: AppTheme.textSecondary),
            const SizedBox(width: 4),
            Text('${opportunity.durationHours}h', style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppTheme.textSecondary)),
            const Spacer(),
            Text(
              !opportunity.isAvailable
                  ? 'Closed'
                  : (opportunity.isFull
                      ? 'Full'
                      : '${opportunity.spotsRemaining} spots left'),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: (!opportunity.isAvailable || opportunity.isFull)
                    ? const Color(0xFFC62828)
                    : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.location_on_outlined, size: 13, color: AppTheme.textSecondary),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                opportunity.locationLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppTheme.textSecondary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
