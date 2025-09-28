// lib/screens/home/views/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

// nav + static pages
import 'package:booknow/screens/auth/views/auth_page.dart';
import 'package:booknow/screens/auth/views/welcome_screen.dart';
import 'package:booknow/screens/home/views/home_screen.dart';
import 'package:booknow/screens/static/about_us_screen.dart';
import 'package:booknow/screens/static/contact_us_screen.dart';

enum PaymentMethod { onSite, online }

class CheckoutScreen extends StatefulWidget {
  final Venue venue;
  final DateTime dateTime;

  const CheckoutScreen({
    super.key,
    required this.venue,
    required this.dateTime,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const double _maxWidth = 1100;

  PaymentMethod _method = PaymentMethod.onSite;

  // shared gradient
  LinearGradient get _headerFooterGradient => const LinearGradient(
        colors: [Color(0xFF500505), Color(0xFFF3CB54)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  String _fmtDate(DateTime d) =>
      "${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
  String _fmtTime(DateTime d) =>
      "${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    final v = widget.venue;
    final d = widget.dateTime;

    // ===== NEW: Taller toolbar + computed logo height (matches other screens)
    final isDesktopBar = MediaQuery.of(context).size.width >= 900;
    final barHeight = isDesktopBar ? 84.0 : 64.0;
    const vPad = 12.0;
    final logoH = barHeight - (vPad * 2);

    // --------- MAIN CONTENT WIDGETS (unchanged) ---------
    final summaryCard = Material(
      elevation: 2,
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/${v.imageNumber}.png',
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${v.activity} • ${v.location}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text("${_fmtDate(d)}  ${_fmtTime(d)}",
                          style: TextStyle(
                              color: Colors.grey.shade700, fontSize: 14)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            "${v.price} BHD",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${v.originPrice} BHD",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                v.description,
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
          ],
        ),
      ),
    );

    final paymentCard = Material(
      elevation: 2,
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          RadioListTile<PaymentMethod>(
            title: const Text('Pay on site'),
            value: PaymentMethod.onSite,
            groupValue: _method,
            onChanged: (v) => setState(() => _method = v!),
          ),
          const Divider(height: 0),
          RadioListTile<PaymentMethod>(
            title: const Text('Pay online'),
            value: PaymentMethod.online,
            groupValue: _method,
            onChanged: (v) => setState(() => _method = v!),
          ),
        ],
      ),
    );

    final confirmButton = SizedBox(
      width: double.infinity,
      height: 50,
      child: TextButton(
        onPressed: () async {
          await showDialog<void>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Booking Confirmed'),
              content: const Text(
                'An email will be sent to your inbox shortly.\n\nThanks for booking with Book Now!',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          if (mounted) Navigator.of(context).pop();
        },
        style: TextButton.styleFrom(
          elevation: 3.0,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text(
          "Confirm Payment",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
    );

    // --------- PAGE WITH SAME HEADER + FOOTER ---------
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          // HEADER
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            toolbarHeight: barHeight, // <-- important to allow a larger logo
            flexibleSpace: Container(
              decoration: BoxDecoration(gradient: _headerFooterGradient),
              child: SafeArea(
                bottom: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: vPad),
                      child: _NavBar(
                        logoHeight: logoH, // <-- pass computed height
                        onLogoTap: () => Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                          (r) => false,
                        ),
                        onHome: () => Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                          (r) => false,
                        ),
                        onAbout: () => Navigator.push(
                          context, MaterialPageRoute(builder: (_) => const AboutUsScreen())),
                        onBook: () => Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                          (r) => false,
                        ),
                        onContact: () => Navigator.push(
                          context, MaterialPageRoute(builder: (_) => const ContactUsScreen())),
                        onSignIn: () => Navigator.of(context).push(AuthPage.route(AuthMode.signIn)),
                        onSignUp: () => Navigator.of(context).push(AuthPage.route(AuthMode.signUp)),
                        onGuest: () => ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text('Guest mode enabled'))),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // CONTENT
          SliverToBoxAdapter(
            child: LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;
                final isDesktop = w >= 1000;

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: _maxWidth),
                    child: Padding(
                      padding: EdgeInsets.all(isDesktop ? 24 : 20),
                      child: isDesktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // LEFT: summary
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    children: [
                                      summaryCard,
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                // RIGHT: payment + button
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: [
                                      paymentCard,
                                      const SizedBox(height: 24),
                                      confirmButton,
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                summaryCard,
                                const SizedBox(height: 20),
                                paymentCard,
                                const SizedBox(height: 24),
                                confirmButton,
                              ],
                            ),
                    ),
                  ),
                );
              },
            ),
          ),

          // FOOTER
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(gradient: _headerFooterGradient),
              padding: const EdgeInsets.only(top: 28, bottom: 12),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: const [
                        _FooterColumns(),         // 0.png + three sections
                        SizedBox(height: 20),
                        _FooterBookNow(),         // CTA card (click does nothing here)
                        SizedBox(height: 18),
                        Divider(color: Colors.white24, height: 1),
                        SizedBox(height: 10),
                        _FooterBottomBar(),
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

/* ---------------- shared header/footer widgets ---------------- */

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
              Image.asset('assets/0.png', height: logoHeight), // <-- was 56
              const SizedBox(width: 10),
              const Text(
                'Al Ahli Club',
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
  const _FooterColumns();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    final left = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/0.png', height: 104),
      ],
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
  const _FooterBookNow();

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
              onPressed: () {}, // no-op here
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
