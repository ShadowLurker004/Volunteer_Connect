import 'package:flutter_test/flutter_test.dart';
import 'package:donor_app/models/opportunity.dart';
import 'package:donor_app/models/volunteer_preferences.dart';
import 'package:donor_app/state/app_state.dart';

void main() {
  group('AppState Model and Discovery State Tests', () {
    late AppState appState;

    setUp(() {
      appState = AppState();
    });

    test('1. Search is case-insensitive', () {
      appState.setSearchQuery('gArDeN');
      final lowerResults = appState.filteredOpportunities;
      expect(lowerResults.any((o) => o.id == 'opp-01'), isTrue);

      appState.setSearchQuery('GARDEN');
      final upperResults = appState.filteredOpportunities;
      expect(upperResults.length, equals(lowerResults.length));
      expect(upperResults.first.id, equals(lowerResults.first.id));
    });

    test('2. Search matches relevant opportunity fields', () {
      appState.setSearchQuery('Planting');
      expect(appState.filteredOpportunities.any((o) => o.id == 'opp-01'), isTrue);

      appState.setSearchQuery('Bright Horizons');
      expect(appState.filteredOpportunities.any((o) => o.id == 'opp-03'), isTrue);

      appState.setSearchQuery('autumn vegetables');
      expect(appState.filteredOpportunities.any((o) => o.id == 'opp-01'), isTrue);

      appState.setSearchQuery('Education');
      expect(appState.filteredOpportunities.any((o) => o.id == 'opp-03'), isTrue);

      appState.setSearchQuery('Tech & Digital');
      final skillMatches = appState.filteredOpportunities;
      expect(skillMatches.any((o) => o.id == 'opp-03'), isTrue);
      expect(skillMatches.any((o) => o.id == 'opp-05'), isTrue);

      appState.setSearchQuery('Blue River');
      expect(appState.filteredOpportunities.any((o) => o.id == 'opp-04'), isTrue);
    });

    test('Leading, trailing, and repeated whitespace in search produce expected results', () {
      appState.setSearchQuery('   food     box   ');
      final results = appState.filteredOpportunities;
      expect(results.length, equals(1));
      expect(results.first.id, equals('opp-02'));
    });

    test('3. Clearing search restores the correct filtered results', () {
      appState.setSearchQuery('Food');
      expect(appState.filteredOpportunities.length, equals(1));

      appState.setSearchQuery('');
      expect(appState.filteredOpportunities.length, equals(appState.opportunities.length));

      appState.setCauseFilter('Environment');
      appState.setSearchQuery('Creek');
      expect(appState.filteredOpportunities.length, equals(1));

      appState.setSearchQuery('');
      expect(appState.filteredOpportunities.length, equals(appState.opportunities.where((o) => o.cause == 'Environment').length));
      expect(appState.filteredOpportunities.every((o) => o.cause == 'Environment'), isTrue);
    });

    test('4. Category filtering works including All, unknown, and empty strings', () {
      appState.setCauseFilter('Environment');
      expect(appState.selectedCategory, equals('Environment'));
      expect(appState.filteredOpportunities.every((o) => o.cause == 'Environment'), isTrue);
      expect(appState.filteredOpportunities.length, equals(2));

      appState.setCauseFilter('All');
      expect(appState.selectedCategory, equals('All'));
      expect(appState.filteredOpportunities.length, equals(appState.opportunities.length));

      appState.setCauseFilter('Unknown Category XYZ');
      expect(appState.filteredOpportunities, isEmpty);

      appState.setCauseFilter('');
      expect(appState.selectedCategory, equals('All'));
      expect(appState.filteredOpportunities.length, equals(appState.opportunities.length));
    });

    test('5. Search and category filtering combine correctly', () {
      appState.setCauseFilter('Environment');
      appState.setSearchQuery('River');
      final results = appState.filteredOpportunities;
      expect(results.length, equals(1));
      expect(results.first.id, equals('opp-04'));

      appState.setCauseFilter('Food Security');
      appState.setSearchQuery('River');
      expect(appState.filteredOpportunities, isEmpty);
    });

    test('Toggling saved opportunities adds and removes IDs', () {
      const testId = 'opp-03';
      expect(appState.isSaved(testId), isFalse);

      appState.toggleSaveOpportunity(testId);
      expect(appState.isSaved(testId), isTrue);
      expect(appState.savedOpportunities.any((o) => o.id == testId), isTrue);

      appState.toggleSaveOpportunity(testId);
      expect(appState.isSaved(testId), isFalse);
    });

    test('Joining and leaving opportunities updates spots and joined list', () {
      const testId = 'opp-04';
      final initialSpots = appState.getOpportunityById(testId)?.spotsRemaining ?? 0;
      expect(appState.isJoined(testId), isFalse);

      final success = appState.joinOpportunity(testId);
      expect(success, isTrue);
      expect(appState.isJoined(testId), isTrue);
      expect(appState.getOpportunityById(testId)?.spotsRemaining, equals(initialSpots - 1));

      final leaveSuccess = appState.leaveOpportunity(testId);
      expect(leaveSuccess, isTrue);
      expect(appState.isJoined(testId), isFalse);
      expect(appState.getOpportunityById(testId)?.spotsRemaining, equals(initialSpots));
    });

    test('Total completed hours calculation sums correctly', () {
      final calculated = appState.completedActivities.fold<double>(
        0.0,
        (sum, item) => sum + item.hours,
      );
      expect(appState.totalCompletedHours, equals(calculated));
    });

    test('Updating preferences applies new values', () {
      const newPrefs = VolunteerPreferences(
        causes: {'Animals'},
        skills: {'Animal Care'},
        daysAvailable: {'Weekends'},
        maxDistanceKm: 15.0,
        remoteOnly: false,
      );

      appState.updatePreferences(newPrefs);
      expect(appState.preferences.causes, contains('Animals'));
      expect(appState.preferences.maxDistanceKm, equals(15.0));
    });
  });
}
