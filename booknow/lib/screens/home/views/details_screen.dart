import 'package:booknow/components/macro.dart';
import 'package:booknow/screens/home/views/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:user_repository/user_repository.dart';

class DetailsScreen extends StatefulWidget {
  final Venue venue;
  const DetailsScreen({super.key, required this.venue});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  static const double _maxWidth = 1200;

  // Selections
  DateTime? _selectedDay;        // day only (no time)
  int? _selectedDuration;        // 90 / 120 / 240
  DateTime? _when;               // final chosen start DateTime

  // Configurable hours and slot steps
  static const int _openHour = 8;     // 08:00
  static const int _closeHour = 23;   // venue closes at 23:00 (end must be < 23:00)
  static const int _stepMins = 30;    // slot step

  // Helpers
  String _fmtDate(DateTime d) =>
      "${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}";
  String _fmtTimeOfDay(TimeOfDay t) {
    final h12 = (t.hour % 12 == 0) ? 12 : t.hour % 12;
    final ampm = t.hour >= 12 ? 'pm' : 'am';
    return "$h12:${t.minute.toString().padLeft(2, '0')}$ampm";
  }
  String _fmtFull(DateTime dt) {
    final d = _fmtDate(dt);
    final t = _fmtTimeOfDay(TimeOfDay.fromDateTime(dt));
    return "$t on $d";
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = _selectedDay ?? DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(now) ? now : initial,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      // store day only (zero out time)
      setState(() {
        _selectedDay = DateTime(picked.year, picked.month, picked.day);
        _when = null; // reset final selection if date changes
      });
    }
  }

  Future<void> _showSlotsDialog() async {
    if (_selectedDay == null || _selectedDuration == null) return;

    final slots = _generateSlots(
      day: _selectedDay!,
      durationMinutes: _selectedDuration!,
      openHour: _openHour,
      closeHour: _closeHour,
      stepMins: _stepMins,
    );

    final chosen = await showDialog<DateTime>(
      context: context,
      builder: (ctx) {
        final isDesktop = MediaQuery.of(ctx).size.width >= 800;
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Available time slots",
                          style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(ctx).pop(),
                          tooltip: 'Close',
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${_fmtDate(_selectedDay!)}  •  ${_selectedDuration!} mins",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (slots.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text("No slots available for this day.", style: TextStyle(color: Colors.grey.shade700)),
                      )
                    else
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 420),
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isDesktop ? 3 : 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 3.4,
                          ),
                          itemCount: slots.length,
                          itemBuilder: (_, i) {
                            final start = slots[i];
                            final end = start.add(Duration(minutes: _selectedDuration!));
                            final startTod = TimeOfDay.fromDateTime(start);
                            final endTod = TimeOfDay.fromDateTime(end);
                            return OutlinedButton(
                              onPressed: () => Navigator.of(ctx).pop(start),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                side: BorderSide(
                                  color: Theme.of(ctx).colorScheme.primary.withOpacity(.35),
                                ),
                              ),
                              child: Text(
                                "${_fmtTimeOfDay(startTod)} – ${_fmtTimeOfDay(endTod)}",
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    if (chosen != null) {
      setState(() => _when = chosen);
    }
  }

  // Generate slot starts so that (start + duration) < closeHour
  List<DateTime> _generateSlots({
    required DateTime day,
    required int durationMinutes,
    required int openHour,
    required int closeHour,
    required int stepMins,
  }) {
    final open = DateTime(day.year, day.month, day.day, openHour);
    final close = DateTime(day.year, day.month, day.day, closeHour);
    var cursor = open;

    // If today, don't offer times in the past; round up to step
    final now = DateTime.now();
    if (day.year == now.year && day.month == now.month && day.day == now.day) {
      final minsNow = now.hour * 60 + now.minute;
      final rounded = ((minsNow + stepMins - 1) ~/ stepMins) * stepMins;
      final rh = rounded ~/ 60;
      final rm = rounded % 60;
      final candidate = DateTime(day.year, day.month, day.day, rh, rm);
      if (candidate.isAfter(cursor)) cursor = candidate;
    }

    final list = <DateTime>[];
    while (true) {
      final end = cursor.add(Duration(minutes: durationMinutes));
      // end must be strictly before venue close
      if (!end.isBefore(close)) break;
      list.add(cursor);
      cursor = cursor.add(Duration(minutes: stepMins));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final venue = widget.venue;
    final isDesktop = MediaQuery.of(context).size.width >= 1000;

    // --- Left: hero image
    final heroImage = Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
          aspectRatio: isDesktop ? 16 / 12 : 16 / 9,
          child: Image.asset('assets/${venue.imageNumber}.png', fit: BoxFit.cover),
        ),
      ),
    );

    // --- Right: details
    final detailsCard = Material(
      elevation: 2,
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // title + price
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    venue.description,
                    style: TextStyle(fontSize: isDesktop ? 22 : 20, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${venue.price} BHD",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: isDesktop ? 22 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      " ",
                      style: TextStyle(height: 0, fontSize: 0), // small spacer
                    ),
                    Text(
                      "${venue.originPrice} BHD",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // macros
            ResponsiveMacros(
              items: const [
                MacroItem('Players', 8, FontAwesomeIcons.person),
                MacroItem('Specs', 200, FontAwesomeIcons.peopleGroup),
                MacroItem('Showers', 6, FontAwesomeIcons.shower),
                MacroItem('Football', 20, FontAwesomeIcons.soccerBall),
              ],
            ),

            const SizedBox(height: 20),

            // 1) Pick date
            ListTile(
              onTap: _pickDate,
              leading: const Icon(Icons.event),
              title: Text(_selectedDay == null ? 'Select date' : _fmtDate(_selectedDay!)),
              tileColor: Colors.grey.shade100,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(height: 12),

            // 2) Pick duration
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [90, 120, 240].map((d) {
                  final selected = _selectedDuration == d;
                  return ChoiceChip(
                    label: Text("$d mins"),
                    selected: selected,
                    onSelected: (_) => setState(() {
                      _selectedDuration = d;
                      _when = null; // reset chosen slot if duration changes
                    }),
                    selectedColor: Theme.of(context).colorScheme.primary.withOpacity(.15),
                    labelStyle: TextStyle(
                      color: selected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 12),

            // 3) Button appears only when both date & duration picked
            if (_selectedDay != null && _selectedDuration != null)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.schedule),
                  label: const Text("Show available time slots"),
                  onPressed: _showSlotsDialog,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),

            const SizedBox(height: 12),

            // 4) Summary of chosen slot (if any)
            if (_when != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Selected: ${_fmtFull(_when!)}  •  ${_selectedDuration ?? 0} mins",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 12),

            // Book button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton(
                onPressed: () {
                  if (_when == null || _selectedDuration == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select date, duration, and a time slot')),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CheckoutScreen(
                        venue: venue,
                        dateTime: _when!, // start time
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  elevation: 3.0,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  "Book Now",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.background),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxWidth),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 24 : 20,
                vertical: isDesktop ? 24 : 12,
              ),
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 6, child: heroImage),
                        const SizedBox(width: 24),
                        Expanded(flex: 5, child: detailsCard),
                      ],
                    )
                  : Column(
                      children: [
                        heroImage,
                        const SizedBox(height: 20),
                        detailsCard,
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
