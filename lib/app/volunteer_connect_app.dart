import 'package:flutter/material.dart';
import 'app_theme.dart';
import '../screens/activities/activities_screen.dart';
import '../screens/discover/discover_screen.dart';
import '../screens/impact/impact_screen.dart';
import '../screens/saved/saved_screen.dart';
import '../state/app_state.dart';

class GoodNeighborApp extends StatelessWidget {
  const GoodNeighborApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoodNeighbor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const VolunteerMainShell(),
    );
  }
}

class VolunteerMainShell extends StatelessWidget {
  const VolunteerMainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);

    const screens = [
      DiscoverScreen(),
      SavedScreen(),
      ActivitiesScreen(),
      ImpactScreen(),
    ];

    final savedCount = appState.savedOpportunityIds.length;
    final joinedCount = appState.joinedOpportunityIds.length;

    return Scaffold(
      body: IndexedStack(
        index: appState.selectedTabIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppTheme.border, width: 1),
          ),
        ),
        child: NavigationBar(
          selectedIndex: appState.selectedTabIndex,
          onDestinationSelected: (index) => appState.setTabIndex(index),
          backgroundColor: AppTheme.surface,
          indicatorColor: AppTheme.primaryContainer,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore, color: AppTheme.primary),
              label: 'Discover',
            ),
            NavigationDestination(
              icon: savedCount > 0
                  ? Badge(
                      label: Text('$savedCount'),
                      backgroundColor: AppTheme.accent,
                      textColor: AppTheme.primaryDark,
                      child: const Icon(Icons.bookmark_outline),
                    )
                  : const Icon(Icons.bookmark_outline),
              selectedIcon: savedCount > 0
                  ? Badge(
                      label: Text('$savedCount'),
                      backgroundColor: AppTheme.accent,
                      textColor: AppTheme.primaryDark,
                      child: const Icon(Icons.bookmark, color: AppTheme.primary),
                    )
                  : const Icon(Icons.bookmark, color: AppTheme.primary),
              label: 'Saved',
            ),
            NavigationDestination(
              icon: joinedCount > 0
                  ? Badge(
                      label: Text('$joinedCount'),
                      backgroundColor: AppTheme.primary,
                      textColor: AppTheme.background,
                      child: const Icon(Icons.event_note_outlined),
                    )
                  : const Icon(Icons.event_note_outlined),
              selectedIcon: joinedCount > 0
                  ? Badge(
                      label: Text('$joinedCount'),
                      backgroundColor: AppTheme.primary,
                      textColor: AppTheme.background,
                      child: const Icon(Icons.event_note, color: AppTheme.primary),
                    )
                  : const Icon(Icons.event_note, color: AppTheme.primary),
              label: 'Activities',
            ),
            const NavigationDestination(
              icon: Icon(Icons.insights_outlined),
              selectedIcon: Icon(Icons.insights, color: AppTheme.primary),
              label: 'Impact',
            ),
          ],
        ),
      ),
    );
  }
}

