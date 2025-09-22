// lib/screens/auth/views/welcome_screen.dart
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/authentication_bloc/authentication_bloc.dart';
import 'auth_page.dart'; // separate page that shows sign in / sign up
import 'package:booknow/screens/home/views/home_screen.dart';
import 'package:booknow/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  static const double _maxWidth = 1200;
  static const kMaroon = Color(0xFF7B1E1E);
  static const kMaroonDark = Color(0xFF5D1616);

  // Reusable gradient for header & footer
  LinearGradient get _headerFooterGradient => const LinearGradient(
        colors: [
          Color.fromARGB(255, 80, 5, 5), // primary
          Color.fromARGB(255, 243, 203, 84), // tertiary
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  final _pageCtrl = PageController();
  final _slides = const [
    _Slide('assets/1.png', 'Book Top Venues', 'Fast, simple, reliable.'),
    _Slide('assets/2.png', 'Play With Friends', 'Football, padel, hoops & more.'),
    _Slide('assets/3.png', 'Great Deals Daily', 'Exclusive rates across Bahrain.'),
  ];

  int _page = 0;
  Timer? _auto;

  @override
  void initState() {
    super.initState();
    _auto = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      final next = (_page + 1) % _slides.length;
      _pageCtrl.animateToPage(
        next,
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

  Future<void> _guestLogin() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Guest mode enabled')),
    );
  }

  void _onStartBooking() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => BlocProvider<SignInBloc>(
          create: (ctx) => SignInBloc(
            ctx.read<AuthenticationBloc>().userRepository,
          ),
          child: const HomeScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Stack(
        children: [
          // background blobs
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
              // ===== HEADER (gradient) =====
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(gradient: _headerFooterGradient),
                  child: SafeArea(
                    bottom: false,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: _maxWidth),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: _Header(
                            maroon: kMaroon,
                            maroonDark: kMaroonDark,
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

              // ===== HERO SLIDESHOW + CTA =====
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: _maxWidth),
                    child: _Hero(
                      pageCtrl: _pageCtrl,
                      slides: _slides,
                      page: _page,
                      onChanged: (i) => setState(() => _page = i),
                      onStartBooking: _onStartBooking,
                      maroon: kMaroon,
                      maroonDark: kMaroonDark,
                    ),
                  ),
                ),
              ),

              // ===== ABOUT =====
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

              // ===== FOOTER (gradient) =====
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(gradient: _headerFooterGradient),
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: _maxWidth),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: _Footer(),
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

/* ---------------- HEADER ---------------- */
class _Header extends StatelessWidget {
  const _Header({
    required this.maroon,
    required this.maroonDark,
    required this.onSignIn,
    required this.onSignUp,
    required this.onGuest,
  });

  final Color maroon;
  final Color maroonDark;
  final VoidCallback onSignIn;
  final VoidCallback onSignUp;
  final VoidCallback onGuest;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1000;

    return Row(
      children: [
        // Logo + brand
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/0.png', height: 36),
            const SizedBox(width: 10),
            if (isDesktop)
              Text(
                'BookNow',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800, color: Colors.white),
              ),
          ],
        ),
        const Spacer(),
        _IconAction(
          icon: Icons.login_rounded,
          label: 'Sign in',
          onTap: onSignIn,
          bg: Colors.white,
          fg: maroon,
          border: Colors.transparent,
        ),
        const SizedBox(width: 8),
        _IconAction(
          icon: Icons.person_add_alt_1_rounded,
          label: 'Sign up',
          onTap: onSignUp,
          bg: Colors.transparent,
          fg: Colors.white,
          border: Colors.white70,
        ),
        const SizedBox(width: 8),
        _IconAction(
          icon: Icons.person_outline_rounded,
          label: 'Guest',
          onTap: onGuest,
          bg: Colors.white,
          fg: maroon,
          border: Colors.transparent,
        ),
      ],
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.bg,
    required this.fg,
    required this.border,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color bg;
  final Color fg;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bg,
      shape: StadiumBorder(
        side: BorderSide(color: border, width: border == Colors.transparent ? 0 : 1.2),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: fg),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: fg, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

/* ---------------- HERO ---------------- */
class _Hero extends StatelessWidget {
  const _Hero({
    required this.pageCtrl,
    required this.slides,
    required this.page,
    required this.onChanged,
    required this.onStartBooking,
    required this.maroon,
    required this.maroonDark,
  });

  final PageController pageCtrl;
  final List<_Slide> slides;
  final int page;
  final ValueChanged<int> onChanged;
  final VoidCallback onStartBooking;
  final Color maroon;
  final Color maroonDark;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1000;

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
                controller: pageCtrl,
                onPageChanged: onChanged,
                itemCount: slides.length,
                itemBuilder: (_, i) {
                  final s = slides[i];
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
                      Align(
                        alignment: isDesktop ? Alignment.centerLeft : Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.all(isDesktop ? 32 : 20),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 520),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.headline,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isDesktop ? 44 : 28,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  s.sub,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: isDesktop ? 18 : 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // CTA button
           Align(
                    alignment: Alignment.center, // just in case it's inside a wide parent
                    child: ElevatedButton(
                      onPressed: onStartBooking,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,                 // gradient fills exactly
                        backgroundColor: Colors.transparent,      // let gradient show
                        elevation: 6,
                        shape: const StadiumBorder(),
                        minimumSize: const Size(0, 0),            // <-- no min width
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shadowColor: Colors.black54,
                      ),
                      child: Ink(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 80, 5, 5),
                              Color.fromARGB(255, 243, 203, 84),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 28 : 22,
                            vertical: isDesktop ? 16 : 12,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min, // <-- keeps it compact
                            children: const [
                              Icon(Icons.sports_soccer_rounded, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Start booking',
                                style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  ,
            // page dots
            Positioned(
              bottom: 10,
              child: Row(
                children: List.generate(
                  slides.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: i == page ? 26 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(i == page ? 0.95 : 0.6),
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

class _Slide {
  final String asset;
  final String headline;
  final String sub;
  const _Slide(this.asset, this.headline, this.sub);
}

/* ---------------- ABOUT ---------------- */
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
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4),
            ),
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
      children: imageLeft
          ? [image, const SizedBox(width: 24), copy]
          : [copy, const SizedBox(width: 24), image],
    );
  }
}

/* ---------------- FOOTER ---------------- */
class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 900;

    final socials = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Social(icon: Icons.facebook, onTap: () {}),
        const SizedBox(width: 10),
        _Social(icon: Icons.camera_alt, onTap: () {}), // Instagram-like
        const SizedBox(width: 10),
        _Social(icon: Icons.alternate_email, onTap: () {}), // X/Twitter-ish
      ],
    );

    final contact = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Contact Us',
            style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
        SizedBox(height: 6),
        Text('Al Ahli Club, Zinj, Manama, Kingdom of Bahrain',
            style: TextStyle(color: Colors.white)),
      ],
    );

    final copy = Text(
      '© ${DateTime.now().year} BookNow • All rights reserved',
      style: const TextStyle(color: Colors.white70),
    );

    if (!isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          socials,
          const SizedBox(height: 16),
          contact,
          const SizedBox(height: 16),
          copy,
        ],
      );
    }

    return Row(
      children: [
        socials,
        const Spacer(),
        contact,
        const Spacer(),
        copy,
      ],
    );
  }
}

class _Social extends StatelessWidget {
  const _Social({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(side: BorderSide(color: Colors.white70)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}
