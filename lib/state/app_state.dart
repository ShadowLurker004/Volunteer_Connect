import 'package:flutter/material.dart';
import '../data/demo_opportunities.dart';
import '../models/opportunity.dart';
import '../models/volunteer_preferences.dart';

enum JoinResult {
  success,
  alreadyJoined,
  full,
  unavailable,
  notFound,
}

class AppState extends ChangeNotifier {
  int _currentTabIndex = 0;
  final List<Opportunity> _opportunities;
  final Set<String> _savedOpportunityIds;
  final Set<String> _joinedOpportunityIds;
  final List<CompletedActivity> _completedActivities;
  VolunteerPreferences _preferences;
  String _searchQuery = '';
  String? _selectedCauseFilter;

  AppState({
    List<Opportunity>? initialOpportunities,
    Set<String>? initialSavedIds,
    Set<String>? initialJoinedIds,
    List<CompletedActivity>? initialCompletedActivities,
    VolunteerPreferences? initialPreferences,
  })  : _opportunities = initialOpportunities != null
            ? List.from(initialOpportunities)
            : List.from(DemoData.opportunities),
        _savedOpportunityIds = initialSavedIds != null
            ? Set.from(initialSavedIds)
            : {'opp-02'},
        _joinedOpportunityIds = initialJoinedIds != null
            ? Set.from(initialJoinedIds)
            : {'opp-01'},
        _completedActivities = initialCompletedActivities != null
            ? List.from(initialCompletedActivities)
            : List.from(DemoData.initialCompletedActivities),
        _preferences = initialPreferences ?? const VolunteerPreferences();

  int get currentTabIndex => _currentTabIndex;
  List<Opportunity> get opportunities => List.unmodifiable(_opportunities);
  Set<String> get savedOpportunityIds => Set.unmodifiable(_savedOpportunityIds);
  Set<String> get joinedOpportunityIds => Set.unmodifiable(_joinedOpportunityIds);
  List<CompletedActivity> get completedActivities =>
      List.unmodifiable(_completedActivities);
  VolunteerPreferences get preferences => _preferences;
  String get searchQuery => _searchQuery;
  String? get selectedCauseFilter => _selectedCauseFilter;

  List<Opportunity> get savedOpportunities {
    return _opportunities
        .where((opp) => _savedOpportunityIds.contains(opp.id))
        .toList();
  }

  List<Opportunity> get joinedOpportunities {
    return _opportunities
        .where((opp) => _joinedOpportunityIds.contains(opp.id))
        .toList();
  }

  Opportunity? get featuredOpportunity {
    try {
      return _opportunities.firstWhere((opp) => opp.isFeatured);
    } catch (_) {
      return _opportunities.isNotEmpty ? _opportunities.first : null;
    }
  }

  List<Opportunity> get filteredOpportunities {
    final query = _searchQuery.trim().toLowerCase();
    final tokens = query.isEmpty ? <String>[] : query.split(RegExp(r'\s+'));

    return _opportunities.where((opp) {
      if (_selectedCauseFilter != null &&
          _selectedCauseFilter != 'All' &&
          _selectedCauseFilter!.trim().isNotEmpty) {
        if (opp.cause.toLowerCase() != _selectedCauseFilter!.toLowerCase().trim()) {
          return false;
        }
      }

      if (tokens.isNotEmpty) {
        final title = opp.title.toLowerCase();
        final org = opp.organization.toLowerCase();
        final desc = opp.description.toLowerCase();
        final cause = opp.cause.toLowerCase();
        final loc = opp.locationLabel.toLowerCase();
        final skills = opp.requiredSkills.map((s) => s.toLowerCase()).join(' ');

        final searchable = '$title $org $desc $cause $loc $skills';
        for (final token in tokens) {
          if (!searchable.contains(token)) {
            return false;
          }
        }
      }

      return true;
    }).toList();
  }

  double get totalCompletedHours {
    return _completedActivities.fold<double>(
      0.0,
      (sum, item) => sum + item.hours,
    );
  }

  bool isSaved(String id) => _savedOpportunityIds.contains(id);
  bool isJoined(String id) => _joinedOpportunityIds.contains(id);

  Opportunity? findOpportunityById(String id) {
    try {
      return _opportunities.firstWhere((opp) => opp.id == id);
    } catch (_) {
      return null;
    }
  }

  int get selectedTabIndex => _currentTabIndex;
  String get selectedCategory => _selectedCauseFilter ?? 'All';

  Opportunity? getOpportunityById(String id) => findOpportunityById(id);

  void setSelectedCategory(String? category) => setCauseFilter(category);
  void toggleSaveOpportunity(String id) => toggleSave(id);

