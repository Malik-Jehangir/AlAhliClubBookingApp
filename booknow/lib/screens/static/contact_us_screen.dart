// lib/screens/static/contact_us_screen.dart
import 'package:flutter/material.dart';

// Adjust these imports to your paths if needed:
import 'package:booknow/screens/auth/views/welcome_screen.dart';
import 'package:booknow/screens/static/about_us_screen.dart';
import 'package:booknow/screens/home/views/home_screen.dart';
import 'package:booknow/screens/auth/views/auth_page.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  static const double _maxWidth = 1200;
  static const kMaroon = Color(0xFF500505);
  static const kGold = Color(0xFFF3CB54);

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  LinearGradient get _headerFooterGradient => const LinearGradient(
        colors: [kMaroon, kGold],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  Future<void> _guestLogin() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Guest mode enabled')),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final barHeight = isDesktop ? 84.0 : 64.0; // taller toolbar
    const vPad = 12.0;
    final logoH = barHeight - (vPad * 2); // image fills the bar height

    return Scaffold(
      // subtle background ornaments
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          Positioned(
            top: -120,
            left: -80,
            child: Container(
              width: 300, height: 300,
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
              width: 360, height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kGold.withOpacity(0.08),
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              // ===== HEADER (same as Welcome) =====
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
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
                            onLogoTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                                (r) => false,
                              );
                            },
                            onHome: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                                (r) => false,
                              );
                            },
                            onAbout: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const AboutUsScreen()),
                              );
                            },
                            onBook: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) => const HomeScreen()),
                                (r) => false,
                              );
                            },
                            onContact: () {
                              // stay here
                            },
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

              // ===== HERO STRIP =====
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: _maxWidth),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 28, 20, 8),
                      child: _HeroBanner(),
                    ),
                  ),
                ),
              ),

              // ===== BODY =====
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: _maxWidth),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      child: _FormAndInfo(
                        formKey: _formKey,
                        nameCtrl: _nameCtrl,
                        emailCtrl: _emailCtrl,
                        phoneCtrl: _phoneCtrl,
                        subjectCtrl: _subjectCtrl,
                        messageCtrl: _messageCtrl,
                      ),
                    ),
                  ),
                ),
              ),

              // ===== FOOTER (same as Welcome/About) =====
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
                                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                                  (r) => false,
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            _FooterBookNow(
                              onFind: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (_) => const HomeScreen()),
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

/* ---------------- NAVBAR ---------------- */
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
            children: [
              Image.asset('assets/0.png', height: logoHeight), // use computed height
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
        TextButton(onPressed: onHome, child: Text('Home', style: _linkStyle(false))),
        TextButton(onPressed: onAbout, child: Text('About Us', style: _linkStyle(false))),
        TextButton(onPressed: onBook, child: Text('Book', style: _linkStyle(false))),
        TextButton(onPressed: onContact, child: Text('Contact Us', style: _linkStyle(false))),
        const SizedBox(width: 12),
        TextButton(onPressed: onSignIn, child: Text('Sign In', style: _linkStyle(false))),
        TextButton(onPressed: onSignUp, child: Text('Sign Up', style: _linkStyle(false))),
        TextButton(onPressed: onGuest, child: Text('Guest', style: _linkStyle(false))),
      ],
    );
  }
}

/* ---------------- HERO BANNER ---------------- */
class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

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
                opacity: 0.12,
                child: Image.asset('assets/2.png', fit: BoxFit.cover),
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
                          'Contact Al Ahli Club',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isDesktop ? 44 : 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Questions, bookings, or partnerships—we’re here to help.',
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

/* ---------------- BODY (Form + Info) ---------------- */
// NOTE: This is the crash-safe layout.
// It never uses Expanded inside unconstrained parents and splits rows only on wide screens.
class _FormAndInfo extends StatelessWidget {
  const _FormAndInfo({
    required this.formKey,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.subjectCtrl,
    required this.messageCtrl,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController subjectCtrl;
  final TextEditingController messageCtrl;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 980;

    final form = _ContactForm(
      formKey: formKey,
      nameCtrl: nameCtrl,
      emailCtrl: emailCtrl,
      phoneCtrl: phoneCtrl,
      subjectCtrl: subjectCtrl,
      messageCtrl: messageCtrl,
    );

    const info = _ContactInfoPane();

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(flex: 6, child: form),
          const SizedBox(width: 24),
          Flexible(flex: 5, child: info),
        ],
      );
    }

    return Column(
      children: [
        form,
        const SizedBox(height: 24),
        info,
      ],
    );
  }
}

