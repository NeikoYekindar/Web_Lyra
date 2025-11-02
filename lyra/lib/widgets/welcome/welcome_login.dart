import 'package:flutter/material.dart';
import 'package:lyra/theme/app_theme.dart';
// import 'package:lyra/services/category_service.dart'; // Uncomment để sử dụng API thực
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeLogin extends StatefulWidget {
  final VoidCallback? onBackPressed;
  
  const WelcomeLogin({
    super.key,
    this.onBackPressed,
  });

  @override
  State<WelcomeLogin> createState() => _WelcomeLoginState();
}

class _WelcomeLoginState extends State<WelcomeLogin>{
    bool _obscurePassword = true;
    bool _rememberMe = false;

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
            padding: const EdgeInsets.only(left: 24, bottom: 24),
            decoration:  BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/bg_login.png'),fit: BoxFit.cover),),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Text('Your Music',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text('Your Way',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Stream millions of songs on Lyra',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            )
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
                  const SizedBox(height: 100),
                  Text(
                    'Welcome back',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),

                  ),
                  const SizedBox(height: 13),
                  Text(
                    'Log in to continue listening',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                    
                  ),
                  const SizedBox(height: 45),
                  Text(
                      'Email or username',
                      style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                    
                    ),
                  const SizedBox(height: 8),
                  TextField(
                    style: GoogleFonts.inter(color: Colors.white),
                    cursorColor: const Color(0xFFDC0404),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      // labelText: 'Email or Username',
                      // labelStyle: GoogleFonts.inter(
                      //   color: Colors.grey[400],
                      //   fontSize: 14,
                      // ),
                      hintText: 'Enter your email or username',
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
                    onChanged: (value) {
                      // Handle text changes
                    },
                  ),
                  const SizedBox(height: 24),
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
                      hintText: 'Enter password',
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
                            'Remember me',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to forgot password
                          },
                          child: Text(
                            'Forgot password?',
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




                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      // Handle login action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC0404),
                      minimumSize: const Size(double.infinity, 65),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Log In',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32 ),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey[700],
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Or continue with',
                          style: GoogleFonts.inter(
                            color: Colors.grey[400],
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey[700],
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32 ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Handle Google login
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF111111),
                          minimumSize: const Size(150, 65),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Color(0xFFF222222)),
                            
                          ),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/google_icon.svg',
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Google',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          // Handle Google login
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF111111),
                          minimumSize: const Size(150, 65),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Color(0xFFF222222)),
                            
                          ),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/apple_icon.svg',
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Apple',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          // Handle Google login
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF111111),
                          minimumSize: const Size(150, 65),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Color(0xFFF222222)),
                            
                          ),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/facebook_icon.svg',
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Facebook',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: GoogleFonts.inter(
                          color: Colors.grey[400],
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to sign up
                          },
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.inter(
                              color: const Color(0xFFDC0404),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 38),
                  
                ],
                
              ),
            ),
            
            
          
        ],
      ),
      );
      
    }
}