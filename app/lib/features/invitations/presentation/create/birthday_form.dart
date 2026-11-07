import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/tokens.dart';
import '../../../../shared/validators.dart';
import '../../domain/invitation.dart';

// shortcut: every event uses India time (Phase 1 market, docs/04); add a zone picker (or flutter_timezone) for other markets.
const defaultTimezone = 'Asia/Kolkata';

const emptyBirthday = BirthdayData(personName: '');
const emptyDetails = EventDetails(
  eventName: '',
  hostName: '',
  venue: Venue(name: ''),
  date: '',
  time: '',
  timezone: defaultTimezone,
);

typedef BirthdayValue = ({BirthdayData event, EventDetails details});

final _phoneJunk = RegExp(r'[\s\-()]');

/// Birthday details (docs/01 §4.1 `forms/birthday_fields.dart`), shared by "new invitation" and the editor.
/// Emits the whole value on every change; validation runs through the enclosing [Form].
class BirthdayForm extends StatefulWidget {
  const BirthdayForm({
    super.key,
    required this.initial,
    required this.onChanged,
    this.fieldErrors = const {},
  });

  final BirthdayValue initial;
  final ValueChanged<BirthdayValue> onChanged;

  /// Server field errors, keyed by API path (`details.time`, `eventData.personName`, …).
  final Map<String, String> fieldErrors;

  @override
  State<BirthdayForm> createState() => _BirthdayFormState();
}

class _BirthdayFormState extends State<BirthdayForm> {
  late final _name = _ctl(widget.initial.event.personName);
  late final _age = _ctl(widget.initial.event.age?.toString());
  late final _eventName = _ctl(widget.initial.details.eventName);
  late final _host = _ctl(widget.initial.details.hostName);
  late final _venue = _ctl(widget.initial.details.venue.name);
  late final _address = _ctl(widget.initial.details.venue.address);
  late final _mapUrl = _ctl(widget.initial.details.venue.mapUrl);
  late final _description = _ctl(widget.initial.details.description);
  late final _contact = _ctl(widget.initial.details.contactPhone);
  late final _rsvpPhone = _ctl(widget.initial.details.rsvp.phone);
  late String _date = widget.initial.details.date;
  late String _time = widget.initial.details.time;
  late bool _rsvp = widget.initial.details.rsvp.enabled;
  late String? _deadline = widget.initial.details.rsvp.deadline;

  final _all = <TextEditingController>[];

  TextEditingController _ctl(String? text) {
    final c = TextEditingController(text: text ?? '')..addListener(_emit);
    _all.add(c);
    return c;
  }

  @override
  void dispose() {
    for (final c in _all) {
      c.dispose();
    }
    super.dispose();
  }

