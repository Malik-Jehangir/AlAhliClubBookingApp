export 'venue.dart';


class Venue { //Model
  final String status;
  final int imageNumber;
  final String location;
  final String activity;
  final String description;
  final int price;   
  final int originPrice;     

  const Venue({ //Constructor
    required this.status,
    required this.imageNumber,
    required this.location,
    required this.activity,
    required this.description,
    required this.price,
    required this.originPrice,
  });
}
