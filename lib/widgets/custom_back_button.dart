import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? iconColor;
  final double? iconSize;
  final EdgeInsets? padding;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.iconColor,
    this.iconSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
      icon: SvgPicture.asset(
        'assets/icons/arrow-left.svg',
        width: 22,
        height: 19,
        colorFilter:
            iconColor != null
                ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                : null,
        placeholderBuilder:
            (BuildContext context) => Icon(
              Icons.arrow_back,
              color: iconColor ?? Colors.black87,
              size: 22,
            ),
      ),
      padding: padding ?? EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}
