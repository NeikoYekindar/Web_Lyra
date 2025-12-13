import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyra/theme/app_theme.dart';

class LanguageDropdown extends StatefulWidget {
  const LanguageDropdown({super.key});

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  String selectedLang = "English (United Kingdom)";
  bool isHovering = false;
  final LayerLink layerLink = LayerLink();
  OverlayEntry? entry;

  final languages = ["English (United Kingdom)", "Tiếng Việt (Việt Nam)"];

  void showDropdown() {
    final overlay = Overlay.of(context);

    entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: 250,
          child: CompositedTransformFollower(
            link: layerLink,
            offset: const Offset(0, 42),
            showWhenUnlinked: false,
            child: Material(
              color: Theme.of(context).colorScheme.secondaryContainer,
              elevation: 4,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: languages.map((lang) {
                  return InkWell(
                    onTap: () {
                      setState(() => selectedLang = lang);
                      hideDropdown();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Text(
                        lang,
                        style: GoogleFonts.inter(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(entry!);
  }

  void hideDropdown() {
    entry?.remove();
    entry = null;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: CompositedTransformTarget(
        link: layerLink,
        child: GestureDetector(
          onTap: () {
            if (entry == null) {
              showDropdown();
            } else {
              hideDropdown();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isHovering
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withOpacity(0.05),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedLang,
                  style: GoogleFonts.inter(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
