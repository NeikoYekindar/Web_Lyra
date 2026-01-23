import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:lyra/services/category_service.dart'; // Uncomment để sử dụng API thực
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lyra/core/di/service_locator.dart';
import 'package:lyra/models/current_user.dart';
import '../../screens/welcome_screen.dart';

class WelcomeCreateProfile extends StatefulWidget {
  final VoidCallback onBackPressed;
  final String? userId;

  const WelcomeCreateProfile({
    super.key,
    required this.onBackPressed,
    this.userId,
  });

  @override
  State<WelcomeCreateProfile> createState() => _WelcomeCreateProfileState();
}

class _WelcomeCreateProfileState extends State<WelcomeCreateProfile> {
  String _bio = '';
  String _displayName = '';
  String _gender = '';
  String _dateOfBirth = '';
  DateTime? _dateOfBirthParsed;
  Uint8List? _profileImage;
  bool _isLoading = false;
  final List<String> _genres = [
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
  final List<String> _selectedGenres = [];

  Future<void> _pickImage() async {
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
          _profileImage = imageBytes;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 20,
                    right: 50,
                    bottom: 10,
                  ),
                  height: 45,
                  color: Color(0xFF111111),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.skip,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap:
                              widget.onBackPressed ??
                              () => Navigator.maybePop(context),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  AppLocalizations.of(context)!.createYourProfile,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.musicExperience,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 500,
                      height: 700,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Color(0xFF111111),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 20,
                            spreadRadius: 5,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            AppLocalizations.of(context)!.profilePicture,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                margin: EdgeInsets.only(left: 5),
                                decoration: BoxDecoration(
                                  color: Color(0xFF111111),
                                  borderRadius: BorderRadius.circular(80),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                  image: _profileImage != null
                                      ? DecorationImage(
                                          image: MemoryImage(_profileImage!),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: _profileImage == null
                                    ? Center(
                                        child: SvgPicture.asset(
                                          'assets/icons/persion_icon.svg',
                                          width: 20,
                                          height: 20,
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 20),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ElevatedButton(
                                    onPressed: _pickImage,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF111111),

                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 20,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(color: Colors.white),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/upload_icon.svg',
                                          width: 20,
                                          height: 20,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          AppLocalizations.of(context)!.uploadPhoto,
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    AppLocalizations.of(context)!.max + ' 5MB • JPG, PNG, GIF',
                                    style: GoogleFonts.inter(
                                      color: Colors.white54,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            AppLocalizations.of(context)!.displayName,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            style: GoogleFonts.inter(color: Colors.white),
                            cursorColor: const Color(0xFFDC0404),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 20,
                              ),
                              // labelText: 'Email or Username',
                              // labelStyle: GoogleFonts.inter(
                              //   color: Colors.grey[400],
                              //   fontSize: 14,
                              // ),
                              hintText: AppLocalizations.of(context)!.howShouldWeCallYou,
                              hintStyle: GoogleFonts.inter(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                              filled: true,
                              fillColor: const Color(0xFF111111),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: const Color(0xFF2A2A2A),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: const Color(0xFFDC0404),
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.red[400]!,
                                  width: 1,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _displayName = value;
                              });
                            },
                          ),
                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 50,
                                child: Text(
                                  AppLocalizations.of(context)!.gender,
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 2,
                                child: DropdownButtonFormField<String>(
                                  initialValue: _gender.isEmpty
                                      ? null
                                      : _gender,
                                  dropdownColor: const Color(0xFF1E1E1E),
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 20,
                                    ),
                                    hintText: AppLocalizations.of(context)!.select,
                                    hintStyle: GoogleFonts.inter(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFF111111),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: const Color(0xFF2A2A2A),
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: const Color(0xFFDC0404),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  items: [AppLocalizations.of(context)!.male, AppLocalizations.of(context)!.female, AppLocalizations.of(context)!.other]
                                      .map(
                                        (gender) => DropdownMenuItem(
                                          value: gender,
                                          child: Text(gender),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _gender = value ?? '';
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: 75,
                                child: Text(
                                  AppLocalizations.of(context)!.dateOfBirth,
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 3,
                                child: GestureDetector(
                                  onTap: () async {
                                    final DateTime?
                                    picked = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime(2000),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now(),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.dark(
                                              primary: const Color(0xFFDC0404),
                                              onPrimary: Colors.white,
                                              surface: const Color(0xFF1E1E1E),
                                              onSurface: Colors.white,
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (picked != null) {
                                      setState(() {
                                        _dateOfBirth =
                                            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                                        _dateOfBirthParsed = picked;
                                      });
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: TextField(
                                      controller: TextEditingController(
                                        text: _dateOfBirth,
                                      ),
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 20,
                                            ),
                                        hintText: 'DD/MM/YYYY',
                                        hintStyle: GoogleFonts.inter(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                        suffixIcon: Icon(
                                          Icons.calendar_today,
                                          color: Colors.grey[600],
                                          size: 20,
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFF111111),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide(
                                            color: const Color(0xFF2A2A2A),
                                            width: 1,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide(
                                            color: const Color(0xFFDC0404),
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Bio',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                '${_bio.length}/150',
                                style: GoogleFonts.inter(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            style: GoogleFonts.inter(color: Colors.white),
                            cursorColor: const Color(0xFFDC0404),
                            maxLines: 3,
                            maxLength: 150,
                            decoration: InputDecoration(
                              counterText: '',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              hintText: AppLocalizations.of(context)!.tellUsAbUrSelf,
                              hintStyle: GoogleFonts.inter(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                              filled: true,
                              fillColor: const Color(0xFF111111),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: const Color(0xFF2A2A2A),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: const Color(0xFFDC0404),
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.red[400]!,
                                  width: 1,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _bio = value;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.favoriteGenres,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                '${_selectedGenres.length}/12',
                                style: GoogleFonts.inter(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: _genres.map((genre) {
                              bool isSelected = _selectedGenres.contains(genre);
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedGenres.remove(genre);
                                    } else {
                                      _selectedGenres.add(genre);
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFFDC0404)
                                        : const Color(0xFF1E1E1E),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFFDC0404)
                                          : const Color(0xFF2A2A2A),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    genre,
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.selectAtLeastOneGenre,
                            style: GoogleFonts.inter(
                              color: Colors.grey[600],
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30),
                    SizedBox(
                      width: 500,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 500,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Color(0xFF111111),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  AppLocalizations.of(context)!.profilePicture,
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      margin: EdgeInsets.only(left: 5),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF111111),
                                        borderRadius: BorderRadius.circular(80),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                        image: _profileImage != null
                                            ? DecorationImage(
                                                image: MemoryImage(
                                                  _profileImage!,
                                                ),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      ),
                                      child: _profileImage == null
                                          ? Center(
                                              child: SvgPicture.asset(
                                                'assets/icons/persion_icon.svg',
                                                width: 20,
                                                height: 20,
                                              ),
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 20),

                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _displayName.isEmpty
                                              ? AppLocalizations.of(context)!.yourName
                                              : _displayName,
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Free plan',
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                SizedBox(height: 14),

                                Divider(color: Colors.grey[700], thickness: 1),
                                SizedBox(height: 14),
                                Text(
                                  AppLocalizations.of(context)!.yourPersonalized,
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  style: GoogleFonts.inter(color: Colors.white),
                                  cursorColor: const Color(0xFFDC0404),
                                  controller: TextEditingController(
                                    text: _gender,
                                  ),
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 20,
                                    ),
                                    // labelText: 'Email or Username',
                                    // labelStyle: GoogleFonts.inter(
                                    //   color: Colors.grey[400],
                                    //   fontSize: 14,
                                    // ),
                                    hintText: AppLocalizations.of(context)!.gender,
                                    hintStyle: GoogleFonts.inter(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFF111111),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: const Color(0xFF2A2A2A),
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: const Color(0xFFDC0404),
                                        width: 2,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Colors.red[400]!,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    // Handle text changes
                                  },
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  style: GoogleFonts.inter(color: Colors.white),
                                  cursorColor: const Color(0xFFDC0404),
                                  controller: TextEditingController(
                                    text: _dateOfBirth,
                                  ),
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 20,
                                    ),
                                    // labelText: 'Email or Username',
                                    // labelStyle: GoogleFonts.inter(
                                    //   color: Colors.grey[400],
                                    //   fontSize: 14,
                                    // ),
                                    hintText: AppLocalizations.of(context)!.dateOfBirth,
                                    hintStyle: GoogleFonts.inter(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFF111111),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: const Color(0xFF2A2A2A),
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: const Color(0xFFDC0404),
                                        width: 2,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Colors.red[400]!,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    // Handle text changes
                                  },
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  style: GoogleFonts.inter(color: Colors.white),
                                  cursorColor: const Color(0xFFDC0404),
                                  controller: TextEditingController(text: _bio),
                                  readOnly: true,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 20,
                                    ),
                                    // labelText: 'Email or Username',
                                    // labelStyle: GoogleFonts.inter(
                                    //   color: Colors.grey[400],
                                    //   fontSize: 14,
                                    // ),
                                    hintText: 'Bio',
                                    hintStyle: GoogleFonts.inter(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFF111111),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: const Color(0xFF2A2A2A),
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: const Color(0xFFDC0404),
                                        width: 2,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Colors.red[400]!,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    // Handle text changes
                                  },
                                ),
                                const SizedBox(height: 10),
                                if (_selectedGenres.isNotEmpty) ...[
                                  Text(
                                    AppLocalizations.of(context)!.favoriteGenres,
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _selectedGenres.map((genre) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFDC0404),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          genre,
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Color(0xFFDC0404),
                                    )
                                  : ElevatedButton(
                                      onPressed: () async {
                                        if (_displayName.isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                AppLocalizations.of(context)!.enterDisplayName,
                                              ),
                                              backgroundColor: Colors.orange,
                                            ),
                                          );
                                          return;
                                        }

                                        if (_selectedGenres.isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                AppLocalizations.of(context)!.selectAtLeastOneGenre,
                                              ),
                                              backgroundColor: Colors.orange,
                                            ),
                                          );
                                          return;
                                        }

                                        setState(() => _isLoading = true);

                                        try {
                                          final userService =
                                              ServiceLocator().userService;
                                          final user =
                                              CurrentUser.instance.user;
                                          final userId =
                                              widget.userId ??
                                              user?.userId ??
                                              'temp';

                                          final updatedUser = await userService
                                              .setUpProfile(
                                                userId: userId,
                                                displayName: _displayName,
                                                dateOfBirth: _dateOfBirthParsed,
                                                gender: _gender.isEmpty
                                                    ? 'other'
                                                    : _gender.toLowerCase(),
                                                bio: _bio.isEmpty ? null : _bio,
                                                favoriteGenres: _selectedGenres,
                                                avatarBytes: _profileImage,
                                                avatarFilename:
                                                    _profileImage != null
                                                    ? 'avatar.png'
                                                    : null,
                                              );

                                          // Update CurrentUser
                                          CurrentUser.instance.login(
                                            updatedUser,
                                          );
                                          await CurrentUser.instance
                                              .saveToPrefs();

                                          if (mounted) {
                                            // Show success message
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Profile created successfully! Please log in to continue.',
                                                ),
                                                backgroundColor: Colors.green,
                                                duration: Duration(seconds: 3),
                                              ),
                                            );

                                            // Logout and redirect to login screen
                                            await ServiceLocator().apiClient
                                                .clearTokens();
                                            CurrentUser.instance.logout();
                                            await CurrentUser.instance
                                                .clearPrefs();

                                            // Navigate back to welcome/login screen
                                            Navigator.of(
                                              context,
                                            ).pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const WelcomeScreen(),
                                              ),
                                              (route) => false,
                                            );
                                          }
                                        } catch (error) {
                                          if (mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(content: Text('Failed to pick image: $error')),
                                            );
                                          }
                                        } finally {
                                          if (mounted) {
                                            setState(() => _isLoading = false);
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFDC0404,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 40,
                                          vertical: 20,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!.finish,
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                              const SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : () async {
                                        // Skip profile setup and go to login
                                        if (mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Profile setup skipped. Please log in to continue.',
                                              ),
                                              backgroundColor: Colors.orange,
                                              duration: Duration(seconds: 2),
                                            ),
                                          );

                                          // Logout and clear session
                                          await ServiceLocator().apiClient
                                              .clearTokens();
                                          CurrentUser.instance.logout();
                                          await CurrentUser.instance
                                              .clearPrefs();

                                          // Navigate to welcome/login screen
                                          Navigator.of(
                                            context,
                                          ).pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const WelcomeScreen(),
                                            ),
                                            (route) => false,
                                          );
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0B0B0B),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 20,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.skip,
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
