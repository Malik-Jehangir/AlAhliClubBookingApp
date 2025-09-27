// lib/screens/home/views/details_screen.dart
import 'package:booknow/components/macro.dart';
import 'package:booknow/screens/auth/views/auth_page.dart';
import 'package:booknow/screens/auth/views/welcome_screen.dart';
import 'package:booknow/screens/home/views/checkout_screen.dart';
import 'package:booknow/screens/home/views/home_screen.dart';
import 'package:booknow/screens/static/about_us_screen.dart';
import 'package:booknow/screens/static/contact_us_screen.dart';
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

  LinearGradient get _headerFooterGradient => const LinearGradient(
        colors: [Color(0xFF500505), Color(0xFFF3CB54)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  // anchors
  final _bookKey = GlobalKey();
  final _homeKey = GlobalKey();

  // Selections
  DateTime? _selectedDay;
  int? _selectedDuration;
  DateTime? _when;

  // Configurable hours and slot steps
  static const int _openHour = 8;
  static const int _closeHour = 23;
  static const int _stepMins = 30;

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
      setState(() {
        _selectedDay = DateTime(picked.year, picked.month, picked.day);
        _when = null;
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
                                side: BorderSide(color: Theme.of(ctx).colorScheme.primary.withOpacity(.35)),
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

    if (chosen != null) setState(() => _when = chosen);
  }

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

    // hero image
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

    // details card
    final detailsCard = Material(
      elevation: 2,
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                    const Text(" ", style: TextStyle(height: 0, fontSize: 0)),
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

            ResponsiveMacros(
              items: const [
                MacroItem('Players', 8, FontAwesomeIcons.person),
                MacroItem('Specs', 200, FontAwesomeIcons.peopleGroup),
                MacroItem('Showers', 6, FontAwesomeIcons.shower),
                MacroItem('Football', 20, FontAwesomeIcons.soccerBall),
              ],
            ),

            const SizedBox(height: 20),

            ListTile(
              onTap: _pickDate,
              leading: const Icon(Icons.event),
              title: Text(_selectedDay == null ? 'Select date' : _fmtDate(_selectedDay!)),
              tileColor: Colors.grey.shade100,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(height: 12),

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
                      _when = null;
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
                        dateTime: _when!,
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
                child: const Text("Book Now", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );

    // ===== NEW: Taller toolbar + computed logo height (same pattern as other screens)
    final barIsDesktop = MediaQuery.of(context).size.width >= 900;
    final barHeight = barIsDesktop ? 84.0 : 64.0;
    const vPad = 12.0;
    final logoH = barHeight - (vPad * 2);

    // PAGE LAYOUT WITH SAME HEADER + FOOTER
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          // ===== HEADER (same as other screens) =====
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            toolbarHeight: barHeight, // important
            flexibleSpace: Container(
              decoration: BoxDecoration(gradient: _headerFooterGradient),
              child: SafeArea(
                bottom: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: _maxWidth),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: vPad),
                      child: _NavBar(
                        logoHeight: logoH, // pass computed height
                        onLogoTap: () => Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                          (r) => false,
                        ),
                        onHome: () => Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                          (r) => false,
                        ),
                        onAbout: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUsScreen())),
                        onBook: () => Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                          (r) => false, // clears the stack so the header "Book" consistently lands on Home
                        ),
                        onContact: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactUsScreen())),
                        onSignIn: () => Navigator.of(context).push(AuthPage.route(AuthMode.signIn)),
                        onSignUp: () => Navigator.of(context).push(AuthPage.route(AuthMode.signUp)),
                        onGuest: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Guest mode enabled'))),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ===== CONTENT =====
          SliverToBoxAdapter(
            key: _homeKey,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxWidth),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isDesktop ? 24 : 20, vertical: isDesktop ? 24 : 12),
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

          // ===== FOOTER (same as other screens) =====
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(gradient: _headerFooterGradient),
              padding: const EdgeInsets.only(top: 28, bottom: 12),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _maxWidth),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _FooterColumns(
                          onLogoTap: () => Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                            (r) => false,
                          ),
                        ),
                        const SizedBox(height: 20),
                        KeyedSubtree(
                          key: _bookKey,
                          child: _FooterBookNow(
                            onFind: () {
                              // Hook booking flow here if needed
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Open booking flow…')),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Divider(color: Colors.white24, height: 1),
                        const SizedBox(height: 10),
                        const _FooterBottomBar(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------- shared header/footer widgets (same style as your other screens) ---------- */

class _NavBar extends StatelessWidget {
  const _NavBar({
    required this.onLogoTap,
    required this.onHome,
    required this.onAbout,
    required this.onBook,
    required this.onContact,
    required this.onSignIn,
    required this.onSignUp,
    required this.onGuest,
    required this.logoHeight, // NEW
  });

  final VoidCallback onLogoTap;
  final VoidCallback onHome;
  final VoidCallback onAbout;
  final VoidCallback onBook;
  final VoidCallback onContact;
  final VoidCallback onSignIn;
  final VoidCallback onSignUp;
  final VoidCallback onGuest;
  final double logoHeight; // NEW

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onLogoTap,
          child: Row(
            children: [
              Image.asset('assets/0.png', height: logoHeight), // fills the taller toolbar
              const SizedBox(width: 10),
              const Text(
                'BookNow',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .5,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        _NavTab('Home', onHome),
        _NavTab('About Us', onAbout),
        _NavTab('Book', onBook),
        _NavTab('Contact Us', onContact),
        const SizedBox(width: 12),
        _NavTab('Sign In', onSignIn),
        _NavTab('Sign Up', onSignUp),
        _NavTab('Guest', onGuest),
      ],
    );
  }
}

class _NavTab extends StatelessWidget {
  const _NavTab(this.label, this.onTap);
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
    );
  }
}

class _FooterColumns extends StatelessWidget {
  const _FooterColumns({required this.onLogoTap});
  final VoidCallback onLogoTap;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    final left = InkWell(
      onTap: onLogoTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/0.png', height: 104),
        ],
      ),
    );

    final about = _FooterSection(
      title: 'About Al Ahli',
      links: const ['About Us', 'Terms and Condition', 'Contact Us'],
    );

    final players = _FooterSection(
      title: 'For Players',
      links: const ['Stadiums List', 'Privacy Policy', 'Refund Policy'],
    );

    final owners = _FooterSection(
      title: 'For Venue Owners',
      links: const ['Join as an owner', 'FAQS'],
    );

    if (!isWide) {
      return Column(
        children: [
          left,
          const SizedBox(height: 24),
          about,
          const SizedBox(height: 16),
          players,
          const SizedBox(height: 16),
          owners,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 4, child: Center(child: left)),
        const SizedBox(width: 24),
        Expanded(flex: 3, child: about),
        Expanded(flex: 3, child: players),
        Expanded(flex: 3, child: owners),
      ],
    );
  }
}

class _FooterSection extends StatelessWidget {
  const _FooterSection({required this.title, required this.links});
  final String title;
  final List<String> links;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
        const SizedBox(height: 12),
        for (final text in links)
          _FooterLink(
            text,
            onTap: () {}, // clickable no-op
          ),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink(this.label, {this.onTap});
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

class _FooterBookNow extends StatelessWidget {
  const _FooterBookNow({required this.onFind});
  final VoidCallback onFind;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Ready to book?',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
            ),
            ElevatedButton.icon(
              onPressed: onFind,
              icon: const Icon(Icons.calendar_month_rounded),
              label: const Text('Find a slot'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterBottomBar extends StatelessWidget {
  const _FooterBottomBar();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Version 1.0.0  © ${DateTime.now().year} Al Ahli. All rights reserved.',
      style: const TextStyle(color: Colors.white70),
      textAlign: TextAlign.center,
    );
  }
}
