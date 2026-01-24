import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection/collection.dart';
import 'package:lyra/l10n/app_localizations.dart';
import 'package:lyra/widgets/common/favorite_card.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../models/current_user.dart';
import '../../core/di/service_locator.dart';

class EditProfilePopup extends StatefulWidget {
  const EditProfilePopup({super.key});

  @override
  State<EditProfilePopup> createState() => _EditProfilePopupState();
}

class _EditProfilePopupState extends State<EditProfilePopup> {
  String gender = 'Male';
  DateTime dob = DateTime(2004, 5, 7);
  late TextEditingController displayNameController;
  late TextEditingController emailController;
  TextEditingController bioController = TextEditingController();
  List<String> selectedGenres = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _hasChanges = false;
  List<int>? _selectedImageBytes;
  String? _selectedImageFilename;

  // initial snapshots for change detection (will be filled from CurrentUser)
  String _initialDisplayName = "";
  String _initialEmail = "";
  String _initialBio = "";
  String _initialGender = "Male";
  DateTime _initialDob = DateTime(2004, 5, 7);
  List<String> _initialGenres = [];

  @override
  void initState() {
    super.initState();
    // initialize from CurrentUser if available
    final user = CurrentUser.instance.user;
    _initialDisplayName = user?.displayName ?? '';
    _initialEmail = user?.email ?? '';
    // Initialize bio from user if present
    _initialBio = user?.bio ?? '';
    // Map stored gender values to canonical labels for now; localization applied later
    _initialGender = (() {
      final raw = user?.gender;
      if (raw == null) return 'Male';
      final lower = raw.toString().toLowerCase();
      if (lower == 'male' || lower == 'm' || lower == 'nam') return 'Male';
      if (lower == 'female' || lower == 'f' || lower == 'nu') return 'Female';
      return 'Male';
    })();
    _initialDob = user?.dateOfBirth ?? DateTime(2004, 5, 7);
    _initialGenres = user?.favoriteGenres != null
        ? List<String>.from(user!.favoriteGenres!)
        : [];

    displayNameController = TextEditingController(text: _initialDisplayName);
    emailController = TextEditingController(text: _initialEmail);
    bioController.text = _initialBio;
    selectedGenres = List<String>.from(_initialGenres);

    // set working fields to initial values so dropdowns/pickers reflect user
    gender = _initialGender;
    dob = _initialDob;

    // listen for text changes to enable Save
    displayNameController.addListener(_checkChanges);
    emailController.addListener(_checkChanges);
    bioController.addListener(_checkChanges);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Now safe to read localized strings from AppLocalizations
    final loc = AppLocalizations.of(context)!;
    final user = CurrentUser.instance.user;
    final localizedGender = (() {
      final raw = user?.gender;
      if (raw == null) return loc.male;
      final lower = raw.toString().toLowerCase();
      if (lower == 'male' || lower == 'm' || lower == 'nam') return loc.male;
      if (lower == 'female' || lower == 'f' || lower == 'nu') return loc.female;
      return loc.male;
    })();

    _initialGender = localizedGender;
    gender = _initialGender;
    if (mounted) setState(() {});
  }

