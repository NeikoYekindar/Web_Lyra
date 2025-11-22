import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lyra/widgets/reset_pass/fp_enter_new_password.dart';
import 'package:lyra/providers/auth_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(baseUrl: 'https://example.com'),
      child: const _DebugApp(),
    ),
  );
}

class _DebugApp extends StatelessWidget {
  const _DebugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verify Email Debug',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: EnterNewPasswordScreen(),
    );
  }
}
