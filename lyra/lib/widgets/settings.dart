import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyra/theme/app_theme.dart';
import 'package:lyra/widgets/common/setting_item.dart';
import 'package:lyra/widgets/common/favorite_card.dart';
import 'package:lyra/widgets/common/language_selector.dart';
import 'package:lyra/widgets/common/switch.dart';
import 'package:lyra/widgets/popup/change_password.dart';
import 'package:lyra/widgets/popup/edit_profile.dart';
import 'package:lyra/models/current_user.dart';
import 'package:lyra/models/user.dart';
import 'package:lyra/widgets/popup/logout_dialog.dart';

class SettingsWid extends StatefulWidget {
  const SettingsWid({super.key});

  @override
  State<SettingsWid> createState() => _SettingsWidState();
}

void showEditProfilePopup(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (ctx, anim1, anim2) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Material(
            color: Colors.transparent,
            child: PhysicalModel(
              color: Colors.transparent,
              elevation: 20,
              shadowColor: Colors.black54,
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: double.infinity,
                child: EditProfilePopup(),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _SettingsWidState extends State<SettingsWid> {
  bool _socialToggle = false;
  bool _activityToggle = false;
  @override
  void initState() {
    super.initState();
    // restore persisted user for demo purposes
    Future.microtask(() => CurrentUser.instance.restoreFromPrefs());
  }

  @override
  Widget build(BuildContext context) {
    List<String> types = ['Folk', 'Pop', 'Latin'];

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Settings",
                  style: GoogleFonts.inter(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 45),
                Text(
                  "Profile",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 15),
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1,
                    ),
                  ),

                  child: ValueListenableBuilder<UserModel?>(
                    valueListenable: CurrentUser.instance.userNotifier,
                    builder: (context, UserModel? user, _) {
                      final emailStr = user?.email ?? '';
                      final username = emailStr.isNotEmpty
                          ? emailStr.split('@').first
                          : 'nguyenphan_75';
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                  alignment: Alignment.center,
                                  onPressed: () {
                                    showEditProfilePopup(context);
                                  },
                                  icon: Icon(Icons.edit, size: 16),
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ClipOval(
                                        child: user?.profileImageUrl != null
                                            ? (user!.profileImageUrl!
                                                      .startsWith('http')
                                                  ? Image.network(
                                                      user.profileImageUrl!,
                                                      width: 110,
                                                      height: 110,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.asset(
                                                      user.profileImageUrl!,
                                                      width: 110,
                                                      height: 110,
                                                      fit: BoxFit.cover,
                                                    ))
                                            : Icon(Icons.person, size: 110),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        user?.displayName ?? 'Trùm UIT',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                        ),
                                      ),
                                      Text(
                                        username,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SettingItem_bold(
                                    title: 'Email',
                                    value: Text(
                                      user?.email ?? '@gmail.com',
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                  SettingItem_bold(
                                    title: 'Gender',
                                    value: Text(
                                      user?.gender ?? 'Male',
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                  SettingItem_bold(
                                    title: 'Date of Birth',
                                    value: Text(
                                      user != null && user.dateOfBirth != null
                                          ? '${user.dateOfBirth!.day.toString().padLeft(2, '0')}/${user.dateOfBirth!.month.toString().padLeft(2, '0')}/${user.dateOfBirth!.year}'
                                          : '07/05/2004',
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                  SettingItem_bold(
                                    title: 'Bio',
                                    value: Text(
                                      user?.bio ?? 'kakakakaka',
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                  SettingItem_bold(
                                    title: 'Favorite',
                                    value: Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: (user?.favoriteGenres ?? types)
                                          .map(
                                            (type) => FavoriteCard(
                                              item: type,
                                              isPicked: true,
                                              minHeight: 36,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SettingItem_bold(
                  title: 'Change Password',
                  value: ChangePasswordButton(
                    onTap: () {
                      showGeneralDialog(
                        context: context,
                        barrierColor: Colors.black.withOpacity(0.5),
                        barrierDismissible: true,
                        barrierLabel: MaterialLocalizations.of(
                          context,
                        ).modalBarrierDismissLabel,
                        pageBuilder: (_, __, ___) {
                          return Material(
                            color: Colors.transparent,
                            child: Align(
                              alignment: Alignment.center,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 500,
                                ),
                                child: PhysicalModel(
                                  color: Colors.transparent,
                                  elevation: 20,
                                  shadowColor: Colors.black54,
                                  borderRadius: BorderRadius.circular(12),
                                  clipBehavior: Clip.antiAlias,
                                  child: const ChangePassword(),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Language",
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SettingItem_regu(
                  title:
                      'Choose your language - changes will be updated after reload',
                  value: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 250, minWidth: 200),
                    child: Container(width: 250, child: LanguageDropdown()),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Social",
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SettingItem_regu(
                  title:
                      'On your profile, people can see who’s following you and who you’re following',
                  value: FancyToggle(
                    value: _socialToggle,
                    onChanged: (bool newValue) {
                      setState(() {
                        _socialToggle = newValue;
                      });
                    },
                  ),
                ),
                SettingItem_regu(
                  title: 'Share my listening activity on Lyra',
                  value: FancyToggle(
                    value: _activityToggle,
                    onChanged: (bool newValue) {
                      setState(() {
                        _activityToggle = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(height: 40),
                LogoutButton(
                  onTap: () {
                    // Mock event: show log hoặc mở dialog
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const LogoutDialog(),
                    );

                    // Hoặc showDialog(context: context, builder: ...) nếu muốn mở popup
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChangePasswordButton extends StatefulWidget {
  final VoidCallback? onTap;
  const ChangePasswordButton({Key? key, this.onTap}) : super(key: key);

  @override
  State<ChangePasswordButton> createState() => _ChangePasswordButtonState();
}

class _ChangePasswordButtonState extends State<ChangePasswordButton> {
  bool _hovering = false;
  bool _pressed = false;

  Color _backgroundColor(BuildContext context) {
    if (_pressed) {
      return Theme.of(context).colorScheme.onSurface;
    }
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
          if (widget.onTap != null) widget.onTap!();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _backgroundColor(context), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: _backgroundColor(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.open_in_new_outlined,
                size: 16,
                color: _backgroundColor(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LogoutButton extends StatefulWidget {
  final VoidCallback? onTap;
  const LogoutButton({Key? key, this.onTap}) : super(key: key);

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  bool _hovering = false;
  bool _pressed = false;

  Color _backgroundColor(BuildContext context) {
    if (_pressed) {
      return Theme.of(context).colorScheme.error.withOpacity(0.18);
    }
    if (_hovering) {
      return Theme.of(context).colorScheme.error.withOpacity(0.10);
    }
    return Theme.of(context).colorScheme.secondaryContainer;
  }

  Color _iconColor(BuildContext context) {
    if (_pressed || _hovering) {
      return Theme.of(context).colorScheme.error;
    }
    return Theme.of(context).colorScheme.onSurface;
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
          if (widget.onTap != null) widget.onTap!();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: double.maxFinite,
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: _backgroundColor(context),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Log out',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: _iconColor(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.logout, size: 25, color: _iconColor(context)),
            ],
          ),
        ),
      ),
    );
  }
}
