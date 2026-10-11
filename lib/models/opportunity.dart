class Opportunity {
  final String id;
  final String title;
  final String organization;
  final String description;
  final String cause;
  final String locationLabel;
  final DateTime date;
  final String dateLabel;
  final String timeLabel;
  final double durationHours;
  final List<String> requiredSkills;
  final int totalCapacity;
  final int currentParticipants;
  final bool isFeatured;
  final String? urgency;
  final String impactStatement;
  final bool isAvailable;

  const Opportunity({
    required this.id,
    required this.title,
    required this.organization,
    required this.description,
    required this.cause,
    required this.locationLabel,
    required this.date,
    required this.dateLabel,
    required this.timeLabel,
    required this.durationHours,
    required this.requiredSkills,
    required this.totalCapacity,
    this.currentParticipants = 0,
    this.isFeatured = false,
    this.urgency,
    required this.impactStatement,
    this.isAvailable = true,
  });

  int get spotsRemaining => (totalCapacity - currentParticipants).clamp(0, totalCapacity);
  bool get isFull => spotsRemaining <= 0;
  bool get canJoin => isAvailable && !isFull;

  Opportunity copyWith({
    String? id,
    String? title,
    String? organization,
    String? description,
    String? cause,
    String? locationLabel,
    DateTime? date,
    String? dateLabel,
    String? timeLabel,
    double? durationHours,
    List<String>? requiredSkills,
    int? totalCapacity,
    int? currentParticipants,
    bool? isFeatured,
    String? urgency,
    String? impactStatement,
    bool? isAvailable,
  }) {
    return Opportunity(
      id: id ?? this.id,
      title: title ?? this.title,
      organization: organization ?? this.organization,
      description: description ?? this.description,
      cause: cause ?? this.cause,
      locationLabel: locationLabel ?? this.locationLabel,
      date: date ?? this.date,
      dateLabel: dateLabel ?? this.dateLabel,
      timeLabel: timeLabel ?? this.timeLabel,
      durationHours: durationHours ?? this.durationHours,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      totalCapacity: totalCapacity ?? this.totalCapacity,
      currentParticipants: currentParticipants ?? this.currentParticipants,
      isFeatured: isFeatured ?? this.isFeatured,
      urgency: urgency ?? this.urgency,
      impactStatement: impactStatement ?? this.impactStatement,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

