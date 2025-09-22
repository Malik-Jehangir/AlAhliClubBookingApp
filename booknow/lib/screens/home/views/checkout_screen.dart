import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

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
  PaymentMethod _method = PaymentMethod.onSite;

  // --- Reusable header/footer gradient (match other screens)
  LinearGradient get _headerFooterGradient => const LinearGradient(
        colors: [
          Color.fromARGB(255, 80, 5, 5),      // primary
          Color.fromARGB(255, 243, 203, 84),  // tertiary
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  String _fmtDate(DateTime d) =>
      "${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
  String _fmtTime(DateTime d) =>
      "${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";

  static const double _maxWidth = 1100;

  @override
  Widget build(BuildContext context) {
    final v = widget.venue;
    final d = widget.dateTime;

    Widget summaryCard = Material(
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

    Widget paymentCard = Material(
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

    Widget confirmButton = SizedBox(
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: _headerFooterGradient),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;
          final isDesktop = w >= 1000;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _maxWidth),
              child: SingleChildScrollView(
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
      // Footer with same gradient
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(gradient: _headerFooterGradient),
        child: const Center(
          child: Text(
            '© 2025 BookNow',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
