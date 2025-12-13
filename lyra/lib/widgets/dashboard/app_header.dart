import 'package:flutter/material.dart';
import '../theme_toggle_button.dart';
import '../../screens/theme_test_screen.dart';
import 'package:lyra/theme/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'app_header_controller.dart';
import '/screens/dashboard/dashboard_controller.dart';
import 'package:provider/provider.dart';

class AppHeader extends StatelessWidget {
  final VoidCallback? onBrowseAllPressed;
  final Function(String)? onSearchChanged;
  const AppHeader({super.key, this.onBrowseAllPressed, this.onSearchChanged});
  

  @override
  Widget build(BuildContext context) {
    final ctrl = AppHeaderController();
    final extra = Theme.of(context).extension<AppExtraColors>();
    return Container(
      height: 70,
      // Use custom header color from ThemeExtension; fallback to background.
      color: extra?.headerAndAll ?? Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Navigation arrows
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(
          //     Icons.arrow_back_ios,
          //     color: Colors.grey,
          //     size: 20,
          //   ),
          // ),
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(
          //     Icons.arrow_forward_ios,
          //     color: Colors.grey,
          //     size: 20,
          //   ),
          // ),

          const SizedBox(width: 32),

          // Logo
          Container(
            width: 100,
            height: 50,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/logos/Lyra.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // const SizedBox(width: 32),

          // Home button
          // Container(
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(20),
          //   ),
          //   child: IconButton(
          //     onPressed: () {},
          //     icon: const Icon(
          //       Icons.home,
          //       color: Colors.black,
          //       size: 20,
          //     ),
          //   ),
          // ),

          const SizedBox(width: 16),

          // Search bar
          Expanded(
            child: Container(
              height: 50,
              width: 400,
              margin: const EdgeInsets.symmetric(horizontal: 450),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3)),
                
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed:() {},  
                    // Thay thế Icon bằng SvgPicture.asset
                    icon: SvgPicture.asset(
                      'assets/icons/SearchLeftSideBar.svg', // Đường dẫn đến file svg của bạn
                      width: 20, // Kích thước tương đương size: 30 cũ
                      height: 20,
                      // Để đổi màu SVG sang trắng giống như icon cũ (color: Colors.white)
                      colorFilter: const ColorFilter.mode(
                        Colors.white, 
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'What do you want to play?',
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SvgPicture.asset(
                      'assets/icons/LineInHeader.svg', // Đường dẫn đến file svg của bạn
                      width: 30, // Kích thước tương đương size: 30 cũ
                      height: 30,
                      // Để đổi màu SVG sang trắng giống như icon cũ (color: Colors.white)
                      colorFilter: const ColorFilter.mode(
                        Colors.white, 
                        BlendMode.srcIn,
                      ),
                    ),
                  const SizedBox(width: 2),
                  IconButton(
                  onPressed: ()=>ctrl.toggleBrowserAll(context),
                    icon: SvgPicture.asset(
                      'assets/icons/Soundwave.svg', // Đường dẫn đến file svg của bạn
                      width: 20, // Kích thước tương đương size: 30 cũ
                      height: 20,
                      // Để đổi màu SVG sang trắng giống như icon cũ (color: Colors.white)
                      colorFilter: const ColorFilter.mode(
                        Colors.white, 
                        BlendMode.srcIn,
                      ),
                    ),
                    
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Right side icons
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              size: 24,
            ),
          ),
          
          // Theme Toggle Button
          const ThemeToggleButton(showLabel: false, iconSize: 24),
          
          const SizedBox(width: 10),

          // Theme Test Button
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ThemeTestScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.science,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              size: 24,
            ),
            tooltip: 'Test Theme',
          ),
          
          const SizedBox(width: 10),

          // User avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/images/avatar.png'),
                fit: BoxFit.cover,
              ),
            ),
            
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}