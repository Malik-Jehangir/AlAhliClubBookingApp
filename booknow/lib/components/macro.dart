import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyMacroWidget extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;

  const MyMacroWidget({
    required this.title,
    required this.value,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 120),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, color: Colors.redAccent),
            const SizedBox(height: 6),
            Text(
              '$value $title',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

// tiny data class to feed the row
class MacroItem {
  final String title;
  final int value;
  final IconData icon;
  const MacroItem(this.title, this.value, this.icon);
}

// Responsive container that lays out MyMacroWidget items using Wrap
class ResponsiveMacros extends StatelessWidget {
  final List<MacroItem> items;
  const ResponsiveMacros({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final spacing = w >= 1000 ? 14.0 : 10.0;
        final runSpacing = spacing;
        final itemWidth = w >= 1000 ? 180.0 : 150.0;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: items
              .map((m) => SizedBox(
                    width: itemWidth,
                    child: MyMacroWidget(
                      title: m.title,
                      value: m.value,
                      icon: m.icon,
                    ),
                  ))
              .toList(),
        );
      },
    );
  }
}
