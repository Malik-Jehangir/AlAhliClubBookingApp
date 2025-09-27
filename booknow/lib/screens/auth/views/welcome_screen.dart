// lib/screens/auth/views/welcome_screen.dart
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/authentication_bloc/authentication_bloc.dart';
import 'auth_page.dart';
import 'package:booknow/screens/home/views/home_screen.dart';
import 'package:booknow/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';

// optional pages (navbar About/Contact still navigate)
import 'package:booknow/screens/static/about_us_screen.dart';
import 'package:booknow/screens/static/contact_us_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  static const double _maxWidth = 1200;
  static const kMaroon = Color(0xFF7B1E1E);

  LinearGradient get _headerFooterGradient => const LinearGradient(
        colors: [Color(0xFF500505), Color(0xFFF3CB54)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  // anchors for smooth scroll
  final _homeKey = GlobalKey();
  final _bookKey = GlobalKey(); // points to footer "Ready to book?"

  // hero slideshow
  final _pageCtrl = PageController();
  final _slides = const [
    _Slide('assets/13.png', '', ''),
    _Slide('assets/14.png', '', ''),
    _Slide('assets/15.png', '', ''),
  ];
  int _page = 0;
  Timer? _auto;

  // event = 11 days from now
  late final DateTime _eventAt = DateTime.now().add(const Duration(days: 11));

  @override
  void initState() {
    super.initState();
    _auto = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      _pageCtrl.animateToPage(
        (_page + 1) % _slides.length,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _auto?.cancel();
    _pageCtrl.dispose();
    super.dispose();
  }

  Future<void> _scrollTo(GlobalKey key) async {
    final ctx = key.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      alignment: .05,
    );
  }

  Future<void> _guestLogin() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Guest mode enabled')),
    );
  }

  void _startBookingFlow() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => BlocProvider<SignInBloc>(
          create: (ctx) => SignInBloc(ctx.read<AuthenticationBloc>().userRepository),
          child: const HomeScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final barHeight = isDesktop ? 84.0 : 64.0; // taller toolbar
    const vPad = 12.0;
    final logoH = barHeight - (vPad * 2);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Stack(
        children: [
          // soft background blobs
          Align(
            alignment: const AlignmentDirectional(20, -1.2),
            child: Container(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kMaroon.withOpacity(0.07),
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(2.7, -1.2),
            child: Container(
              height: MediaQuery.of(context).size.width / 1.3,
              width: MediaQuery.of(context).size.width / 1.3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kMaroon.withOpacity(0.04),
              ),
            ),
          ),
          BackdropFilter(filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100), child: Container()),

          CustomScrollView(
            slivers: [
              // ===== BIG STICKY HEADER =====
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
                            logoHeight: logoH, // pass computed logo height
                            onLogoTap: () => _scrollTo(_homeKey),
                            onHome: () => _scrollTo(_homeKey),
                            onAbout: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AboutUsScreen()),
                            ),
                            // Book goes to HomeScreen
                            onBook: () => Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => const HomeScreen()),
                              (r) => false,
                            ),
                            onContact: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ContactUsScreen()),
                            ),
                            // auth tabs
                            onSignIn: () => Navigator.of(context).push(AuthPage.route(AuthMode.signIn)),
                            onSignUp: () => Navigator.of(context).push(AuthPage.route(AuthMode.signUp)),
                            onGuest: _guestLogin,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ===== HOME / HERO =====
              SliverToBoxAdapter(
                key: _homeKey,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: _maxWidth),
                    child: _HeroWithCountdown(
                      pageCtrl: _pageCtrl,
                      slides: _slides,
                      page: _page,
                      onChanged: (i) => setState(() => _page = i),
                      eventAt: _eventAt,
                    ),
                  ),
                ),
              ),

              // ===== ABOUT (pictures + text) =====
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: _maxWidth),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                      child: Column(
                        children: const [
                          _AboutRow(
                            imageAsset: 'assets/2.png',
                            title: 'Al Ahli Club — Tradition & Passion',
                            text:
                                'Al Ahli Club Bahrain is one of the Kingdom’s storied community clubs, fostering sportsmanship, teamwork, and local talent across multiple disciplines.',
                            imageLeft: false,
                          ),
                          SizedBox(height: 40),
                          _AboutRow(
                            imageAsset: 'assets/1.png',
                            title: 'Community at Heart',
                            text:
                                'From junior programs to competitive squads, Al Ahli’s facilities support players of all levels with coaching, events, and a welcoming atmosphere.',
                            imageLeft: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ===== FOOTER (with sub-links + Ready to book?) =====
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
                              onLogoTap: () => _scrollTo(_homeKey),
                            ),
                            const SizedBox(height: 20),
                            // Book anchor lives here (footer)
                            KeyedSubtree(
                              key: _bookKey,
                              child: _FooterBookNow(onFind: _startBookingFlow),
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

/* ===================== NAVBAR ===================== */
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
              Image.asset('assets/0.png', height: logoHeight), // fills toolbar
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

/* ===================== HERO WITH COUNTDOWN ===================== */
// (unchanged below)
class _HeroWithCountdown extends StatefulWidget {
  const _HeroWithCountdown({
    required this.pageCtrl,
    required this.slides,
    required this.page,
    required this.onChanged,
    required this.eventAt,
  });

  final PageController pageCtrl;
  final List<_Slide> slides;
  final int page;
  final ValueChanged<int> onChanged;
  final DateTime eventAt;

  @override
  State<_HeroWithCountdown> createState() => _HeroWithCountdownState();
}

class _HeroWithCountdownState extends State<_HeroWithCountdown> {
  late Timer _tick;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.eventAt.difference(DateTime.now());
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _remaining = widget.eventAt.difference(DateTime.now());
        if (_remaining.isNegative) _remaining = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _tick.cancel();
    super.dispose();
  }

  String _two(int v) => v.toString().padLeft(2, '0');
  String _three(int v) => v.toString().padLeft(3, '0');

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1000;
    final days = _three(_remaining.inDays.clamp(0, 999));
    final hours = _two(_remaining.inHours.remainder(24).clamp(0, 99));
    final mins = _two(_remaining.inMinutes.remainder(60).clamp(0, 99));
    final secs = _two(_remaining.inSeconds.remainder(60).clamp(0, 99));

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: isDesktop ? 16 / 5 : 16 / 9,
              child: PageView.builder(
                controller: widget.pageCtrl,
                onPageChanged: widget.onChanged,
                itemCount: widget.slides.length,
                itemBuilder: (_, i) {
                  final s = widget.slides[i];
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(s.asset, fit: BoxFit.cover),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.center,
                            colors: [Colors.black.withOpacity(0.45), Colors.transparent],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // countdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.35),
                borderRadius: BorderRadius.circular(16),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _CountBlock(value: days, label: 'days', wide: true),
                    const SizedBox(width: 18),
                    _CountBlock(value: hours, label: 'hrs'),
                    const SizedBox(width: 18),
                    _CountBlock(value: mins, label: 'min'),
                    const SizedBox(width: 18),
                    _CountBlock(value: secs, label: 'sec'),
                  ],
                ),
              ),
            ),

            // page dots
            Positioned(
              bottom: 10,
              child: Row(
                children: List.generate(
                  widget.slides.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: i == widget.page ? 26 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(i == widget.page ? 0.95 : 0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountBlock extends StatelessWidget {
  const _CountBlock({required this.value, required this.label, this.wide = false});
  final String value;
  final String label;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final numStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w900,
      fontSize: 42,
      height: 1.0,
      letterSpacing: 1.0,
      shadows: const [
        Shadow(blurRadius: 6, color: Colors.black54, offset: Offset(0, 2)),
      ],
    );
    final lblStyle = TextStyle(
      color: Colors.white.withOpacity(0.9),
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: .4,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: wide ? 100 : 72,
          child: Text(value, textAlign: TextAlign.center, style: numStyle),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: wide ? 100 : 72,
          child: Text(label, textAlign: TextAlign.center, style: lblStyle),
        ),
      ],
    );
  }
}

class _Slide {
  final String asset;
  final String headline;
  final String sub;
  const _Slide(this.asset, this.headline, this.sub);
}

/* ===================== ABOUT ===================== */
// (unchanged below)
class _AboutRow extends StatelessWidget {
  const _AboutRow({
    required this.imageAsset,
    required this.title,
    required this.text,
    required this.imageLeft,
  });

  final String imageAsset;
  final String title;
  final String text;
  final bool imageLeft;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1000;

    final image = Expanded(
      flex: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: isDesktop ? 4 / 3 : 16 / 9,
          child: Image.asset(imageAsset, fit: BoxFit.cover),
        ),
      ),
    );

    final copy = Expanded(
      flex: 6,
      child: Padding(
        padding: EdgeInsets.only(
          left: imageLeft ? 0 : (isDesktop ? 24 : 0),
          right: imageLeft ? (isDesktop ? 24 : 0) : 0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            Text(text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4)),
          ],
        ),
      ),
    );

    if (!isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          image,
          const SizedBox(height: 14),
          copy,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: imageLeft ? [image, const SizedBox(width: 24), copy] : [copy, const SizedBox(width: 24), image],
    );
  }
}

/* ===================== FOOTER ===================== */
// (unchanged below)
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