  static String? _opt(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

  /// Phone fields accept "+91 98000 00000"; the API wants E.164.
  static String? _phone(TextEditingController c) =>
      _opt(c)?.replaceAll(_phoneJunk, '');

  static String? _validPhone(String? v) =>
      Validators.phone(v?.replaceAll(_phoneJunk, ''));

  void _emit() {
    widget.onChanged((
      event: BirthdayData(
        personName: _name.text.trim(),
        age: int.tryParse(_age.text.trim()),
      ),
      details: widget.initial.details.copyWith(
        eventName: _eventName.text.trim(),
        hostName: _host.text.trim(),
        venue: Venue(
          name: _venue.text.trim(),
          address: _opt(_address),
          mapUrl: _opt(_mapUrl),
        ),
        date: _date,
        time: _time,
        description: _opt(_description),
        contactPhone: _phone(_contact),
        rsvp: Rsvp(
          enabled: _rsvp,
          deadline: _rsvp ? _deadline : null,
          phone: _rsvp ? _phone(_rsvpPhone) : null,
        ),
      ),
    ));
  }

  Future<void> _pickDate({required bool deadline}) async {
    final today = DateUtils.dateOnly(DateTime.now());
    final current = DateTime.tryParse(deadline ? (_deadline ?? '') : _date);
    final first = today.subtract(const Duration(days: 1));
    final picked = await showDatePicker(
      context: context,
      initialDate: current == null || current.isBefore(first) ? today : current,
      firstDate: first,
      lastDate: today.add(const Duration(days: 3 * 365)),
      helpText: deadline ? 'RSVP by' : 'Event date',
    );
    if (picked == null) return;
    final iso = DateFormat('yyyy-MM-dd').format(picked);
    setState(() => deadline ? _deadline = iso : _date = iso);
    _emit();
  }

  Future<void> _pickTime() async {
    final p = _time.split(':');
    final picked = await showTimePicker(
      context: context,
      initialTime: p.length == 2
          ? TimeOfDay(hour: int.parse(p[0]), minute: int.parse(p[1]))
          : const TimeOfDay(hour: 16, minute: 0),
      helpText: 'Start time',
    );
    if (picked == null) return;
    String two(int n) => n.toString().padLeft(2, '0');
    setState(() => _time = '${two(picked.hour)}:${two(picked.minute)}');
    _emit();
  }

  String? _err(String path) => widget.fieldErrors[path];

  static String _day(String iso) =>
      DateFormat('EEE, d MMM yyyy', 'en_US').format(DateTime.parse(iso));

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    Widget gap() => const SizedBox(height: Space.md);
    Widget section(String title) => Padding(
      padding: const EdgeInsets.only(top: Space.lg, bottom: Space.sm),
      child: Semantics(
        header: true,
        child: Text(title, style: text.titleMedium),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        section('Who is celebrating?'),
        TextFormField(
          controller: _name,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          validator: (v) => Validators.text(v, 'their name', max: 60),
          forceErrorText: _err('eventData.personName'),
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        gap(),
        TextFormField(
          controller: _age,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          validator: (v) {
            final t = v?.trim() ?? '';
            if (t.isEmpty) return null;
            final n = int.tryParse(t);
            return n == null || n < 1 || n > 150
                ? 'Enter an age from 1 to 150'
                : null;
          },
          forceErrorText: _err('eventData.age'),
          decoration: const InputDecoration(
            labelText: 'Turning (optional)',
            helperText: 'Leave empty to keep the age off the invitation',
          ),
        ),
        section('The event'),
        TextFormField(
          controller: _eventName,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.next,
          validator: (v) => Validators.text(v, 'a title', max: 100),
          forceErrorText: _err('details.eventName'),
          decoration: const InputDecoration(
            labelText: 'Title',
            hintText: "e.g. Aarav's 5th Birthday",
          ),
        ),
        gap(),
        TextFormField(
          controller: _host,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          validator: (v) => Validators.text(v, 'who is hosting', max: 80),
          forceErrorText: _err('details.hostName'),
          decoration: const InputDecoration(labelText: 'Hosted by'),
        ),
        gap(),
        _PickerField(
          label: 'Date',
          value: _date.isEmpty ? null : _day(_date),
          icon: Icons.event_outlined,
          error: _err('details.date'),
          requiredMessage: 'Choose the date',
          onTap: () => _pickDate(deadline: false),
        ),
        gap(),
        _PickerField(
          label: 'Start time',
          value: _time.isEmpty
              ? null
              : DateFormat.jm('en_US')
                    .format(DateTime.parse('2000-01-01 $_time:00'))
                    .replaceAll('\u202F', ' '),
          icon: Icons.schedule_outlined,
          error: _err('details.time'),
          requiredMessage: 'Choose the start time',
          onTap: _pickTime,
        ),
        section('Where'),
        TextFormField(
          controller: _venue,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          validator: (v) => Validators.text(v, 'the venue', max: 120),
          forceErrorText: _err('details.venue.name'),
          decoration: const InputDecoration(labelText: 'Venue'),
        ),
        gap(),
        TextFormField(
          controller: _address,
          textCapitalization: TextCapitalization.sentences,
          maxLines: 2,
          validator: (v) =>
              Validators.text(v, 'the address', max: 300, required: false),
          forceErrorText: _err('details.venue.address'),
          decoration: const InputDecoration(labelText: 'Address (optional)'),
        ),
        gap(),
        TextFormField(
          controller: _mapUrl,
          keyboardType: TextInputType.url,
          validator: Validators.httpsUrl,
          forceErrorText: _err('details.venue.mapUrl'),
          decoration: const InputDecoration(
            labelText: 'Map link (optional)',
            hintText: 'https://maps.app.goo.gl/…',
          ),
        ),
        section('More'),
        TextFormField(
          controller: _description,
          textCapitalization: TextCapitalization.sentences,
          maxLines: 3,
          validator: (v) =>
              Validators.text(v, 'a message', max: 1000, required: false),
          forceErrorText: _err('details.description'),
          decoration: const InputDecoration(labelText: 'Message (optional)'),
        ),
        gap(),
        TextFormField(
          controller: _contact,
          keyboardType: TextInputType.phone,
          validator: _validPhone,
          forceErrorText: _err('details.contactPhone'),
          decoration: const InputDecoration(
            labelText: 'Contact phone (optional)',
            hintText: '+91 98000 00000',
          ),
        ),
        gap(),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Ask guests to RSVP'),
          value: _rsvp,
          onChanged: (v) {
            setState(() => _rsvp = v);
            _emit();
          },
        ),
        if (_rsvp) ...[
          _PickerField(
            label: 'RSVP by (optional)',
            value: _deadline == null ? null : _day(_deadline!),
            icon: Icons.event_available_outlined,
            error: _err('details.rsvp.deadline'),
            onTap: () => _pickDate(deadline: true),
          ),
          gap(),
          TextFormField(
            controller: _rsvpPhone,
            keyboardType: TextInputType.phone,
            validator: _validPhone,
            forceErrorText: _err('details.rsvp.phone'),
            decoration: const InputDecoration(
              labelText: 'RSVP phone (optional)',
              hintText: '+91 98000 00000',
            ),
          ),
        ],
      ],
    );
  }
}

/// A read-only field that opens a picker. It joins form validation, so a missing date shows like any field error.
class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
    this.error,
    this.requiredMessage,
  });

  final String label;
  final String? value;
  final IconData icon;
  final VoidCallback onTap;
  final String? error;
  final String? requiredMessage;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      key: ValueKey(value), // a new value re-runs validation from fresh state
      initialValue: value,
      validator: (v) => requiredMessage != null && (v == null || v.isEmpty)
          ? requiredMessage
          : null,
      builder: (field) => Semantics(
        button: true,
        label: value == null ? label : '$label, $value',
        excludeSemantics: true,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Radii.sm),
          child: InputDecorator(
            isEmpty: value == null,
            decoration: InputDecoration(
              labelText: label,
              suffixIcon: Icon(icon),
              errorText: error ?? field.errorText,
            ),
            child: value == null ? null : Text(value!),
          ),
        ),
      ),
    );
  }
}