/* ---------------- CONTACT FORM ---------------- */
// (unchanged below)
class _ContactForm extends StatelessWidget {
  const _ContactForm({
    required this.formKey,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.subjectCtrl,
    required this.messageCtrl,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController subjectCtrl;
  final TextEditingController messageCtrl;

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300),
    );

    Widget _pair(Widget a, Widget b) {
      final wide = MediaQuery.of(context).size.width >= 700;
      if (wide) {
        return Row(
          children: [
            Expanded(child: a),
            const SizedBox(width: 12),
            Expanded(child: b),
          ],
        );
      }
      return Column(
        children: [
          a,
          const SizedBox(height: 12),
          b,
        ],
      );
    }

    final nameField = TextFormField(
      controller: nameCtrl,
      decoration: InputDecoration(
        labelText: 'Your name',
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
    );

    final emailField = TextFormField(
      controller: emailCtrl,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email address',
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
      validator: (v) {
        final val = v?.trim() ?? '';
        final ok = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(val);
        return ok ? null : 'Enter a valid email';
      },
    );

    final phoneField = TextFormField(
      controller: phoneCtrl,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Phone (optional)',
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
    );

    final subjectField = TextFormField(
      controller: subjectCtrl,
      decoration: InputDecoration(
        labelText: 'Subject',
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter a subject' : null,
    );

    final messageField = TextFormField(
      controller: messageCtrl,
      minLines: 5,
      maxLines: 10,
      decoration: InputDecoration(
        labelText: 'Message',
        alignLabelWithHint: true,
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your message' : null,
    );

    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.mail_outline_rounded),
                  const SizedBox(width: 8),
                  Text(
                    'Send us a message',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _pair(nameField, emailField),
              const SizedBox(height: 12),

              _pair(phoneField, subjectField),
              const SizedBox(height: 12),

              messageField,
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Form validated (send is disabled).'),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.send_rounded),
                      label: const Text('Send Message'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ---------------- INFO PANE ---------------- */
class _ContactInfoPane extends StatelessWidget {
  const _ContactInfoPane();

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration:
            BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.info_outline_rounded),
              const SizedBox(width: 8),
              Text('Club Information',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      )),
            ]),
            const SizedBox(height: 12),
            _infoLine(Icons.location_on_outlined,
                'Al Ahli Club, Zinj, Manama, Kingdom of Bahrain', textColor: Colors.black),
            const SizedBox(height: 8),
            _infoLine(Icons.schedule_outlined, 'Office Hours: 9:00 AM – 6:00 PM, Sun–Thu', textColor: Colors.black),
            const SizedBox(height: 8),
            _infoLine(Icons.phone_in_talk_outlined, '+973 1727 7712', textColor: Colors.black),
            const SizedBox(height: 8),
            _infoLine(Icons.email_outlined, 'info@alahliclub.bh', textColor: Colors.black),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            const Text(
              'Why contact us?',
              style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black),
            ),
            const SizedBox(height: 8),
            _bullet('Venue bookings and availability', textColor: Colors.black),
            _bullet('Team registrations and leagues', textColor: Colors.black),
            _bullet('Coaching programs and holiday camps', textColor: Colors.black),
            _bullet('Partnerships, sponsorships, and events', textColor: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _infoLine(IconData icon, String text, {Color textColor = Colors.black}) {
    return Row(
      children: [
        Icon(icon, color: Colors.black),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ],
    );
  }

  Widget _bullet(String text, {Color textColor = Colors.black}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("• ", style: TextStyle(color: Colors.black)),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ],
    );
  }
}

/* ---------------- FOOTER (same pattern as Welcome/About) ---------------- */
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
        children: const [
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
