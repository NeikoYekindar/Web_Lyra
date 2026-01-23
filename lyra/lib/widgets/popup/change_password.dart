import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart';
// Removed unused imports
import 'package:confetti/confetti.dart';
import 'package:lyra/l10n/app_localizations.dart';
import 'package:lyra/widgets/reset_pass/fp_enter_email.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isSuccess = false;
  bool _isFormValid = false;
  late ConfettiController _confettiController;
  int _passwordScore = 0;

  int _evaluatePassword(String p) {
    var score = 0;
    // Weight length more:
    if (p.length >= 12) {
      score += 2; // strong length bonus
    } else if (p.length >= 8) {
      score += 1;
    }

    // Digit presence
    if (RegExp(r'[0-9]').hasMatch(p)) score += 1;

    // Mixed case: require both upper and lower for the bonus
    final hasUpper = RegExp(r'[A-Z]').hasMatch(p);
    final hasLower = RegExp(r'[a-z]').hasMatch(p);
    if (hasUpper && hasLower) score += 1;

    // Symbol presence
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(p)) score += 1;

    // Map raw score into 0..4
    if (score <= 1) return 0;
    if (score == 2) return 1;
    if (score == 3) return 2;
    if (score == 4) return 3;
    return 4;
  }

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    // Track form validity while user types
    _oldPasswordController.addListener(_updateFormValidity);
    _newPasswordController.addListener(_updateFormValidity);
    _confirmPasswordController.addListener(_updateFormValidity);
    _updateFormValidity();
  }

  @override
  void dispose() {
    _oldPasswordController.removeListener(_updateFormValidity);
    _newPasswordController.removeListener(_updateFormValidity);
    _confirmPasswordController.removeListener(_updateFormValidity);
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _updateFormValidity() {
    final oldOk = _oldPasswordController.text.trim().isNotEmpty;
    final newOk = _newPasswordController.text.trim().length >= 8;
    final confirmOk =
        _confirmPasswordController.text == _newPasswordController.text &&
        _confirmPasswordController.text.isNotEmpty;
    // Use quick checks only so the Save button enables responsively
    final valid = oldOk && newOk && confirmOk;
    if (valid != _isFormValid) {
      setState(() => _isFormValid = valid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680, minWidth: 300),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: _isSuccess
              ? Container(
                  key: const ValueKey('success'),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 32.0,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0B8AEB), Color(0xFF22C55E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            'Password Reset!',
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Your password has been updated successfully. You can now login with your new password.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(color: Colors.white70),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                      kIsWeb
                          ? const SizedBox.shrink()
                          : Positioned(
                              top: 8,
                              child: ConfettiWidget(
                                confettiController: _confettiController,
                                blastDirectionality:
                                    BlastDirectionality.explosive,
                                shouldLoop: false,
                                emissionFrequency: 0.02,
                                numberOfParticles: 20,
                                maxBlastForce: 20,
                                minBlastForce: 8,
                                colors: const [
                                  Colors.white,
                                  Colors.yellow,
                                  Colors.green,
                                  Colors.blue,
                                ],
                              ),
                            ),
                    ],
                  ),
                )
              : Material(
                  key: const ValueKey('form'),
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  elevation: 8,
                  child: Container(
                    width: 480,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 32.0,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.changePassword,
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: Icon(
                                  Icons.close,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),
                          Divider(color: colorScheme.outline, thickness: 1),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _oldPasswordController,
                            obscureText: _obscurePassword,
                            style: GoogleFonts.inter(
                              color: colorScheme.onSurface,
                            ),
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                                child: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              labelText: AppLocalizations.of(
                                context,
                              )!.oldPassword,
                              labelStyle: GoogleFonts.inter(
                                color: colorScheme.onSurface,
                                fontSize: 16,
                              ),
                              hintText: 'Enter your new password',
                              hintStyle: GoogleFonts.inter(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 16,
                              ),
                              filled: true,
                              fillColor: colorScheme.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: const BorderSide(
                                  color: Color(0xFFD9D9D9),
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _newPasswordController,
                            obscureText: _obscurePassword,
                            style: GoogleFonts.inter(
                              color: colorScheme.onSurface,
                            ),
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                                child: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              labelText: AppLocalizations.of(
                                context,
                              )!.newPassword,
                              labelStyle: GoogleFonts.inter(
                                color: colorScheme.onSurface,
                                fontSize: 16,
                              ),
                              hintText: 'Enter your new password',
                              hintStyle: GoogleFonts.inter(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 16,
                              ),
                              filled: true,
                              fillColor: colorScheme.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: const BorderSide(
                                  color: Color(0xFFD9D9D9),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            onChanged: (v) {
                              final score = _evaluatePassword(v);
                              setState(() => _passwordScore = score);
                            },
                            validator: (v) => (v == null || v.length < 8)
                                ? 'Password must be at least 8 chars'
                                : null,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.strength,
                                style: GoogleFonts.inter(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: PasswordStrengthIndicator(
                                  score: _passwordScore,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscurePassword,
                            style: GoogleFonts.inter(
                              color: colorScheme.onSurface,
                            ),
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                                child: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              labelText: AppLocalizations.of(
                                context,
                              )!.confirmNewPassword,
                              labelStyle: GoogleFonts.inter(
                                color: colorScheme.onSurface,
                                fontSize: 16,
                              ),
                              hintText: 'Re-enter your new password',
                              hintStyle: GoogleFonts.inter(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 16,
                              ),
                              filled: true,
                              fillColor: colorScheme.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: const BorderSide(
                                  color: Color(0xFFD9D9D9),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            validator: (v) => (v != _newPasswordController.text)
                                ? 'Passwords do not match'
                                : null,
                          ),

                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => EnterEmailScreen(),
                                    ),
                                  );
                                },

                                child: Text(
                                  AppLocalizations.of(context)!.forgotPassword,
                                  style: GoogleFonts.inter(
                                    color: colorScheme.primary,
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                          Divider(color: colorScheme.outline, thickness: 1),
                          const SizedBox(height: 10),
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
                                    backgroundColor:
                                        colorScheme.secondaryContainer,
                                    foregroundColor:
                                        colorScheme.onSurfaceVariant,
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
                                    'Cancel',
                                    style: GoogleFonts.inter(fontSize: 14),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: (!_isFormValid || _isLoading)
                                      ? null
                                      : () async {
                                          // final validation has already been tracked, but run Form validate
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() => _isLoading = true);
                                            await Future.delayed(
                                              const Duration(seconds: 2),
                                            );
                                            setState(() {
                                              _isLoading = false;
                                              _isSuccess = true;
                                            });
                                            _confettiController.play();
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _isFormValid
                                        ? colorScheme.primary
                                        : colorScheme.surfaceContainerHighest,
                                    foregroundColor: _isFormValid
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
                                          'Save',
                                          style: GoogleFonts.inter(
                                            color: _isFormValid
                                                ? colorScheme.onPrimary
                                                : colorScheme.onSurfaceVariant,
                                            fontSize: 14,
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
      ),
    );
  }
}

class PasswordStrengthIndicator extends StatelessWidget {
  final int score; // 0..4

  const PasswordStrengthIndicator({super.key, required this.score});

  Color _activeColorForScore(BuildContext context, int s) {
    final cs = Theme.of(context).colorScheme;
    if (s <= 0) return cs.error;
    if (s == 1) return const Color(0xFFFB923C); // orange
    if (s == 2) return cs.primary;
    if (s >= 3) return const Color(0xFF22C55E); // green
    return cs.surfaceContainerHighest.withOpacity(0.3);
  }

  String _labelForScore(int s) {
    switch (s) {
      case 0:
        return 'Very weak';
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: List.generate(4, (i) {
              final active = score > i;
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.only(right: i < 3 ? 6.0 : 0.0),
                  height: 6,
                  decoration: BoxDecoration(
                    color: active
                        ? _activeColorForScore(context, score)
                        : cs.surfaceContainerHighest.withOpacity(0.28),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  transform: Matrix4.diagonal3Values(
                    active ? 1.0 : 0.98,
                    1.0,
                    1.0,
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _labelForScore(score),
          style: GoogleFonts.inter(
            color: cs.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
