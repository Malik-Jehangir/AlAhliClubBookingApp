// lib/screens/home/views/home_screen.dart
import 'package:booknow/components/venue_grid.dart';
import 'package:booknow/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:booknow/screens/auth/views/auth_page.dart';
import 'package:booknow/screens/auth/views/welcome_screen.dart';
import 'package:booknow/screens/static/about_us_screen.dart';
import 'package:booknow/screens/static/contact_us_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const double _contentMaxWidth = 1200;

  LinearGradient get _headerFooterGradient => const LinearGradient(
        colors: [Color(0xFF500505), Color(0xFFF3CB54)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  @override
  Widget build(BuildContext context) {
    final List<Venue> venues = [
      Venue(status: 'Available', imageNumber: 1, location: 'Riffa', activity: 'Volleyball',  description: "Bahrain's most stylish airconditioned volleyball court", price: 140, originPrice: 180),
      Venue(status: 'Available', imageNumber: 2, location: 'Isa Town', activity: 'Football 5s', description: 'High-grade turf, evening floodlights', price: 90, originPrice: 110),
      Venue(status: 'Available', imageNumber: 3, location: 'Juffair', activity: 'Padel', description: 'Glass walls, rental rackets', price: 60, originPrice: 75),
      Venue(status: 'Available', imageNumber: 4, location: 'Muharraq', activity: 'Basketball', description: 'Indoor hardwood, scoreboard', price: 120, originPrice: 150),
      Venue(status: 'Available', imageNumber: 5, location: 'Saar', activity: 'Badminton', description: 'Two courts, Yonex nets, AC', price: 40, originPrice: 55),
      Venue(status: 'Available', imageNumber: 6, location: 'Adliya', activity: 'Tennis', description: 'Hard court, night play', price: 85, originPrice: 95),
      Venue(status: 'Available', imageNumber: 7, location: 'Hamad Town', activity: 'Cricket Nets', description: 'Bowling machine optional', price: 50, originPrice: 70),
      Venue(status: 'Available', imageNumber: 8, location: 'Seef', activity: 'Swimming', description: '25m lane, lifeguard on duty', price: 30, originPrice: 40),
      Venue(status: 'Available', imageNumber: 9, location: 'Sanabis', activity: 'Table Tennis', description: 'ITTF tables, paddles for rent', price: 25, originPrice: 35),
      Venue(status: 'Available', imageNumber: 10, location: 'Hidd', activity: 'Squash', description: 'Glass back, pro floor', price: 70, originPrice: 85),
      Venue(status: 'Available', imageNumber: 11, location: 'Tubli', activity: 'Yoga', description: 'Mirrors, mats available', price: 45, originPrice: 60),
      Venue(status: 'Available', imageNumber: 12, location: 'Manama', activity: 'Dance', description: 'Wood floor, sound system', price: 95, originPrice: 120),
    ];

    // anchors
    final bookKey = GlobalKey();
    final homeKey = GlobalKey();

    void toWelcome() {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        (route) => false,
      );
    }

    // ===== NEW: Taller toolbar + computed logo height (same as other screens) =====
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final barHeight = isDesktop ? 84.0 : 64.0; // make header taller
    const vPad = 12.0;                          // keep your existing vertical padding
    final logoH = barHeight - (vPad * 2);       // logo fills the bar

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          // ===== SAME HEADER =====
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            toolbarHeight: barHeight, // <-- important so image isn't constrained to 56
            flexibleSpace: Container(
              decoration: BoxDecoration(gradient: _headerFooterGradient),
              child: SafeArea(
                bottom: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: vPad),
                      child: _NavBar(
                        logoHeight: logoH, // <-- pass computed height
                        onLogoTap: () => toWelcome(),
                        onHome: () => toWelcome(),
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

          // ===== CONTENT (VenueGrid) =====
          SliverToBoxAdapter(
            key: homeKey,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                  // Your VenueGrid is its own scrollable; to keep the same widget without edits,
                  // give it a big height so you can still scroll to the footer afterwards.
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Venues', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 12),
                      SizedBox(height: 1200, child: VenueGrid(venues: venues)),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ===== SAME FOOTER =====
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(gradient: _headerFooterGradient),
              padding: const EdgeInsets.only(top: 28, bottom: 12),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _FooterColumns(
                          onLogoTap: () => toWelcome(),
                        ),
                        const SizedBox(height: 20),
                        KeyedSubtree(
                          key: bookKey,
                          child: _FooterBookNow(
                            onFind: () {
                              // go to booking flow (or keep on this page – your call)
                              context.read<SignInBloc?>(); // keep bloc access so analyzer is happy
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

/* ---------- same header/footer helper widgets as Welcome ---------- */

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
              // was fixed 56; now uses computed height passed from parent
              Image.asset('assets/0.png', height: logoHeight),
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
