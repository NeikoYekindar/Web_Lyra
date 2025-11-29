import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:lyra/services/category_service.dart'; // Uncomment để sử dụng API thực
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyra/providers/auth_provider.dart';

class WelcomeSignup extends StatefulWidget {
  final VoidCallback? onBackPressed;
  
  const WelcomeSignup({
    super.key,
    this.onBackPressed,
  });

  @override
  State<WelcomeSignup> createState() => _WelcomeSignupState();
}

class _WelcomeSignupState extends State<WelcomeSignup>{
    bool _obscurePassword = true;
    bool _rememberMe = false;
    String _password = '';
    final _fullNameController = TextEditingController();
    final _displayNameController = TextEditingController();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();

    @override
    void dispose() {
      _fullNameController.dispose();
      _displayNameController.dispose();
      _emailController.dispose();
      _passwordController.dispose();
      _confirmPasswordController.dispose();
      super.dispose();
    }
    
    int _getPasswordStrength(String password) {
      int strength = 0;
      if (password.length >= 8) strength++;
      if (password.contains(RegExp(r'[A-Z]'))) strength++;
      if (password.contains(RegExp(r'[a-z]'))) strength++;
      if (password.contains(RegExp(r'[0-9]'))) strength++;
      if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
      return strength;
    }

    @override
    Widget build(BuildContext context){
      return Container(
        width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF0B0B0B),
      padding: const EdgeInsets.all(24),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 600,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg_login.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(48),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), topLeft: Radius.circular(16)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Logo or Icon
                  // Container(
                  //   width: 80,
                  //   height: 80,
                  //   decoration: BoxDecoration(
                  //     color: const Color(0xFFDC0404),
                  //     shape: BoxShape.circle,
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: const Color(0xFFDC0404).withOpacity(0.4),
                  //         blurRadius: 20,
                  //         spreadRadius: 5,
                  //       ),
                  //     ],
                  //   ),
                  //   child: Icon(
                  //     Icons.music_note,
                  //     size: 40,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  // const SizedBox(height: 40),
                  Text(
                    'Start Your',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Musical Journey',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Join millions of music lovers on Lyra',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 60),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.white.withOpacity(0.3),
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Sign up with',
                                style: GoogleFonts.inter(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.white.withOpacity(0.3),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            _SocialButton(
                              icon: 'assets/icons/google_icon.svg',
                              label: 'Google',
                              size: 24,
                              onPressed: () {},
                            ),
                            const Spacer(),
                            _SocialButton(
                              icon: 'assets/icons/apple_icon.svg',
                              label: 'Apple',
                              size: 30,
                              onPressed: () {},
                            ),
                            const Spacer(),
                            _SocialButton(
                              icon: 'assets/icons/facebook_icon.svg',
                              label: 'Facebook',
                              size: 24,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(20),
                    // decoration: BoxDecoration(
                    //   color: Colors.white.withOpacity(0.1),
                    //   borderRadius: BorderRadius.circular(16),
                    //   border: Border.all(
                    //     color: Colors.white.withOpacity(0.2),
                    //     width: 1,
                    //   ),
                    // ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to log in
                            },
                            child: Text(
                              'Log In',
                              style: GoogleFonts.inter(
                                color: const Color(0xFFDC0404),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
            
            Container(
              width: 600,
              height: double.infinity,
              padding:  const EdgeInsets.only(left: 48,right: 48),
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                  IconButton(
                    onPressed: widget.onBackPressed,
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      overlayColor: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Create account',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),

                  ),
                  const SizedBox(height: 13),
                  Text(
                    'Sign up to start listening',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We\'ll help you complete your profile in the next step',
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                      'Full name',
                      style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                    
                    ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _fullNameController,
                    style: GoogleFonts.inter(color: Colors.white),
                    cursorColor: const Color(0xFFDC0404),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      hintText: 'Enter your full name',
                      hintStyle: GoogleFonts.inter(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1E1E1E),
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
                  ),
                  const SizedBox(height: 20),
                  // Text(
                  //     'Display name',
                  //     style: GoogleFonts.inter(
                  //           color: Colors.white,
                  //           fontSize: 18,
                  //           fontWeight: FontWeight.w300,
                  //         ),
                  //   ),
                  // const SizedBox(height: 8),
                  // TextField(
                  //   controller: _displayNameController,
                  //   style: GoogleFonts.inter(color: Colors.white),
                  //   cursorColor: const Color(0xFFDC0404),
                  //   decoration: InputDecoration(
                  //     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  //     hintText: 'Enter your display name',
                  //     hintStyle: GoogleFonts.inter(
                  //       color: Colors.grey[600],
                  //       fontSize: 14,
                  //     ),
                  //     filled: true,
                  //     fillColor: const Color(0xFF1E1E1E),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //       borderSide: BorderSide(
                  //         color: const Color(0xFF2A2A2A),
                  //         width: 1,
                  //       ),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //       borderSide: BorderSide(
                  //         color: const Color(0xFFDC0404),
                  //         width: 2,
                  //       ),
                  //     ),
                  //     errorBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //       borderSide: BorderSide(
                  //         color: Colors.red[400]!,
                  //         width: 1,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 20),
                  Text(
                      'Email',
                      style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                    
                    ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    style: GoogleFonts.inter(color: Colors.white),
                    cursorColor: const Color(0xFFDC0404),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      hintText: 'Enter your email',
                      hintStyle: GoogleFonts.inter(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1E1E1E),
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
                  ),
                  // const SizedBox(height: 20),
                  // Text(
                  //     'Username',
                  //     style: GoogleFonts.inter(
                  //           color: Colors.white,
                  //           fontSize: 18,
                  //           fontWeight: FontWeight.w300,
                  //         ),
                  //   ),
                  // const SizedBox(height: 8),
                  // TextField(
                  //   controller: _usernameController,
                  //   style: GoogleFonts.inter(color: Colors.white),
                  //   cursorColor: const Color(0xFFDC0404),
                  //   decoration: InputDecoration(
                  //     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  //     hintText: 'Enter your username',
                  //     hintStyle: GoogleFonts.inter(
                  //       color: Colors.grey[600],
                  //       fontSize: 14,
                  //     ),
                  //     filled: true,
                  //     fillColor: const Color(0xFF1E1E1E),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //       borderSide: BorderSide(
                  //         color: const Color(0xFF2A2A2A),
                  //         width: 1,
                  //       ),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //       borderSide: BorderSide(
                  //         color: const Color(0xFFDC0404),
                  //         width: 2,
                  //       ),
                  //     ),
                  //     errorBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //       borderSide: BorderSide(
                  //         color: Colors.red[400]!,
                  //         width: 1,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  // Text(
                  //     'Date of Birth',
                  //     style: GoogleFonts.inter(
                  //           color: Colors.white,
                  //           fontSize: 18,
                  //           fontWeight: FontWeight.w300,
                  //         ),
                  //   ),
                  // const SizedBox(height: 8),
                  // GestureDetector(
                  //   onTap: () => _selectDate(context),
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  //     decoration: BoxDecoration(
                  //       color: const Color(0xFF1E1E1E),
                  //       borderRadius: BorderRadius.circular(8),
                  //       border: Border.all(
                  //         color: const Color(0xFF2A2A2A),
                  //         width: 1,
                  //       ),
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Text(
                  //           _selectedDate == null
                  //               ? 'Select your birth date'
                  //               : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  //           style: GoogleFonts.inter(
                  //             color: _selectedDate == null ? Colors.grey[600] : Colors.white,
                  //             fontSize: 14,
                  //           ),
                  //         ),
                  //         Icon(
                  //           Icons.calendar_today,
                  //           color: Colors.grey[600],
                  //           size: 20,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 20),
                  // Text(
                  //     'Gender',
                  //     style: GoogleFonts.inter(
                  //           color: Colors.white,
                  //           fontSize: 18,
                  //           fontWeight: FontWeight.w300,
                  //         ),
                  //   ),
                  // const SizedBox(height: 8),
                  // DropdownButtonFormField<String>(
                  //   value: _selectedGender,
                  //   dropdownColor: const Color(0xFF1E1E1E),
                  //   style: GoogleFonts.inter(color: Colors.white),
                  //   decoration: InputDecoration(
                  //     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  //     filled: true,
                  //     fillColor: const Color(0xFF1E1E1E),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //       borderSide: BorderSide(
                  //         color: const Color(0xFF2A2A2A),
                  //         width: 1,
                  //       ),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //       borderSide: BorderSide(
                  //         color: const Color(0xFFDC0404),
                  //         width: 2,
                  //       ),
                  //     ),
                  //   ),
                  //   items: const [
                  //     DropdownMenuItem(value: 'male', child: Text('Male')),
                  //     DropdownMenuItem(value: 'female', child: Text('Female')),
                  //     DropdownMenuItem(value: 'other', child: Text('Other')),
                  //   ],
                  //   onChanged: (value) {
                  //     setState(() {
                  //       _selectedGender = value!;
                  //     });
                  //   },
                  // ),

                  // const SizedBox(height: 20),
                  Text(
                      'Password',
                      style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                    
                    ),
                  const SizedBox(height: 8),
                  TextFormField(
                    
                    style: GoogleFonts.inter(color: Colors.white),
                    cursorColor: const Color(0xFFDC0404),
                    decoration: InputDecoration(

                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      // labelText: 'Password',
                      // labelStyle: GoogleFonts.inter(
                      //   color: Colors.grey[400],
                      //   fontSize: 14,
                      // ),
                      hintText: 'Create a strong password',
                      hintStyle: GoogleFonts.inter(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1E1E1E),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey[400],
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
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
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.red[400]!,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                    controller: _passwordController,
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                    obscureText: _obscurePassword,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Strength: ',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ...List.generate(5, (index) {
                        int strength = _getPasswordStrength(_password);
                        bool isActive = index < strength;
                        Color barColor = strength >= 3 
                            ? const Color(0xFF00C853) 
                            : const Color(0xFFDC0404);
                        
                        return Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: isActive ? barColor : Colors.grey[700],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(width: 8),
                      Text(
                        _password.isEmpty 
                            ? '' 
                            : _getPasswordStrength(_password) >= 3 
                                ? 'Strong' 
                                : 'Weak',
                        style: GoogleFonts.inter(
                          color: _password.isEmpty 
                              ? Colors.transparent
                              : _getPasswordStrength(_password) >= 3 
                                  ? const Color(0xFF00C853)
                                  : const Color(0xFFDC0404),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                      'Confirm Password',
                      style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                    
                    ),
                  const SizedBox(height: 8),
                  TextFormField(
                    
                    style: GoogleFonts.inter(color: Colors.white),
                    cursorColor: const Color(0xFFDC0404),
                    decoration: InputDecoration(

                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      // labelText: 'Password',
                      // labelStyle: GoogleFonts.inter(
                      //   color: Colors.grey[400],
                      //   fontSize: 14,
                      // ),
                      hintText: 'Re-enter your password',
                      hintStyle: GoogleFonts.inter(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1E1E1E),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey[400],
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
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
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.red[400]!,
                          width: 2,
                        ),
                      ),
                    ),
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    obscureText: _obscurePassword,
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                              activeColor: const Color(0xFFDC0404),
                              checkColor: Colors.white,
                              side: BorderSide(
                                color: Colors.grey[600]!,
                                width: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'I agree to the ',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          
                          MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  // Navigate to forgot password
                                },
                                child: Text(
                                  'Terms ',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFDC0404),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          
                          Text(
                            'and ',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          
                          MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  // Navigate to forgot password
                                },
                                child: Text(
                                  'Privacy Policy',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFDC0404),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      
                    ],
                  ),




                  const SizedBox(height: 30),
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) => ElevatedButton(
                    onPressed: auth.isLoading || !_rememberMe
                        ? null
                        : () async {
                            // Validate required fields
                            if (_fullNameController.text.trim().isEmpty ||
                                // _displayNameController.text.trim().isEmpty ||
                                _emailController.text.trim().isEmpty ||
                                _passwordController.text.isEmpty ||
                                _confirmPasswordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please fill all required fields')),
                              );
                              return;
                            }
                            
                            if (_passwordController.text != _confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Passwords do not match')),
                              );
                              return;
                            }

                            final result = await context.read<AuthProvider>().signup(
                              displayName: 'unknown',
                              fullName: _fullNameController.text.trim(),
                              userType: 'normal',
                              password: _passwordController.text,
                              email: _emailController.text.trim(),
                              // Optional fields with proper defaults - will be updated in create profile
                              dateOfBirth: null,
                              gender: 'other',
                              profileImageUrl: null,
                            );
                            
                            if (result != null && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Account created successfully! Please log in.')),
                              );
                              widget.onBackPressed?.call();
                            } else if (mounted) {
                              final msg = context.read<AuthProvider>().error ?? 'Signup failed';
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(msg)),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC0404),
                      minimumSize: const Size(double.infinity, 65),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: auth.isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            'Create Account',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                  ),
                  const SizedBox(height: 32),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     ElevatedButton(
                  //       onPressed: () {
                  //         // Handle Google login
                  //       },
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: const Color(0xFF111111),
                  //         minimumSize: const Size(150, 65),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(12),
                  //           side: const BorderSide(color: Color(0xFFF222222)),
                            
                  //         ),
                  //       ),
                  //       child: Row(
                  //         children: [
                  //           SvgPicture.asset(
                  //             'assets/icons/google_icon.svg',
                  //             width: 24,
                  //             height: 24,
                  //           ),
                  //           const SizedBox(width: 8),
                  //           Text(
                  //             'Google',
                  //             style: GoogleFonts.inter(
                  //               color: Colors.white,
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //           ),
                  //         ],
                  //       )
                  //     ),
                  //     // const Spacer(),
                  //     // ElevatedButton(
                  //     //   onPressed: () {
                  //     //     // Handle Google login
                  //     //   },
                  //     //   style: ElevatedButton.styleFrom(
                  //     //     backgroundColor: const Color(0xFF111111),
                  //     //     minimumSize: const Size(150, 65),
                  //     //     shape: RoundedRectangleBorder(
                  //     //       borderRadius: BorderRadius.circular(12),
                  //     //       side: const BorderSide(color: Color(0xFFF222222)),
                            
                  //     //     ),
                  //     //   ),
                  //     //   child: Row(
                  //     //     children: [
                  //     //       SvgPicture.asset(
                  //     //         'assets/icons/apple_icon.svg',
                  //     //         width: 30,
                  //     //         height: 30,
                  //     //       ),
                  //     //       const SizedBox(width: 8),
                  //     //       Text(
                  //     //         'Apple',
                  //     //         style: GoogleFonts.inter(
                  //     //           color: Colors.white,
                  //     //           fontSize: 16,
                  //     //           fontWeight: FontWeight.w600,
                  //     //         ),
                  //     //       ),
                  //     //     ],
                  //     //   )
                  //     // ),
                  //     // const Spacer(),
                  //     // ElevatedButton(
                  //     //   onPressed: () {
                  //     //     // Handle Google login
                  //     //   },
                  //     //   style: ElevatedButton.styleFrom(
                  //     //     backgroundColor: const Color(0xFF111111),
                  //     //     minimumSize: const Size(150, 65),
                  //     //     shape: RoundedRectangleBorder(
                  //     //       borderRadius: BorderRadius.circular(12),
                  //     //       side: const BorderSide(color: Color(0xFFF222222)),
                            
                  //     //     ),
                  //     //   ),
                  //     //   child: Row(
                  //     //     children: [
                  //     //       SvgPicture.asset(
                  //     //         'assets/icons/facebook_icon.svg',
                  //     //         width: 30,
                  //     //         height: 30,
                  //     //       ),
                  //     //       const SizedBox(width: 8),
                  //     //       Text(
                  //     //         'Facebook',
                  //     //         style: GoogleFonts.inter(
                  //     //           color: Colors.white,
                  //     //           fontSize: 16,
                  //     //           fontWeight: FontWeight.w600,
                  //     //         ),
                  //     //       ),
                  //     //     ],
                  //     //   )
                  //     // ),
                  //   ],
                  // ),
                  // const SizedBox(height: 32),
                  // const SizedBox(height: 8),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       "Already have an account? ",
                  //       style: GoogleFonts.inter(
                  //         color: Colors.grey[400],
                  //         fontSize: 18,
                  //         fontWeight: FontWeight.w400,
                  //       ),
                  //     ),
                  //     MouseRegion(
                  //       cursor: SystemMouseCursors.click,
                  //       child: GestureDetector(
                  //         onTap: () {
                  //           // Navigate to sign up
                  //         },
                  //         child: Text(
                  //           'Log In',
                  //           style: GoogleFonts.inter(
                  //             color: const Color(0xFFDC0404),
                  //             fontSize: 18,
                  //             fontWeight: FontWeight.w600,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  
                ],
              ),
              ),
            ),
            
            
          
        ],
      ),
      );
      
    }
}

// Social Button Widget
class _SocialButton extends StatelessWidget {
  final String icon;
  final String label;
  final double size;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.size,
    
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.1),
          minimumSize: const Size(120, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: size,
              height: size,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
