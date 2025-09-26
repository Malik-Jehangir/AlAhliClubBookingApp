// lib/screens/static/about_us_screen.dart
import 'package:flutter/material.dart';

// Adjust these imports if your paths differ:
import 'package:booknow/screens/auth/views/welcome_screen.dart';
import 'package:booknow/screens/home/views/home_screen.dart';
import 'package:booknow/screens/static/contact_us_screen.dart';
import 'package:booknow/screens/auth/views/auth_page.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  static const double _maxWidth = 1200;
  static const kMaroon = Color(0xFF500505);
  static const kGold = Color(0xFFF3CB54);

  LinearGradient get _headerFooterGradient => const LinearGradient(
        colors: [kMaroon, kGold],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  @override
  Widget build(BuildContext context) {
    Future<void> _guestLogin() async {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Guest mode enabled')),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          // soft background circles (subtle)
          Positioned(
            top: -120,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kMaroon.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -160,
            right: -100,
            child: Container(
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kGold.withOpacity(0.08),
              ),
            ),
          ),

          CustomScrollView(
            slivers: [
              // ===== HEADER (match WelcomeScreen) =====
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: Container(
                  decoration: BoxDecoration(gradient: _headerFooterGradient),
                  child: SafeArea(
                    bottom: false,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: _maxWidth),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                          child: _NavBar(
                            onLogoTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const WelcomeScreen()),
                                (r) => false,
                              );
                            },
                            onHome: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const WelcomeScreen()),
                                (r) => false,
                              );
                            },
                            onAbout: () {
                              // stay here
                            },
                            onBook: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => const HomeScreen(),
                                ),
                                (r) => false,
                              );
                            },
                            onContact: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ContactUsScreen()),
                              );
                            },
                            onSignIn: () => Navigator.of(context)
                                .push(AuthPage.route(AuthMode.signIn)),
                            onSignUp: () => Navigator.of(context)
                                .push(AuthPage.route(AuthMode.signUp)),
                            onGuest: _guestLogin,
                            activeTab: _ActiveTab.about,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ===== HERO STRIP =====
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: _maxWidth),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
                      child: _HeroBanner(),
                    ),
                  ),
                ),
              ),

              // ===== CONTENT SECTIONS =====
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: _maxWidth),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: const [
                          _SectionTitle('Our Story & Mission'),
                          SizedBox(height: 12),
                          _CopyBlock(
                            text:
                                "Founded in Manama, Bahrain, Al Ahli Club has grown into a vibrant multi-sport community that champions participation, discipline, and togetherness. "
                                "Our mission is simple: create inclusive pathways for juniors and adults to train, compete, and thrive—on and off the court.",
                          ),
                          SizedBox(height: 24),
                          _KeyStatsRow(),
                          SizedBox(height: 36),
                          _SectionTitle('Facilities'),
                          SizedBox(height: 12),
                          _FacilitiesGrid(),
                          SizedBox(height: 36),
                          _SectionTitle('Programs & Pathways'),
                          SizedBox(height: 12),
                          _ProgramsList(),
                          SizedBox(height: 36),
                          _SectionTitle('Community & Values'),
                          SizedBox(height: 12),
                          _CopyBlock(
                            text:
                                "We believe sport is a force for good. From holiday camps and school partnerships to charity matches and community outreach, "
                                "Al Ahli Club brings people together. Respect, resilience, and fair play are the pillars we teach every day.",
                          ),
                          SizedBox(height: 24),
                          _SectionTitle('Achievements'),
                          SizedBox(height: 12),
                          _AchievementsStrip(),
                          SizedBox(height: 36),
                          _SectionTitle('Leadership & Coaching'),
                          SizedBox(height: 12),
                          _CopyBlock(
                            text:
                                "Our coaches are accredited professionals with a passion for education and athlete development. "
                                "We invest in continuous learning so that every session—beginner to elite—meets high standards of safety, pedagogy, and performance.",
                          ),
                          SizedBox(height: 36),
                          _SectionTitle('Get Involved'),
                          SizedBox(height: 12),
                          _CopyBlock(
                            text:
                                "Whether you’re a parent, player, volunteer, or venue owner, we’d love to hear from you. "
                                "Visit our Contact page to reach the right team and start your journey with Al Ahli Club.",
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ===== FOOTER (match WelcomeScreen) =====
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
                              onLogoTap: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const WelcomeScreen()),
                                  (r) => false,
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            _FooterBookNow(
                              onFind: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => const HomeScreen(),
                                  ),
                                  (r) => false,
                                );
                              },
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
        ],
      ),
    );
  }
}

