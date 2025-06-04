import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  final double size;
  final String? imagePath;
  final Color backgroundColor;
  final Color iconColor;

  const ProfilePicture({
    super.key,
    this.size = 80.0,
    this.imagePath,
    this.backgroundColor = const Color(0xFFBFD7FF),
    this.iconColor = const Color(0xFF2E7D32), // Green[800]
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child:
          imagePath != null && imagePath!.isNotEmpty
              ? ClipOval(
                child: Image.asset(
                  imagePath!,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                ),
              )
              : ClipOval(
                child: Icon(
                  Icons.person,
                  size: size * 0.625, // Proportion of icon to container
                  color: iconColor,
                ),
              ),
    );
  }
}
