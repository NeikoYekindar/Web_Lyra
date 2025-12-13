import 'package:flutter/material.dart';
import 'package:lyra/navigation/profile_action.dart';
import 'package:lyra/screens/welcome_screen.dart';
import 'ava_navigator.dart'; // ProfileNavigatorMenu
import 'package:lyra/widgets/popup/logout_dialog.dart';
import 'package:lyra/shell/app_nav.dart';
import 'package:lyra/shell/app_routes.dart';

class AvatarButton extends StatefulWidget {
  const AvatarButton({super.key});

  @override
  State<AvatarButton> createState() => _AvatarButtonState();
}

class _AvatarButtonState extends State<AvatarButton> {
  bool _hovering = false;
  bool _pressed = false;

  final GlobalKey _avatarKey = GlobalKey();
  OverlayEntry? _entry;

  // ===============================================================
  // SHOW MENU
  // ===============================================================
  void _showProfileMenu(BuildContext context) {
    final box = _avatarKey.currentContext!.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);

    _entry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // click outside to close
            Positioned.fill(
              child: GestureDetector(
                onTap: _removeMenu,
                behavior: HitTestBehavior.translucent,
                child: const SizedBox(),
              ),
            ),

            // menu positioned under avatar
            Positioned(
              left: offset.dx - 260 + box.size.width,
              top: offset.dy + box.size.height + 8,
              child: Material(
                color: Colors.transparent,
                child: ProfileNavigatorMenu(
                  onSelect: (action) {
                    _removeMenu();
                    _handleProfileAction(context, action);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_entry!);
  }

  void _removeMenu() {
    _entry?.remove();
    _entry = null;
  }

  // ===============================================================
  // HANDLE ACTION (CHUẨN APPSHELL)
  // ===============================================================
  void _handleProfileAction(BuildContext context, ProfileAction action) {
    switch (action) {
      case ProfileAction.dashboard:
        AppNav.go(AppRoutes.home); // account → dashboard
        break;

      case ProfileAction.profile:
        AppNav.go(AppRoutes.profile);
        break;

      case ProfileAction.support:
        AppNav.go(AppRoutes.home); // hoặc support nếu có
        break;

      case ProfileAction.settings:
        AppNav.go(AppRoutes.settings);
        break;

      case ProfileAction.logout:
        // Show the logout confirmation dialog
        showDialog(
          context: context,
          builder: (_) => const LogoutDialog(),
          barrierDismissible: true,
        );
        break;
    }
  }

  // ===============================================================
  // UI
  // ===============================================================
  @override
  Widget build(BuildContext context) {
    final borderColor = _pressed
        ? Theme.of(context).colorScheme.primaryContainer
        : (_hovering
              ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
              : Colors.transparent);

    final borderWidth = _pressed ? 4.0 : (_hovering ? 3.0 : 2.0);

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
          _showProfileMenu(context);
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          key: _avatarKey,
          duration: const Duration(milliseconds: 120),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: ClipOval(
            child: Image.asset('assets/images/avatar.png', fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