  Future<void> _changeAvatar() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        final Uint8List imageBytes = await image.readAsBytes();
      
      
        setState(() {
          _selectedImageBytes = imageBytes;
          _selectedImageFilename = image.name;
          _checkChanges();
        });
      
      }
    } catch (e) {
      print('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.failedToPickImage)));
      }
    }
  }

  final List<String> genres = [
    'Pop',
    'Rap',
    'Hip-Hop',
    'R&D',
    'Lofi',
    'US-UK pop',
    'Latin pop',
    'Indie',
    'Soul',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      maxChildSize: 0.95,
      minChildSize: 0.6,
      builder: (_, controller) {
        return Material(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          elevation: 14,
          shadowColor: Colors.black.withOpacity(0.4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ScrollConfiguration(
              behavior: _NoScrollbarBehavior(),
              child: ListView(
                controller: controller,
                children: [
                  const SizedBox(height: 18),

                  /// HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.editProfile,
                        style: GoogleFonts.inter(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondaryContainer,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Divider(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.2),
                  ),
                  const SizedBox(height: 10),

                  /// AVATAR
                  // Use a Column to place the label above and center the avatar below.
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.profileImage,
                        style: GoogleFonts.inter(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondaryContainer,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Center the avatar horizontally
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Use selected image bytes if available, else use profile image URL, else fall back to asset
                            ClipOval(
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: _selectedImageBytes != null
                                    ? Image.memory(
                                        Uint8List.fromList(_selectedImageBytes!),
                                        fit: BoxFit.cover,
                                        errorBuilder: (ctx, error, stack) =>
                                            Container(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.surface,
                                              child: Icon(
                                                Icons.person,
                                                size: 64,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurfaceVariant,
                                              ),
                                            ),
                                      )
                                    : CurrentUser
                                            .instance
                                            .user
                                            ?.profileImageUrl !=
                                        null
                                    ? Image.network(
                                        CurrentUser
                                            .instance
                                            .user!
                                            .profileImageUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (ctx, error, stack) =>
                                            Container(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.surface,
                                              child: Icon(
                                                Icons.person,
                                                size: 64,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurfaceVariant,
                                              ),
                                            ),
                                      )
                                    : Image.asset(
                                        'assets/images/avatar.png',
                                        fit: BoxFit.cover,
                                        errorBuilder: (ctx, error, stack) =>
                                            Container(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.surface,
                                              child: Icon(
                                                Icons.person,
                                                size: 64,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurfaceVariant,
                                              ),
                                            ),
                                      ),
                              ),
                            ),
                            // Positioned edit icon at bottom-right of avatar
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                    width: 1,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: _changeAvatar,
                                  borderRadius: BorderRadius.circular(99),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(
                                      Icons.edit_outlined,
                                      size: 16,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Divider(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.2),
                  ),
                  const SizedBox(height: 10),

                  /// DISPLAY NAME
                  buildInput(
                    AppLocalizations.of(context)!.displayName,
                    CurrentUser.instance.user?.displayName ??
                        AppLocalizations.of(context)!.yourName,
                    controller: displayNameController,
                  ),
                  const SizedBox(height: 10),
                  Divider(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.2),
                  ),
                  const SizedBox(height: 10),

                  /// EMAIL
                  buildInput(
                    "Email",
                    CurrentUser.instance.user?.email ?? '',
                    enabled: true,
                    controller: emailController,
                  ),
                  const SizedBox(height: 10),
                  Divider(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.2),
                  ),
                  const SizedBox(height: 10),

                  /// GENDER + DOB
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: buildGenderDropdown()),
                      const SizedBox(width: 12),
                      Expanded(child: buildDobPicker(context)),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Divider(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.2),
                  ),
                  const SizedBox(height: 10),

                  /// BIO
                  Text(
                    "Bio",
                    style: GoogleFonts.inter(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      controller: bioController,
                      maxLines: 4,
                      maxLength: 150,
                      style: GoogleFonts.inter(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context)!.writeSomething,
                        hintStyle: GoogleFonts.inter(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Divider(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.2),
                  ),
                  const SizedBox(height: 10),

                  /// GENRES
                  Text(
                    AppLocalizations.of(context)!.favoriteGenres,
                    style: GoogleFonts.inter(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: genres.map((g) {
                        // Mark as picked if the current user's favorites contain this genre
                        // Picked state is driven by the editable `selectedGenres` list
                        final selected = selectedGenres.contains(g);
                        return FavoriteCard(
                          item: g,
                          isPicked: selected,
                          onTap: () => setState(() {
                            if (selectedGenres.contains(g)) {
                              selectedGenres.remove(g);
                            } else {
                              selectedGenres.add(g);
                            }
                            _checkChanges();
                          }),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Divider(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.2),
                  ),
                  const SizedBox(height: 10),

                  /// BUTTONS
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            backgroundColor: colorScheme.secondaryContainer,
                            foregroundColor: colorScheme.onSurfaceVariant,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 12,
                            ),
                            minimumSize: const Size(0, 44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.cancel,
                            style: GoogleFonts.inter(fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: (!_hasChanges || _isLoading)
                              ? null
                              : () async {
                                  final formIsValid =
                                      _formKey.currentState?.validate() ?? true;
                                  if (formIsValid) {
                                    setState(() => _isLoading = true);
                                    try {
                                      // Call API to update user
                                      final userService =
                                          serviceLocator.userService;
                                      final prev = CurrentUser.instance.user;
                                      final userId = prev?.userId ?? '';

                                      final updatedUser = await userService
                                          .updateCurrentUser(
                                            userId: userId,
                                            displayName: displayNameController
                                                .text
                                                .trim(),
                                            email: emailController.text.trim(),
                                            gender: gender,
                                            dateOfBirth: dob,
                                            bio: bioController.text.trim(),
                                            favoriteGenres: List<String>.from(
                                              selectedGenres,
                                            ),
                                            profileImageBytes: _selectedImageBytes,
                                            profileImageFilename: _selectedImageFilename,
                                          );

                                      // Persist updated user locally
                                      CurrentUser.instance.update(
                                        (_) => updatedUser,
                                      );
                                      await CurrentUser.instance.saveToPrefs();

                                      // Reload UI with updated data
                                      _reloadUserData();

                                      if (mounted) {
                                        // Show snackbar BEFORE closing dialog
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Profile saved successfully',
                                            ),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                        // Then close the dialog
                                        Navigator.of(context).pop();
                                      }
                                    } catch (e) {
                                      setState(() => _isLoading = false);
                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text('${AppLocalizations.of(context)!.failedToSaveChanges}$e'),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _hasChanges
                                ? colorScheme.primary
                                : colorScheme.surfaceContainerHighest,
                            foregroundColor: _hasChanges
                                ? colorScheme.onPrimary
                                : colorScheme.onSurfaceVariant,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 12,
                            ),
                            minimumSize: const Size(0, 44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colorScheme.onPrimary,
                                  ),
                                )
                              : Text(
                                  AppLocalizations.of(context)!.save,
                                  style: GoogleFonts.inter(
                                    color: _hasChanges
                                        ? colorScheme.onPrimary
                                        : colorScheme.onSurfaceVariant,
                                    fontSize: 14,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _playConfetti() {
    // confetti controller not available in this popup (guarded for web).
    // Keep method as a safe no-op so callers don't need to be changed.
  }

  @override
  void dispose() {
    displayNameController.dispose();
    emailController.dispose();
    bioController.dispose();
    super.dispose();
  }

  // -----------------------------
  // SMALL WIDGETS
  // -----------------------------

  Widget buildInput(
    String label,
    String value, {
    bool enabled = true,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            controller: controller,
            enabled: enabled,
            style: GoogleFonts.inter(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              hintText: value,
              hintStyle: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _checkChanges() {
    final nameChanged = displayNameController.text != _initialDisplayName;
    final emailChanged = emailController.text != _initialEmail;
    final bioChanged = bioController.text != _initialBio;
    final genderChanged = gender != _initialGender;
    final dobChanged = dob != _initialDob;
    final genresChanged = !(ListEquality().equals(
      selectedGenres,
      _initialGenres,
    ));
    final imageChanged = _selectedImageBytes != null;

    final any =
        nameChanged ||
        emailChanged ||
        bioChanged ||
        genderChanged ||
        dobChanged ||
        genresChanged ||
        imageChanged;
    if (any != _hasChanges) setState(() => _hasChanges = any);
  }

  void _reloadUserData() {
    // Reload data từ CurrentUser sau khi update thành công
    final user = CurrentUser.instance.user;
    if (user != null) {
      setState(() {
        _initialDisplayName = user.displayName ?? '';
        _initialEmail = user.email ?? '';
        _initialBio = user.bio ?? '';
        _initialDob = user.dateOfBirth ?? DateTime(2004, 5, 7);
        _initialGenres = user.favoriteGenres != null
            ? List<String>.from(user.favoriteGenres!)
            : [];

        // Update controllers
        displayNameController.text = _initialDisplayName;
        emailController.text = _initialEmail;
        bioController.text = _initialBio;
        selectedGenres = List<String>.from(_initialGenres);

        // Update dropdown/picker
        gender = _initialGender;
        dob = _initialDob;
        _selectedImageBytes = null;
        _selectedImageFilename = null;
        _hasChanges = false;
      });
    }
  }

  Widget buildGenderDropdown() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.gender,
          style: GoogleFonts.inter(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: Theme.of(context).colorScheme.secondaryContainer,
              value: gender,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Theme.of(context).colorScheme.outline,
              ),
              items:
                  [
                        AppLocalizations.of(context)!.male,
                        AppLocalizations.of(context)!.female,
                      ]
                      .map(
                        (g) => DropdownMenuItem(
                          value: g,
                          child: Text(
                            g,
                            style: GoogleFonts.inter(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                      .toList(),
              onChanged: (v) => setState(() {
                gender = v!;
                _checkChanges();
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDobPicker(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.dateOfBirth,
          style: GoogleFonts.inter(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: dob,
              firstDate: DateTime(1960),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              setState(() {
                dob = picked;
                _checkChanges();
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${dob.day}/${dob.month}/${dob.year}",
                  style: GoogleFonts.inter(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.calendar_month,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Custom ScrollBehavior that hides scrollbars and overscroll indicators
class _NoScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child; // no scrollbar
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child; // disable overscroll glow
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const ClampingScrollPhysics();
}
