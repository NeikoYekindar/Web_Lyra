import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyra/core/di/service_locator.dart';
import 'package:lyra/widgets/common/custom_button.dart';
import 'package:lyra/models/current_user.dart';

class WelcomeSetupProfile extends StatefulWidget {
  final String userId;

  const WelcomeSetupProfile({Key? key, required this.userId}) : super(key: key);

  @override
  State<WelcomeSetupProfile> createState() => _WelcomeSetupProfileState();
}

class _WelcomeSetupProfileState extends State<WelcomeSetupProfile> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  String _gender = 'other';
  DateTime? _dateOfBirth;
  bool _isLoading = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userService = ServiceLocator().userService;
      final user = await userService.updateCurrentUser(
        userId: widget.userId,
        displayName: _displayNameController.text.trim(),
        gender: _gender,
        dateOfBirth: _dateOfBirth,
      );

      // Update CurrentUser singleton
      CurrentUser.instance.login(user);
      await CurrentUser.instance.saveToPrefs();

      if (mounted) {
        // Pop all routes to root and let AuthGate show AppShell
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFDC0404),
              surface: Color(0xFF1E1E1E),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Setup Your Profile',
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tell us a bit about yourself',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display Name
                        Text(
                          'Display Name',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _displayNameController,
                          style: GoogleFonts.inter(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Enter your display name',
                            hintStyle: GoogleFonts.inter(
                              color: Colors.grey[600],
                            ),
                            filled: true,
                            fillColor: const Color(0xFF1E1E1E),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: const Color(0xFF2A2A2A),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: const Color(0xFF2A2A2A),
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
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Display name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Gender
                        Text(
                          'Gender',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _gender,
                          dropdownColor: const Color(0xFF1E1E1E),
                          style: GoogleFonts.inter(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF1E1E1E),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: const Color(0xFF2A2A2A),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: const Color(0xFF2A2A2A),
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
                          items: [
                            DropdownMenuItem(
                              value: 'male',
                              child: Text('Male'),
                            ),
                            DropdownMenuItem(
                              value: 'female',
                              child: Text('Female'),
                            ),
                            DropdownMenuItem(
                              value: 'other',
                              child: Text('Other'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _gender = value);
                            }
                          },
                        ),
                        const SizedBox(height: 24),

                        // Date of Birth
                        Text(
                          'Date of Birth (Optional)',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: _selectDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF2A2A2A),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _dateOfBirth != null
                                      ? '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}'
                                      : 'Select your date of birth',
                                  style: GoogleFonts.inter(
                                    color: _dateOfBirth != null
                                        ? Colors.white
                                        : Colors.grey[600],
                                  ),
                                ),
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey[400],
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Submit Button
                        _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFDC0404),
                                ),
                              )
                            : SizedBox(
                                width: double.infinity,
                                child: PrimaryButton(
                                  onPressed: _saveProfile,
                                  child: Text(
                                    'Continue',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              // Skip setup and go to dashboard
                              // Pop all routes to root and let AuthGate show AppShell
                              Navigator.of(
                                context,
                              ).popUntil((route) => route.isFirst);
                            },
                            child: Text(
                              'Skip for now',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.grey[400],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
