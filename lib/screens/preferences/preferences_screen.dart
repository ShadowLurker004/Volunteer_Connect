import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../data/demo_opportunities.dart';
import '../../models/volunteer_preferences.dart';
import '../../state/app_state.dart';
import '../../widgets/section_header.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final prefs = appState.preferences;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Preferences'),
        actions: [
          TextButton(
            onPressed: () {
              appState.updatePreferences(VolunteerPreferences.initial());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Preferences reset to default')),
              );
            },
            child: const Text('Reset', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoBanner(),
          const SizedBox(height: 16),
          _buildCausesSection(context, appState, prefs),
          const SizedBox(height: 20),
          _buildSkillsSection(context, appState, prefs),
          const SizedBox(height: 20),
          _buildAvailabilitySection(context, appState, prefs),
          const SizedBox(height: 20),
          _buildDistanceSection(context, appState, prefs),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryLight),
      ),
      child: const Row(
        children: [
          Icon(Icons.tune, size: 20, color: AppTheme.primary),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Customize your interests and schedule to get tailored recommendations on your Discover feed.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: AppTheme.primaryDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCausesSection(
    BuildContext context,
    AppState appState,
    VolunteerPreferences prefs,
  ) {
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
            title: 'Preferred Causes',
            subtitle: 'Select topics and missions you are excited to help with',
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: DemoOpportunities.causesList.map((cause) {
              final isSelected = prefs.causes.contains(cause);
              return FilterChip(
                label: Text(cause),
                selected: isSelected,
                selectedColor: AppTheme.primaryContainer,
                checkmarkColor: AppTheme.primary,
                labelStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppTheme.primaryDark : AppTheme.textPrimary,
                ),
                backgroundColor: AppTheme.surfaceMuted,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? AppTheme.primary : AppTheme.border,
                  ),
                ),
                onSelected: (selected) {
                  final newSet = Set<String>.from(prefs.causes);
                  if (selected) {
                    newSet.add(cause);
                  } else {
                    newSet.remove(cause);
                  }
                  appState.updatePreferences(prefs.copyWith(causes: newSet));
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection(
    BuildContext context,
    AppState appState,
    VolunteerPreferences prefs,
  ) {
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
            title: 'Your Skills & Superpowers',
            subtitle: 'Pick areas where you can provide hands-on assistance',
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: DemoOpportunities.skillsList.map((skill) {
              final isSelected = prefs.skills.contains(skill);
              return FilterChip(
                label: Text(skill),
                selected: isSelected,
                selectedColor: AppTheme.primaryContainer,
                checkmarkColor: AppTheme.primary,
                labelStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppTheme.primaryDark : AppTheme.textPrimary,
                ),
                backgroundColor: AppTheme.surfaceMuted,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? AppTheme.primary : AppTheme.border,
                  ),
                ),
                onSelected: (selected) {
                  final newSet = Set<String>.from(prefs.skills);
                  if (selected) {
                    newSet.add(skill);
                  } else {
                    newSet.remove(skill);
                  }
                  appState.updatePreferences(prefs.copyWith(skills: newSet));
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilitySection(
    BuildContext context,
    AppState appState,
    VolunteerPreferences prefs,
  ) {
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
            title: 'Schedule Availability',
            subtitle: 'Days and times when you are free to volunteer',
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: DemoOpportunities.daysList.map((day) {
              final isSelected = prefs.daysAvailable.contains(day);
              return FilterChip(
                label: Text(day),
                selected: isSelected,
                selectedColor: AppTheme.primaryContainer,
                checkmarkColor: AppTheme.primary,
                labelStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppTheme.primaryDark : AppTheme.textPrimary,
                ),
                backgroundColor: AppTheme.surfaceMuted,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? AppTheme.primary : AppTheme.border,
                  ),
                ),
                onSelected: (selected) {
                  final newSet = Set<String>.from(prefs.daysAvailable);
                  if (selected) {
                    newSet.add(day);
                  } else {
                    newSet.remove(day);
                  }
                  appState.updatePreferences(prefs.copyWith(daysAvailable: newSet));
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceSection(
    BuildContext context,
    AppState appState,
    VolunteerPreferences prefs,
  ) {
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
            title: 'Location & Commute',
            subtitle: 'Filter by proximity or remote volunteering opportunities',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Maximum travel radius',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                '${prefs.maxDistanceKm.toInt()} km',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          Slider(
            value: prefs.maxDistanceKm,
            min: 5,
            max: 50,
            divisions: 9,
            activeColor: AppTheme.primary,
            inactiveColor: AppTheme.border,
            onChanged: (val) {
              appState.updatePreferences(prefs.copyWith(maxDistanceKm: val));
            },
          ),
          const Divider(color: AppTheme.border, height: 24),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Remote / Virtual Only',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            subtitle: const Text(
              'Show only opportunities that can be performed from home',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: AppTheme.textSecondary,
              ),
            ),
            value: prefs.remoteOnly,
            activeTrackColor: AppTheme.primary,
            onChanged: (val) {
              appState.updatePreferences(prefs.copyWith(remoteOnly: val));
            },
          ),
        ],
      ),
    );
  }
}
