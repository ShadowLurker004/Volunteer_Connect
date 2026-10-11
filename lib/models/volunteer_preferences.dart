class VolunteerPreferences {
  final Set<String> selectedCauses;
  final Set<String> selectedSkills;
  final Set<String> selectedDays;
  final String preferredLocation;
  final double maxDistanceKm;
  final bool remoteOnly;

  const VolunteerPreferences({
    Set<String>? causes,
    Set<String>? selectedCauses,
    Set<String>? skills,
    Set<String>? selectedSkills,
    Set<String>? daysAvailable,
    Set<String>? selectedDays,
    this.preferredLocation = 'Metro Central & Surrounding Wards',
    this.maxDistanceKm = 15.0,
    this.remoteOnly = false,
  })  : selectedCauses = causes ?? selectedCauses ?? const {'Environment', 'Community'},
        selectedSkills = skills ?? selectedSkills ?? const {'Event Support', 'Gardening & Green Care'},
        selectedDays = daysAvailable ?? selectedDays ?? const {'Saturday', 'Sunday'};

  factory VolunteerPreferences.initial() => const VolunteerPreferences();

  Set<String> get causes => selectedCauses;
  Set<String> get skills => selectedSkills;
  Set<String> get daysAvailable => selectedDays;

  VolunteerPreferences copyWith({
    Set<String>? causes,
    Set<String>? selectedCauses,
    Set<String>? skills,
    Set<String>? selectedSkills,
    Set<String>? daysAvailable,
    Set<String>? selectedDays,
    String? preferredLocation,
    double? maxDistanceKm,
    bool? remoteOnly,
  }) {
    return VolunteerPreferences(
      selectedCauses: causes ?? selectedCauses ?? this.selectedCauses,
      selectedSkills: skills ?? selectedSkills ?? this.selectedSkills,
      selectedDays: daysAvailable ?? selectedDays ?? this.selectedDays,
      preferredLocation: preferredLocation ?? this.preferredLocation,
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
      remoteOnly: remoteOnly ?? this.remoteOnly,
    );
  }
}

class CompletedActivity {
  final String id;
  final String opportunityId;
  final String title;
  final String organization;
  final String cause;
  final String completedDateLabel;
  final double hours;
  final bool isVerified;
  final String notes;

  const CompletedActivity({
    required this.id,
    required this.opportunityId,
    required this.title,
    required this.organization,
    required this.cause,
    required this.completedDateLabel,
    required this.hours,
    this.isVerified = true,
    this.notes = 'Completed scheduled session and verified by organizer.',
  });
}
