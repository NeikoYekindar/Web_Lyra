import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyra/navigation/middle_nav_key.dart';
import 'package:lyra/screens/profile_screen.dart';
import 'package:lyra/screens/settings_screen.dart';
import 'package:lyra/screens/dashboard_screen.dart';
import 'package:lyra/screens/welcome_screen.dart';

class ProfileNavigatorMenu extends StatelessWidget {
  final void Function(String action)? onSelect;

  const ProfileNavigatorMenu({super.key, this.onSelect});

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
              label: "Account",
              trailing: Icons.open_in_new_rounded,
              onPressed: () => _doSelect(context, "account"),
            ),
            _MenuItem(
              label: "Profile",
              onPressed: () => _doSelect(context, "profile"),
            ),
            _MenuItem(
              label: "Support",
              trailing: Icons.open_in_new_rounded,
              onPressed: () => _doSelect(context, "support"),
            ),
            _MenuItem(
              label: "Settings",
              onPressed: () => _doSelect(context, "settings"),
            ),

            // Divider
            Container(
              height: 1,
              width: double.infinity,
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              margin: const EdgeInsets.symmetric(vertical: 6),
            ),

            _MenuItem(
              label: "Log out",
              color: Colors.red[300],
              onPressed: () => _doSelect(context, "logout"),
            ),
          ],
        ),
      ),
    );
  }

  void _doSelect(BuildContext context, String action) {
    if (onSelect != null) {
      // close popup/menu if any, then call custom handler
      Navigator.of(context).maybePop();
      onSelect!(action);
      return;
    }

    // close popup/menu if any
    Navigator.of(context).maybePop();

    // default navigation mapping - try nested navigator first
    if (middleNavigatorKey.currentState != null) {
      switch (action) {
        case 'account':
          middleNavigatorKey.currentState!.pushNamed('/account');
          return;
        case 'profile':
          middleNavigatorKey.currentState!.pushNamed('/profile');
          return;
        case 'support':
          middleNavigatorKey.currentState!.pushNamed('/support');
          return;
        case 'settings':
          middleNavigatorKey.currentState!.pushNamed('/settings');
          return;
        case 'logout':
          // logout likely needs root-level replacement
          Navigator.of(context).pushReplacementNamed('/login');
          return;
        default:
          middleNavigatorKey.currentState!.pushNamed('/');
          return;
      }
    }

    // fallback to pushing full-screen widgets directly (MaterialApp has no named routes)
    switch (action) {
      case 'logout':
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
          (r) => false,
        );
        break;
      case 'account':
      case 'profile':
        Navigator.of(
          context,
          rootNavigator: true,
        ).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
        break;
      case 'support':
      case 'settings':
        Navigator.of(
          context,
          rootNavigator: true,
        ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
        break;
      default:
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const DashboardScreen()));
    }
  }
}

class _MenuItem extends StatefulWidget {
  final String label;
  final IconData? trailing;
  final Function()? onPressed;
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
    if (_pressed)
      return Theme.of(context).colorScheme.tertiary.withOpacity(0.15);
    if (_hovering)
      return Theme.of(context).colorScheme.tertiary.withOpacity(0.08);
    return Colors.transparent;
  }

  Color _textColor(BuildContext context) {
    if (_pressed) return Theme.of(context).colorScheme.onSurface;
    if (_hovering)
      return Theme.of(context).colorScheme.onSurface.withOpacity(0.8);
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
                    color: _textColor(context),
                    fontWeight: FontWeight.w500,
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