  void setTabIndex(int index) {
    if (_currentTabIndex != index) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCauseFilter(String? cause) {
    if (cause == null || cause == 'All' || cause.trim().isEmpty) {
      _selectedCauseFilter = null;
    } else {
      _selectedCauseFilter = cause.trim();
    }
    notifyListeners();
  }

  bool saveOpportunity(String id) {
    if (findOpportunityById(id) == null) return false;
    final added = _savedOpportunityIds.add(id);
    if (added) {
      notifyListeners();
    }
    return true;
  }

  bool unsaveOpportunity(String id) {
    final removed = _savedOpportunityIds.remove(id);
    if (removed) {
      notifyListeners();
      return true;
    }
    return false;
  }

  void toggleSave(String id) {
    if (_savedOpportunityIds.contains(id)) {
      unsaveOpportunity(id);
    } else {
      saveOpportunity(id);
    }
  }

  JoinResult tryJoinOpportunity(String id) {
    final index = _opportunities.indexWhere((opp) => opp.id == id);
    if (index == -1) {
      return JoinResult.notFound;
    }

    final opp = _opportunities[index];

    if (_joinedOpportunityIds.contains(id)) {
      return JoinResult.alreadyJoined;
    }

    if (!opp.isAvailable) {
      return JoinResult.unavailable;
    }

    if (opp.isFull || opp.currentParticipants >= opp.totalCapacity) {
      return JoinResult.full;
    }

    _joinedOpportunityIds.add(id);
    _opportunities[index] = opp.copyWith(
      currentParticipants: (opp.currentParticipants + 1).clamp(0, opp.totalCapacity),
    );
    notifyListeners();
    return JoinResult.success;
  }

  bool joinOpportunity(String id) {
    return tryJoinOpportunity(id) == JoinResult.success;
  }

  bool leaveOpportunity(String id) {
    final index = _opportunities.indexWhere((opp) => opp.id == id);
    if (!_joinedOpportunityIds.contains(id)) {
      return false;
    }

    _joinedOpportunityIds.remove(id);

    if (index != -1) {
      final opp = _opportunities[index];
      _opportunities[index] = opp.copyWith(
        currentParticipants: (opp.currentParticipants - 1).clamp(0, opp.totalCapacity),
      );
    }
    notifyListeners();
    return true;
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedCauseFilter = null;
    notifyListeners();
  }

  void updatePreferences(VolunteerPreferences prefs) {
    _preferences = prefs;
    notifyListeners();
  }

  void toggleCause(String cause) {
    final current = Set<String>.from(_preferences.selectedCauses);
    if (current.contains(cause)) {
      current.remove(cause);
    } else {
      current.add(cause);
    }
    _preferences = _preferences.copyWith(selectedCauses: current);
    notifyListeners();
  }

  void toggleSkill(String skill) {
    final current = Set<String>.from(_preferences.selectedSkills);
    if (current.contains(skill)) {
      current.remove(skill);
    } else {
      current.add(skill);
    }
    _preferences = _preferences.copyWith(selectedSkills: current);
    notifyListeners();
  }

  void toggleDay(String day) {
    final current = Set<String>.from(_preferences.selectedDays);
    if (current.contains(day)) {
      current.remove(day);
    } else {
      current.add(day);
    }
    _preferences = _preferences.copyWith(selectedDays: current);
    notifyListeners();
  }

  void updateLocation(String location) {
    _preferences = _preferences.copyWith(preferredLocation: location);
    notifyListeners();
  }

  static AppState of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_AppStateInheritedNotifier>();
    assert(scope != null, 'No AppStateScope found in context');
    return scope!.notifier!;
  }
}

class AppStateScope extends StatefulWidget {
  final AppState? notifier;
  final Widget child;

  const AppStateScope({
    super.key,
    this.notifier,
    required this.child,
  });

  @override
  State<AppStateScope> createState() => _AppStateScopeState();
}

class _AppStateScopeState extends State<AppStateScope> {
  late AppState _notifier;
  bool _createdInternally = false;

  @override
  void initState() {
    super.initState();
    if (widget.notifier != null) {
      _notifier = widget.notifier!;
    } else {
      _notifier = AppState();
      _createdInternally = true;
    }
  }

  @override
  void dispose() {
    if (_createdInternally) {
      _notifier.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AppStateInheritedNotifier(
      notifier: _notifier,
      child: widget.child,
    );
  }
}

class _AppStateInheritedNotifier extends InheritedNotifier<AppState> {
  const _AppStateInheritedNotifier({
    required AppState super.notifier,
    required super.child,
  });
}
