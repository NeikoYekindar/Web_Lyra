import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyra/navigation/profile_action.dart';
import 'package:lyra/l10n/app_localizations.dart';


class ProfileNavigatorMenu extends StatelessWidget {
  final void Function(ProfileAction action) onSelect;

  const ProfileNavigatorMenu({super.key, required this.onSelect});

  void _select(BuildContext context, ProfileAction action) {
    Navigator.of(context).maybePop();
    onSelect(action);
  }

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.transparent,
      elevation: 12,
      shadowColor: Colors.black54,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _MenuItem(
              label: AppLocalizations.of(context)!.dashboard,
              trailing: Icons.open_in_new_rounded,
              onPressed: () => _select(context, ProfileAction.dashboard),
            ),
            _MenuItem(
              label: AppLocalizations.of(context)!.profile,
              onPressed: () => _select(context, ProfileAction.profile),
            ),
            _MenuItem(
              label: AppLocalizations.of(context)!.support,
              trailing: Icons.open_in_new_rounded,
              onPressed: () => _select(context, ProfileAction.support),
            ),
            _MenuItem(
              label: AppLocalizations.of(context)!.settings,
              onPressed: () => _select(context, ProfileAction.settings),
            ),

            // Divider
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(vertical: 6),
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),

            _MenuItem(
              label: AppLocalizations.of(context)!.logout,
              color: Colors.red[300],
              onPressed: () => _select(context, ProfileAction.logout),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------

class _MenuItem extends StatefulWidget {
  final String label;
  final IconData? trailing;
  final VoidCallback? onPressed;
  final Color? color;

  const _MenuItem({
    required this.label,
    this.trailing,
    this.onPressed,
    this.color,
  });

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  bool _hovering = false;
  bool _pressed = false;

  Color _bg(BuildContext context) {
    if (_pressed) {
      return Theme.of(context).colorScheme.tertiary.withOpacity(0.15);
    }
    if (_hovering) {
      return Theme.of(context).colorScheme.tertiary.withOpacity(0.08);
    }
    return Colors.transparent;
  }

  Color _textColor(BuildContext context) {
    if (widget.color != null) return widget.color!;
    if (_pressed) return Theme.of(context).colorScheme.onSurface;
    if (_hovering) {
      return Theme.of(context).colorScheme.onSurface.withOpacity(0.8);
    }
    return Theme.of(context).colorScheme.onSurfaceVariant;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() {
        _hovering = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onPressed?.call();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(color: _bg(context)),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.label,
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: _textColor(context),
                  ),
                ),
              ),
              if (widget.trailing != null)
                Icon(widget.trailing, size: 18, color: _textColor(context)),
            ],
          ),
        ),
      ),
    );
  }
}
