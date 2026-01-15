import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lyra/providers/locale_provider.dart';

class LanguageDropdown extends StatefulWidget {
  const LanguageDropdown({super.key});

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  bool isHovering = false;
  final LayerLink layerLink = LayerLink();
  OverlayEntry? entry;

  final List<String> languages = const [
    "English (United Kingdom)",
    "Tiếng Việt (Việt Nam)",
  ];

  // Map Locale -> label
  String _labelFromLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'vi':
        return "Tiếng Việt (Việt Nam)";
      default:
        return "English (United Kingdom)";
    }
  }

  // Map label -> Locale
  void _setLocaleFromLabel(String label) {
    final locale = label.startsWith("English")
        ? const Locale('en')
        : const Locale('vi');

    context.read<LocaleProvider>().setLocale(locale);
  }

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
              elevation: 4,
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: languages.map((lang) {
                  return InkWell(
                    onTap: () {
                      _setLocaleFromLabel(lang);
                      hideDropdown();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Text(
                        lang,
                        style: GoogleFonts.inter(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant,
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
  void dispose() {
    hideDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        final currentLabel =
            _labelFromLocale(localeProvider.locale);

        return MouseRegion(
          onEnter: (_) => setState(() => isHovering = true),
          onExit: (_) => setState(() => isHovering = false),
          child: CompositedTransformTarget(
            link: layerLink,
            child: GestureDetector(
              onTap: () {
                entry == null ? showDropdown() : hideDropdown();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isHovering
                      ? Theme.of(context)
                          .colorScheme
                          .secondaryContainer
                      : Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withOpacity(0.05),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      currentLabel,
                      style: GoogleFonts.inter(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
