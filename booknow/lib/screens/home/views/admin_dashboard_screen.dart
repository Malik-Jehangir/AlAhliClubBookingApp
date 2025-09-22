
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late final List<DateTime> _days;   // last N days
  late final List<int> _bookings;    // fake bookings data per day
  late final int _totalBookings;
  late final int _todayBookings;
  late final double _monthRevenue;   // fake revenue summary

  @override
  void initState() {
    super.initState();
    _generateFakeData(days: 14);
  }

  void _generateFakeData({int days = 14}) {
    final now = DateTime.now();
    _days = List.generate(days, (i) => DateTime(now.year, now.month, now.day).subtract(Duration(days: days - 1 - i)));

    final rnd = Random(42);
    _bookings = List<int>.generate(days, (_) => 5 + rnd.nextInt(25)); // 5–29 bookings/day
    _totalBookings = _bookings.fold(0, (a, b) => a + b);
    _todayBookings = _bookings.last;

    // Totally fake revenue: sum * average ticket (e.g., 60 BHD)
    _monthRevenue = _totalBookings * 60.0;
  }

  @override
  Widget build(BuildContext context) {
    final dateFmtShort = DateFormat('MMMd'); // e.g., Sep 22
    final theme = Theme.of(context);
    final lineSpots = <FlSpot>[
      for (int i = 0; i < _bookings.length; i++) FlSpot(i.toDouble(), _bookings[i].toDouble())
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: theme.colorScheme.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ---- KPI cards -------------------------------------------------
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _KpiCard(
                    title: 'Total bookings',
                    value: '$_totalBookings',
                    subtitle: 'Last ${_days.length} days',
                    icon: Icons.event_available,
                    color: Colors.green,
                  ),
                  _KpiCard(
                    title: 'Today',
                    value: '$_todayBookings',
                    subtitle: DateFormat('EEE, MMM d').format(_days.last),
                    icon: Icons.today,
                    color: Colors.blue,
                  ),
                  _KpiCard(
                    title: 'Est. revenue',
                    value: '${_monthRevenue.toStringAsFixed(0)} BHD',
                    subtitle: 'Assuming 60 BHD avg',
                    icon: Icons.attach_money,
                    color: Colors.amber.shade800,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ---- Line chart ------------------------------------------------
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 260,
                    child: LineChart(
                      LineChartData(
                        minY: 0,
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true, reservedSize: 34),
                          ),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 2,
                              getTitlesWidget: (value, meta) {
                                final i = value.toInt();
                                if (i < 0 || i >= _days.length) return const SizedBox.shrink();
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(dateFmtShort.format(_days[i]), style: const TextStyle(fontSize: 11)),
                                );
                              },
                            ),
                          ),
                        ),
                        gridData: FlGridData(show: true, drawVerticalLine: false),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: lineSpots,
                            isCurved: true,
                            barWidth: 3,
                            dotData: const FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ---- Summary block --------------------------------------------
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DefaultTextStyle(
                    style: theme.textTheme.bodyMedium!,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Summary', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Text('• Bookings are trending steady over the last ${_days.length} days.'),
                        Text('• Peak day: ${_peakDayLabel(dateFmtShort)} with ${_bookings.reduce(max)} bookings.'),
                        Text('• Consider promotions on low-traffic days to smooth the curve.'),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ---- Recent bookings table (fake) ------------------------------
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: _RecentBookingsTable(days: _days, bookings: _bookings),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _peakDayLabel(DateFormat fmt) {
    final maxVal = _bookings.reduce(max);
    final idx = _bookings.indexOf(maxVal);
    return fmt.format(_days[idx]);
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 220, // makes Wrap layout nicely on web + mobile
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.12),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.labelMedium?.copyWith(color: Colors.grey[700])),
                    const SizedBox(height: 4),
                    Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentBookingsTable extends StatelessWidget {
  final List<DateTime> days;
  final List<int> bookings;

  const _RecentBookingsTable({required this.days, required this.bookings});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('EEE, MMM d');
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Bookings')),
          DataColumn(label: Text('Top Venue')),
          DataColumn(label: Text('Notes')),
        ],
        rows: List<DataRow>.generate(days.length, (i) {
          return DataRow(
            cells: [
              DataCell(Text(fmt.format(days[i]))),
              DataCell(Text(bookings[i].toString())),
              DataCell(Text(_fakeVenue(i))),
              const DataCell(Text('OK')),
            ],
          );
        }),
      ),
    );
  }

  static String _fakeVenue(int i) {
    const venues = [
      'Riffa Court', 'Isa Town Turf', 'Juffair Padel', 'Muharraq Arena',
      'Saar Badminton', 'Adliya Tennis', 'Hamad Nets', 'Seef Pool',
      'Sanabis TT', 'Hidd Squash', 'Tubli Yoga', 'Manama Dance',
    ];
    return venues[i % venues.length];
  }
}