//* ---------------- NAVBAR (tabs, clickable logo) ---------------- */

enum _ActiveTab { home, about, book, contact }

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
    this.activeTab = _ActiveTab.home,
  });

  final VoidCallback onLogoTap;
  final VoidCallback onHome;
  final VoidCallback onAbout;
  final VoidCallback onBook;
  final VoidCallback onContact;
  final VoidCallback onSignIn;
  final VoidCallback onSignUp;
  final VoidCallback onGuest;
  final _ActiveTab activeTab;

  // 🔧 No underline; make active a bit bolder (or change color if you want)
  TextStyle _linkStyle(bool active) => TextStyle(
        color: Colors.white,
        fontWeight: active ? FontWeight.w900 : FontWeight.w700,
        fontSize: 16,
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onLogoTap,
          child: Row(
            children: const [
              _HeaderLogo(),
              SizedBox(width: 10),
              Text(
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
        TextButton(onPressed: onHome, child: Text('Home', style: _linkStyle(activeTab == _ActiveTab.home))),
        TextButton(onPressed: onAbout, child: Text('About Us', style: _linkStyle(activeTab == _ActiveTab.about))),
        TextButton(onPressed: onBook, child: Text('Book', style: _linkStyle(activeTab == _ActiveTab.book))),
        TextButton(onPressed: onContact, child: Text('Contact Us', style: _linkStyle(activeTab == _ActiveTab.contact))),
        const SizedBox(width: 12),
        TextButton(onPressed: onSignIn, child: Text('Sign In', style: _linkStyle(false))),
        TextButton(onPressed: onSignUp, child: Text('Sign Up', style: _linkStyle(false))),
        TextButton(onPressed: onGuest, child: Text('Guest', style: _linkStyle(false))),
      ],
    );
  }
}


class _HeaderLogo extends StatelessWidget {
  const _HeaderLogo();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    return Image.asset('assets/0.png', height: isDesktop ? 56 : 48);
  }
}

/* ---------------- HERO BANNER ---------------- */
class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 900;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF631010), Color(0xFFF1D277)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: AspectRatio(
          aspectRatio: isDesktop ? 16 / 5 : 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Opacity(
                opacity: 0.14,
                child: Image.asset(
                  'assets/1.png', // decorative background
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(isDesktop ? 32 : 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About Al Ahli Club',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isDesktop ? 44 : 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Tradition, passion, and community—serving Bahrain with multi-sport programs, modern facilities, and a culture of fair play.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.95),
                            fontSize: isDesktop ? 18 : 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/* ---------------- SECTION TITLE ---------------- */
class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.w900));
  }
}

/* ---------------- COPY BLOCK ---------------- */
class _CopyBlock extends StatelessWidget {
  const _CopyBlock({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5, color: Colors.grey.shade800),
    );
  }
}

