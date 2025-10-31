import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class LeftSidebar extends StatelessWidget {
  final VoidCallback? onCollapsePressed;
  
  const LeftSidebar({
    super.key,
    this.onCollapsePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(right: 8, bottom: 10, left: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildCustomIconMenuItemLibrary('assets/icons/closetominisize_icon.svg', false, 40, 40, onCollapsePressed),
                const SizedBox(width: 8),
                Text(
                  'Your Library',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    
                  ),
                ),
                const Spacer(),
                _buildCustomIconMenuItemLibraryCreate('assets/icons/create.svg', false, 120, 60),
                const SizedBox(width: 2),
                _buildCustomIconMenuItemLibraryCreate('assets/icons/expand.svg', false, 40, 40),
              ]
              ),
          ),
          // Language Button        
        ],
      ),
    );
  }
  Widget _buildCustomIconMenuItemLibrary(String svgPath, bool isActive, double sizeWidth, double sizeHeight, VoidCallback? onPressed) {
    return Container(
      width: sizeWidth,
      height: sizeHeight,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2A2A2A) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: onPressed ?? () {},
        style: IconButton.styleFrom(
          overlayColor: Colors.transparent,
        ),
        icon: SvgPicture.asset(
          svgPath,
          width: 25,
          height: 25
          // colorFilter: ColorFilter.mode(
          //   isActive ? Colors.white : Colors.grey,
          //   BlendMode.srcIn,
          // ),
        ),
      ),
    );
  }
  Widget _buildCustomIconMenuItemLibraryCreate(String svgPath, bool isActive, double sizeWidth, double sizeHeight) {
    return Container(
      width: sizeWidth,
      height: sizeHeight,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2A2A2A) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: () {},
        style: IconButton.styleFrom(
          overlayColor: Colors.transparent,
        ),
        icon: SvgPicture.asset(
          svgPath,
          width: sizeWidth,
          height: sizeHeight,
          // colorFilter: ColorFilter.mode(
          //   isActive ? Colors.white : Colors.grey,
          //   BlendMode.srcIn,
          // ),
        ),
      ),
    );
  }
}