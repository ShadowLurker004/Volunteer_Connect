import '../models/opportunity.dart';
import '../models/volunteer_preferences.dart';

class DemoData {
  DemoData._();

  static List<Opportunity> get opportunities => [
    Opportunity(
      id: 'opp-01',
      title: 'Community Garden Bed Prep & Planting',
      organization: 'Urban Greening Project',
      description:
          'Help prepare raised soil beds, weed native plant areas, and plant autumn vegetables for local food distribution. Gloves and tools provided.',
      cause: 'Environment',
      locationLabel: 'Oakridge Community Garden, North Ward',
      date: DateTime(2026, 10, 18, 9, 0),
      dateLabel: 'Sat, Oct 18, 2026',
      timeLabel: '9:00 AM – 1:00 PM',
      durationHours: 4.0,
      requiredSkills: ['Gardening & Green Care', 'Physical Labor'],
      totalCapacity: 12,
      currentParticipants: 8,
      isFeatured: true,
      urgency: 'This Saturday',
      impactStatement:
          'Produces over 350 kg of organic seasonal produce for community food initiatives.',
    ),
    Opportunity(
      id: 'opp-02',
      title: 'Weekend Food Box Packing & Sorting',
      organization: 'Harbor Community Food Hub',
      description:
          'Sort pantry donations, check dates, and pack weekend grocery parcels for over 80 neighbourhood families experiencing food insecurity.',
      cause: 'Food Security',
      locationLabel: 'Harbor Warehouse, Bay St & 4th Ave',
      date: DateTime(2026, 10, 19, 10, 0),
      dateLabel: 'Sun, Oct 19, 2026',
      timeLabel: '10:00 AM – 1:30 PM',
      durationHours: 3.5,
      requiredSkills: ['Food Prep & Packaging', 'Teamwork'],
      totalCapacity: 15,
      currentParticipants: 11,
      isFeatured: false,
      urgency: 'High Need',
      impactStatement:
          'Directly feeds vulnerable families across Metro Central each weekend.',
    ),
    Opportunity(
      id: 'opp-03',
      title: 'Youth Coding & Robotics Workshop Mentor',
      organization: 'Bright Horizons Mentorship',
      description:
          'Assist middle school learners with hands-on introductory coding exercises and sensor kits. No advanced programming required; patience is key!',
      cause: 'Education',
      locationLabel: 'Central Public Library, Tech Lab',
      date: DateTime(2026, 10, 21, 16, 0),
      dateLabel: 'Tue, Oct 21, 2026',
      timeLabel: '4:00 PM – 6:30 PM',
      durationHours: 2.5,
      requiredSkills: ['Teaching & Tutoring', 'Tech & Digital'],
      totalCapacity: 8,
      currentParticipants: 5,
      isFeatured: false,
      urgency: '3 Spots Left',
      impactStatement:
          'Sparks STEM curiosity and digital literacy in public school students.',
    ),
    Opportunity(
      id: 'opp-04',
      title: 'Riverside Creek Trail Clean-Up',
      organization: 'Friends of Blue River',
      description:
          'Collect plastic debris along riparian zones, clear brush from walking paths, and log wildlife sightings with our conservation leads.',
      cause: 'Environment',
      locationLabel: 'Blue River Park, North Footbridge',
      date: DateTime(2026, 10, 24, 8, 30),
      dateLabel: 'Fri, Oct 24, 2026',
      timeLabel: '8:30 AM – 11:30 AM',
      durationHours: 3.0,
      requiredSkills: ['Physical Labor', 'Outdoor Stamina'],
      totalCapacity: 20,
      currentParticipants: 14,
      isFeatured: false,
      urgency: 'Morning Session',
      impactStatement:
          'Restores 2 km of essential urban river habitat and protects aquatic species.',
    ),
    Opportunity(
      id: 'opp-05',
      title: 'Senior Digital Literacy & Tech Support',
      organization: 'Evergreen Community Center',
      description:
          'Provide patient 1-on-1 assistance to older adults learning smartphone basics, video calls with family, and digital accessibility features.',
      cause: 'Community',
      locationLabel: 'Evergreen Center, Room 104',
      date: DateTime(2026, 10, 22, 14, 0),
      dateLabel: 'Wed, Oct 22, 2026',
      timeLabel: '2:00 PM – 4:00 PM',
      durationHours: 2.0,
      requiredSkills: ['Tech & Digital', 'Patience & Listening'],
      totalCapacity: 10,
      currentParticipants: 6,
      isFeatured: false,
      urgency: 'Orientation Provided',
      impactStatement:
          'Reduces digital isolation for local seniors and keeps them connected.',
    ),
  ];

  static List<CompletedActivity> get initialCompletedActivities => [
    const CompletedActivity(
      id: 'comp-01',
      opportunityId: 'opp-legacy-01',
      title: 'Community Food Bank Emergency Sorting',
      organization: 'Harbor Community Food Hub',
      cause: 'Food Security',
      completedDateLabel: 'Oct 3, 2026',
      hours: 4.0,
      isVerified: true,
      notes: 'Sorted 420kg of dry goods and pantry provisions.',
    ),
    const CompletedActivity(
      id: 'comp-02',
      opportunityId: 'opp-legacy-02',
      title: 'Neighbourhood Tree Planting Day',
      organization: 'Urban Greening Project',
      cause: 'Environment',
      completedDateLabel: 'Sep 26, 2026',
      hours: 3.5,
      isVerified: true,
      notes: 'Planted 18 shade saplings along the residential perimeter.',
    ),
    const CompletedActivity(
      id: 'comp-03',
      opportunityId: 'opp-legacy-03',
      title: 'Youth Homework & Reading Circle',
      organization: 'Bright Horizons Mentorship',
      cause: 'Education',
      completedDateLabel: 'Sep 19, 2026',
      hours: 2.5,
      isVerified: true,
      notes: 'Assisted 6 elementary students with foundational literacy.',
    ),
  ];

  static const List<String> causesList = [
    'Environment',
    'Food Security',
    'Education',
    'Community',
    'Animals',
    'Senior Care',
    'Arts & Culture',
    'Community Health',
  ];

  static const List<String> skillsList = [
    'Gardening & Green Care',
    'Food Prep & Packaging',
    'Youth Tutoring & Mentorship',
    'Animal Care & Handling',
    'Friendly Visiting & Companionship',
    'Event Support',
    'Physical Labor',
    'Teamwork',
  ];

  static const List<String> daysList = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
}

typedef DemoOpportunities = DemoData;