/* ---------------- KEY STATS ---------------- */
class _KeyStatsRow extends StatelessWidget {
  const _KeyStatsRow();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final cards = const [
      _StatCard(title: 'Members', value: '2,500+'),
      _StatCard(title: 'Annual Programs', value: '80+'),
      _StatCard(title: 'Certified Coaches', value: '35'),
      _StatCard(title: 'Facilities', value: '12'),
    ];
    return isDesktop
        ? Row(
            children: [
              for (final c in cards) ...[
                Expanded(child: c),
                if (c != cards.last) const SizedBox(width: 12),
              ]
            ],
          )
        : Column(
            children: [
              for (final c in cards) ...[
                c,
                if (c != cards.last) const SizedBox(height: 12),
              ]
            ],
          );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w900, fontSize: 26)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(color: Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }
}

/* ---------------- FACILITIES GRID ---------------- */
class _FacilitiesGrid extends StatelessWidget {
  const _FacilitiesGrid();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    final items = const [
      _FacilityTile(icon: Icons.sports_soccer, title: 'Football Pitches', sub: '5-a-side & 7-a-side'),
      _FacilityTile(icon: Icons.sports_tennis, title: 'Padel & Tennis', sub: 'Glass courts, night lighting'),
      _FacilityTile(icon: Icons.sports_basketball, title: 'Indoor Courts', sub: 'Volleyball & Basketball'),
      _FacilityTile(icon: Icons.pool, title: 'Swimming', sub: '25m lanes, lifeguard on duty'),
      _FacilityTile(icon: Icons.fitness_center, title: 'Gym & Conditioning', sub: 'Strength & mobility'),
      _FacilityTile(icon: Icons.emoji_events, title: 'Event Spaces', sub: 'Tournaments & ceremonies'),
    ];

    final grid = GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 3 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 4 / 3,
      ),
      itemBuilder: (_, i) => items[i],
    );

    return grid;
  }
}

class _FacilityTile extends StatelessWidget {
  const _FacilityTile({required this.icon, required this.title, required this.sub});
  final IconData icon;
  final String title;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration:
            BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 4),
            Text(sub, style: TextStyle(color: Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }
}

/* ---------------- PROGRAMS LIST ---------------- */
class _ProgramsList extends StatelessWidget {
  const _ProgramsList();

  @override
  Widget build(BuildContext context) {
    final items = const [
      _ProgramRow(
        title: 'Junior Development',
        text:
            'Age-group training with certified coaches. Emphasis on fundamentals, teamwork, and safe progression.',
      ),
      _ProgramRow(
        title: 'Adult Leagues',
        text:
            'Structured seasons across football, padel, basketball, and more. Balanced divisions for all abilities.',
      ),
      _ProgramRow(
        title: 'Holiday Camps',
        text:
            'Multi-sport camps during school breaks. Skill-building, games, and character education.',
      ),
      _ProgramRow(
        title: 'Performance Pathway',
        text:
            'High-potential athletes receive individual plans, fitness screening, and competition support.',
      ),
    ];

    return Column(
      children: [
        for (final i in items) ...[
          i,
          if (i != items.last) const Divider(height: 24),
        ]
      ],
    );
  }
}

class _ProgramRow extends StatelessWidget {
  const _ProgramRow({required this.title, required this.text});
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, color: Colors.green),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(height: 6),
              Text(text, style: TextStyle(color: Colors.grey.shade800, height: 1.45)),
            ],
          ),
        ),
      ],
    );
  }
}

/* ---------------- ACHIEVEMENTS STRIP ---------------- */
class _AchievementsStrip extends StatelessWidget {
  const _AchievementsStrip();

  @override
  Widget build(BuildContext context) {
    final chips = [
      _badge('Regional Cup Winners'),
      _badge('Youth League Champions'),
      _badge('Fair Play Award'),
      _badge('Community Impact Recognition'),
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: chips,
    );
  }

  static Widget _badge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}

/* ---------------- FOOTER (same structure as Welcome) ---------------- */
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
        children: const [
          // much bigger footer logo
          _FooterLogo(),
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

class _FooterLogo extends StatelessWidget {
  const _FooterLogo();

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/0.png', height: 104);
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
            onTap: () {}, // clickable, no-op
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

// Footer "Ready to book?" (the only one on the page)
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
