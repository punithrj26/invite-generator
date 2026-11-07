import 'package:flutter_test/flutter_test.dart';
import 'package:invite_generator/template_engine/binding/binding_context.dart';

void main() {
  const data = BindingContext({
    'event': {'personName': 'Aarav', 'age': 5},
    'details': {
      'date': '2026-12-05',
      'time': '16:30',
      'venue': {'name': 'Funky Monkeys'},
      'description': '',
      'rsvp': {'enabled': false},
    },
    'media': {},
  });

  test('plain and nested paths; missing paths render empty', () {
    expect(
      data.bind('Hi {{event.personName}} at {{details.venue.name}}'),
      'Hi Aarav at Funky Monkeys',
    );
    expect(data.bind('[{{event.nope}}][{{nope.deeper.still}}]'), '[][]');
    expect(data.bind('no bindings'), 'no bindings');
  });

  test('date and time formatters use the template pattern', () {
    expect(
      data.bind('{{details.date|date:EEEE, d MMMM}}'),
      'Saturday, 5 December',
    );
    expect(data.bind('{{details.date|date:d MMM}}'), '5 Dec');
    expect(data.bind('{{details.time|time}}'), '4:30 PM');
    expect(
      data.bind('{{event.personName|date:d MMM}}'),
      'Aarav',
    ); // not a date: unchanged
  });

  test('ordinal suffixes, including the 11th–13th exceptions', () {
    String ord(int n) => BindingContext({'n': n}).bind('{{n|ordinal}}');
    expect([1, 2, 3, 4, 11, 12, 13, 21, 22, 23, 101, 111, 112].map(ord), [
      '1st',
      '2nd',
      '3rd',
      '4th',
      '11th',
      '12th',
      '13th',
      '21st',
      '22nd',
      '23rd',
      '101st',
      '111th',
      '112th',
    ]);
  });

  test('upper, lower and default', () {
    expect(
      data.bind('{{event.personName|upper}} {{event.personName|lower}}'),
      'AARAV aarav',
    );
    expect(
      data.bind('{{details.description|default:See you there}}'),
      'See you there',
    );
    expect(data.bind('{{event.personName|default:Guest}}'), 'Aarav');
  });

  test(
    'visibleIf: presence, negation, and empty/false/null count as absent',
    () {
      expect(data.isVisible(null), isTrue);
      expect(data.isVisible('event.age'), isTrue);
      expect(data.isVisible('!event.age'), isFalse);
      expect(data.isVisible('media.photoUrl'), isFalse);
      expect(data.isVisible('!media.photoUrl'), isTrue);
      expect(data.isVisible('details.description'), isFalse); // ""
      expect(data.isVisible('details.rsvp.enabled'), isFalse); // false
    },
  );

  test(
    'an unknown formatter is a template bug: it asserts in debug builds',
    () {
      expect(
        () => data.bind('{{event.personName|shout}}'),
        throwsA(isA<AssertionError>()),
      );
    },
  );
}
