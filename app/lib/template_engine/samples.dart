import 'binding/binding_context.dart';

/// Sample data for previews, the playground and golden tests (docs/03 §7).
/// Covers the cases templates must survive: full data, long names, missing optional fields.
abstract final class SamplePresets {
  /// [photoUrl] lets callers plug in a real or test image.
  static Map<String, BindingContext> all({String? photoUrl}) => {
    'full': full(photoUrl: photoUrl),
    'long-name': longName,
    'minimal': minimal,
  };

  static BindingContext full({String? photoUrl}) => BindingContext({
    'event': {'personName': 'Aarav', 'age': 5},
    'details': {
      'eventName': "Aarav's 5th Birthday",
      'hostName': 'Riya & Karan',
      'venue': {
        'name': 'Funky Monkeys Play Center',
        'address': '12 MG Road, Bengaluru',
      },
      'date': '2026-12-05',
      'time': '16:30',
      'timezone': 'Asia/Kolkata',
      'description': 'Games, cake and lots of fun!',
      'contactPhone': '+919800000000',
      'rsvp': {
        'enabled': true,
        'phone': '+919800000000',
        'deadline': '2026-12-01',
      },
    },
    'media': {'photoUrl': photoUrl},
  });

  static const longName = BindingContext({
    'event': {'personName': 'Anantharamakrishnan Venkatasubramanian'},
    'details': {
      'eventName': 'Birthday',
      'hostName': 'The Venkatasubramanian Family of Chennai',
      'venue': {
        'name': 'The Grand Imperial Banquet Hall and Convention Centre',
        'address':
            'Plot 42, Sector 7, Outer Ring Road, Near the Old Lighthouse, Chennai 600041',
      },
      'date': '2026-09-23',
      'time': '19:00',
      'timezone': 'Asia/Kolkata',
      'rsvp': {'enabled': false},
    },
    'media': {},
  });

  static const minimal = BindingContext({
    'event': {'personName': 'Mia'},
    'details': {
      'eventName': 'Birthday',
      'hostName': 'Sam',
      'venue': {'name': 'Our place'},
      'date': '2027-01-09',
      'time': '10:00',
      'timezone': 'Asia/Kolkata',
      'rsvp': {'enabled': false},
    },
    'media': {},
  });
}
