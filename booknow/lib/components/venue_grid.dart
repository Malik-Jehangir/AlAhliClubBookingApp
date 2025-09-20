import 'package:booknow/screens/home/views/details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class VenueGrid extends StatelessWidget {
  final List<Venue> venues;
  const VenueGrid({super.key, required this.venues});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;

        // Simple responsive breakpoints
        // You can tweak these numbers to taste.
        double maxTileWidth;
        double aspectRatio;
        EdgeInsets padding;

        if (w >= 1200) {
          maxTileWidth = 360;     // desktop: a bit wider
          aspectRatio = 3 / 4;    // less tall than phones
          padding = const EdgeInsets.all(24);
        } else if (w >= 800) {
          maxTileWidth = 340;     // tablet landscape/small desktop
          aspectRatio = 2.8 / 4;  // slightly taller
          padding = const EdgeInsets.all(20);
        } else {
          maxTileWidth = 320;     // phones/tablets
          aspectRatio = 9 / 16;   // phone-friendly card
          padding = const EdgeInsets.all(16);
        }

        return Scrollbar(
          thumbVisibility: true,
          child: Padding(
            padding: padding,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: maxTileWidth,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: aspectRatio,
              ),
              itemCount: venues.length,
              itemBuilder: (context, int i) {
                final v = venues[i];
                final card = _VenueCard(v: v);
                return card;
              },
            ),
          ),
        );
      },
    );
  }
}

class _VenueCard extends StatelessWidget {
  const _VenueCard({required this.v});
  final Venue v;

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).brightness == Brightness.dark
        ? Theme.of(context).colorScheme.surface
        : Colors.white;

    return Material(
      elevation: 2,
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (_) => DetailsScreen(venue: v)),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset('assets/${v.imageNumber}.png', fit: BoxFit.cover),
              ),
            ),

            const SizedBox(height: 12),

            // Status + Location chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Text(
                        v.status,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Text(
                      v.location,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                v.activity,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 13, // slightly larger for desktop too
                ),
              ),
            ),

            // Description fills available space
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  v.description,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w300,
                    fontSize: 9,
                    height: 1.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  softWrap: true,
                ),
              ),
            ),

            // Price row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
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
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "${v.originPrice} BHD",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 32,
                    height: 32,
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
  }
}
