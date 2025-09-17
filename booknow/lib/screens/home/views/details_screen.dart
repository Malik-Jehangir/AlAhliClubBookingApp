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
  DateTime? _when;

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 15, minute: 45),
    );
    if (time == null) return;

    setState(() {
      _when = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  String _fmt(DateTime dt) {
    final dd = dt.day.toString().padLeft(2, '0');
    final mm = dt.month.toString().padLeft(2, '0');
    final yyyy = dt.year.toString();
    final h12 = (dt.hour % 12 == 0) ? 12 : dt.hour % 12;
    final mmn = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'pm' : 'am';
    return "$h12:$mmn$ampm on $dd.$mm.$yyyy";
  }

  @override
  Widget build(BuildContext context) {
    final venue = widget.venue;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(3, 3),
                            blurRadius: 5,
                          )
                        ],
                        image: DecorationImage(
                          image: AssetImage('assets/${venue.imageNumber}.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            offset: const Offset(3, 3),
                            blurRadius: 5,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    venue.description,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${venue.price} BHD",
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${venue.originPrice} BHD",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: const [
                                MyMacroWidget(
                                    title: 'Players',
                                    value: 8,
                                    icon: FontAwesomeIcons.person),
                                SizedBox(width: 10),
                                MyMacroWidget(
                                    title: 'Specs',
                                    value: 200,
                                    icon: FontAwesomeIcons.peopleGroup),
                                SizedBox(width: 10),
                                MyMacroWidget(
                                    title: 'Seats',
                                    value: 200,
                                    icon: FontAwesomeIcons.chair),
                                SizedBox(width: 10),
                                MyMacroWidget(
                                    title: 'Hours',
                                    value: 2,
                                    icon: FontAwesomeIcons.clock),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ListTile(
                              onTap: _pickDateTime,
                              leading: const Icon(Icons.event),
                              title: Text(_when == null
                                  ? 'Pick date & time'
                                  : _fmt(_when!)),
                              tileColor: Colors.grey.shade100,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: TextButton(
                                onPressed: () {
                                  if (_when == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Please pick a date & time')),
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "Book Now",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
