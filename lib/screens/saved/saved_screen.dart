import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../state/app_state.dart';
import '../../widgets/opportunity_card.dart';
import '../../widgets/section_header.dart';
import '../opportunity_detail/opportunity_detail_screen.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final savedOpps = appState.savedOpportunities;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Opportunities'),
      ),
      body: savedOpps.isEmpty
          ? _buildEmptyState(context, appState)
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SectionHeader(
                  title: 'Bookmarked for Later',
                  subtitle: 'Opportunities you have flagged for your schedule',
                  badgeText: '${savedOpps.length}',
                ),
                ...savedOpps.map(
                  (opp) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: OpportunityCard(
                      opportunity: opp,
                      isSaved: true,
                      isJoined: appState.isJoined(opp.id),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => OpportunityDetailScreen(
                              opportunityId: opp.id,
                            ),
                          ),
                        );
                      },
                      onSaveToggle: () => appState.toggleSave(opp.id),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppState appState) {
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
              child: const Icon(
                Icons.bookmark_border_rounded,
                size: 32,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No Saved Opportunities Yet',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Browse upcoming volunteer sessions and bookmark activities you want to revisit or join later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                height: 1.45,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => appState.setTabIndex(0),
              child: const Text('Discover Opportunities'),
            ),
          ],
        ),
      ),
    );
  }
}
