import 'package:flutter/material.dart';

class HeaderInfoSection extends StatelessWidget {
  final double imageSize;
  final Widget image;
  final BoxShape imageShape;
  final BorderRadius? imageBorderRadius;
  final BoxFit? imageFit;
  final Widget? type;
  final Widget title;
  final Widget? bio;
  final Widget? subtitle;
  final List<Widget>? actions;
  final Gradient? background;
  final double horizontalPadding;

  const HeaderInfoSection({
    super.key,
    required this.image,
    required this.title,
    this.type,
    this.bio,
    this.subtitle,
    this.actions,
    this.background,
    this.imageSize = 220,
    this.horizontalPadding = 35,
    this.imageShape = BoxShape.circle,
    this.imageBorderRadius,
    this.imageFit,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        // Background gradient
        Container(
          decoration: BoxDecoration(
            gradient:
                background ??
                LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withOpacity(0.3),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
          ),
        ),

        // Content
        Positioned(
          left: horizontalPadding,
          right: horizontalPadding,
          top: 0,
          bottom: 0,
          child: Align(
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Image / Avatar
                SizedBox(
                  width: imageSize,
                  height: imageSize,

                  child: ClipRRect(
                    borderRadius: imageShape == BoxShape.circle
                        ? BorderRadius.circular(imageSize / 2)
                        : (imageBorderRadius ?? BorderRadius.circular(16)),
                    child: FittedBox(
                      fit: imageFit ?? BoxFit.cover,
                      child: image,
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                // Texts + actions — allow vertical scrolling when space is constrained
                Expanded(
                  child: SingleChildScrollView(
                    primary: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (type != null) ...[type!],
                        title,

                        if (subtitle != null) ...[subtitle!],
                        if (bio != null) ...[bio!],
                        if (actions != null && actions!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: actions!
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: e,
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
