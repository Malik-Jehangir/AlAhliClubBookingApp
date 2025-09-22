import 'package:booknow/components/venue_grid.dart';
import 'package:booknow/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const double _contentMaxWidth = 1200; // <= cap desktop width

  // define your gradient once so it's reusable
  LinearGradient get _headerFooterGradient => const LinearGradient(
        colors: [
          Color.fromARGB(255, 80, 5, 5),
          Color.fromARGB(255, 243, 203, 84),
        ],
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

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: _headerFooterGradient),
        ),
        title: Row(
          children: [
            Image.asset('assets/0.png', scale: 13),
            const SizedBox(width: 8),
            const Text('Venues', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30)),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.cart)),
          IconButton(
            onPressed: () => context.read<SignInBloc>().add(SignOutRequired()),
            icon: const Icon(CupertinoIcons.arrow_right_to_line),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
          child: VenueGrid(venues: venues),
        ),
      ),
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
