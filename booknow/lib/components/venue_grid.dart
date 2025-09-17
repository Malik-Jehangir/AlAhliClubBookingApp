import 'package:booknow/screens/home/views/details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';


class VenueGrid extends StatelessWidget {
final List<Venue> venues;

  const VenueGrid({super.key, required this.venues});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 9/16), itemCount: venues.length, itemBuilder: (context, int i){ //for looping through elements list
            final v = venues[i];
            return Material(
              elevation:3,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute<void>(builder: (_)=>DetailsScreen(venue: v)));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                       ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    child: AspectRatio(
                      aspectRatio: 16/9,
                      child: Image.asset('assets/${v.imageNumber}.png', fit: BoxFit.cover),
                    ),
                  ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(children: [                      
                        Flexible(
                          child: Container(
                            decoration:BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(30)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
                              child: Text(
                                v.status,
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 10
                                ),
                                overflow: TextOverflow.ellipsis, // safe text
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                         Container(
                          decoration:BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(30)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
                            child: Text(
                              v.location,
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w800,
                                fontSize: 10
                              ),
                              overflow: TextOverflow.ellipsis, // safe text  
                            ),
                          ),
                        )
                      ],),
                    ),
                    const SizedBox(height: 8),
                    Padding( 
                     padding: const EdgeInsets.symmetric(horizontal: 12.0),
                     child: Text(
                      v.activity,
                      style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12
                              ),
                     )
                    ),
                    Padding( 
                     padding: const EdgeInsets.symmetric(horizontal: 12.0),
                     child: Expanded(
                      flex: 2,
                       child: Text(
                        v.description,
                        style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 8
                                ),
                         overflow: TextOverflow.ellipsis, // safe text  
                       ),
                     )
                    ),
                    Padding( 
                     padding: const EdgeInsets.symmetric(horizontal: 12.0),
                     child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Row(
                         children: [
                          Text(
                          "${v.price} BHD",
                          style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16
                                  ),
                         ),
                         const SizedBox(width: 3),
                          Text(
                          "${v.originPrice} BHD",
                          style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    decoration: TextDecoration.lineThrough
                                  ),
                         ),
                         ]
                       ),
                       SizedBox(
                        width: 32, height: 32,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(CupertinoIcons.add_circled_solid, size: 20),
                          onPressed: () {},
                        ),
                      ),
                       ],
                     ),
                    ),
                  ],
                ),
              ),
            );
        }),
      );
  }
}