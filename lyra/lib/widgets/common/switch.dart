import 'package:flutter/material.dart';

class FancyToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const FancyToggle({super.key, required this.value, required this.onChanged});

  @override
  State<FancyToggle> createState() => _FancyToggleState();
}

class _FancyToggleState extends State<FancyToggle> {
  bool _isHover = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isOn = widget.value;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHover = true),
      onExit: (_) => setState(() => _isHover = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onChanged(!widget.value);
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,

          // ----- TRACK -----
          width: 45,
          height: 25,
          padding: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: isOn ? const Color(0xFFE53935) : const Color(0xFF9E9E9E),
            borderRadius: BorderRadius.circular(20),
            boxShadow: _isHover
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.15),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),

          // ----- THUMB -----
          child: AnimatedAlign(
            alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutBack,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: _isHover ? 20 : 18,
              height: _isHover ? 20 : 18,
              decoration: BoxDecoration(
                color: _isPressed
                    ? Colors.white.withOpacity(0.8)
                    : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
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
