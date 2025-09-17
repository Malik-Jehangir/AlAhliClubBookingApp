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

  String _fmtDate(DateTime d) =>
      "${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
  String _fmtTime(DateTime d) =>
      "${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    final v = widget.venue;
    final d = widget.dateTime;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Summary Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
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
                            width: 88,
                            height: 88,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${v.activity} • ${v.location}",
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(_fmtDate(d) + "  " + _fmtTime(d),
                                  style: TextStyle(
                                      color: Colors.grey.shade700, fontSize: 14)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text("${v.price} BHD",
                                      style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700)),
                                  const SizedBox(width: 6),
                                  Text("${v.originPrice} BHD",
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.lineThrough,
                                      )),
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
            ),

            const SizedBox(height: 20),

            // Payment options
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
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
            ),

            const SizedBox(height: 24),

            // Confirm Payment
            SizedBox(
              width: MediaQuery.of(context).size.width,
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
                  if (mounted) Navigator.of(context).pop(); // back after OK
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
            ),
          ],
        ),
      ),
    );
  }
}
