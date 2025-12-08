import 'package:flutter/material.dart';
import 'package:lyra/navigation/middle_nav_key.dart';
import 'package:lyra/screens/profile_screen.dart';
import 'package:lyra/screens/settings_screen.dart';
import 'package:lyra/screens/welcome_screen.dart';
import 'package:lyra/screens/dashboard_screen.dart';
import 'ava_navigator.dart'; // menu bạn đã tạo

class AvatarButton extends StatefulWidget {
  const AvatarButton({super.key});

  @override
  State<AvatarButton> createState() => _AvatarButtonState();
}

class _AvatarButtonState extends State<AvatarButton> {
  bool _hovering = false;
  bool _pressed = false;

  final GlobalKey _avatarKey = GlobalKey();

  void showProfileMenu(BuildContext context, Function(String) onSelect) {
    final renderBox =
        _avatarKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // lớp click ra ngoài
            Positioned.fill(
              child: GestureDetector(
                onTap: () => entry.remove(),
                behavior: HitTestBehavior.translucent,
                child: Container(color: Colors.transparent),
              ),
            ),

            // menu căn theo avatar — KHÔNG LỆCH
            Positioned(
              left: offset.dx - 260 + renderBox.size.width,
              top: offset.dy + renderBox.size.height + 8,
              child: Material(
                color: Colors.transparent,
                child: ProfileNavigatorMenu(
                  onSelect: (value) {
                    entry.remove();
                    onSelect(value);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = _pressed
        ? Theme.of(context).colorScheme.primaryContainer
        : (_hovering
              ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
              : Colors.transparent);

    double borderWidth = _pressed ? 4 : (_hovering ? 3 : 2);

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
          showProfileMenu(context, (value) {
            // Try nested middle navigator first
            if (middleNavigatorKey.currentState != null) {
              switch (value) {
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
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                    (r) => false,
                  );
                  return;
                default:
                  middleNavigatorKey.currentState!.pushNamed('/');
                  return;
              }
            }

            // Fallback to full-screen pushes
            switch (value) {
              case 'logout':
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  (r) => false,
                );
                break;
              case 'account':
              case 'profile':
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
                break;
              case 'support':
              case 'settings':
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
                break;
              default:
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (_) => const DashboardScreen()),
                );
            }
          });
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          key: _avatarKey,
          duration: const Duration(milliseconds: 120),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: borderWidth),
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.asset('assets/images/avatar.png', fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
