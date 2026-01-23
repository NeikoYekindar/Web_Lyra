import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lyra/providers/auth_provider_v2.dart';
import 'package:lyra/providers/music_player_provider.dart';
import 'package:lyra/screens/welcome_screen.dart';
import 'package:lyra/l10n/app_localizations.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ------------------ Header ------------------
            Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Divider(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              thickness: 1,
            ),
            const SizedBox(height: 10),
            // ------------------ Title ------------------
            Text(
              "You are attempting to log out of Lyra",
              style: GoogleFonts.inter(
                fontSize: 20,
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // ------------------ Subtitle ------------------
            Text(
              "Are you sure?",
              style: GoogleFonts.inter(
                fontSize: 15,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 24),

            // ------------------ Buttons ------------------
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.secondaryContainer,
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.inter(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Logout button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        // Stop music player first
                        final musicPlayer = Provider.of<MusicPlayerProvider>(
                          context,
                          listen: false,
                        );
                        // Use dynamic invocation so code compiles even if the
                        // provider doesn't expose a `stop` method. Errors are
                        // ignored and handled by the surrounding try/catch.
                        try {
                          await (musicPlayer as dynamic).stop();
                        } catch (_) {
                          // ignore if stop isn't defined or fails
                        }
                        try {
                          (musicPlayer as dynamic).clearQueue();
                        } catch (_) {
                          // ignore if clearQueue isn't defined
                        }

                        // Call logout API
                        await Provider.of<AuthProviderV2>(
                          context,
                          listen: false,
                        ).logout();

                        // Close dialog after successful logout
                        if (context.mounted) {
                          Navigator.pop(context);

                          // Navigate to welcome screen
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => const WelcomeScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      } catch (e) {
                        // Close dialog on error
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      "Log out",
                      style: GoogleFonts.inter(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
