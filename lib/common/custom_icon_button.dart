import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback? onTap;

  const CustomIconButton({
    Key? key,
    required this.icon,
    this.color = const Color.fromARGB(255, 4, 125, 141),
    this.size = 24,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Icon(
              icon,
              size: size,
              color: onTap != null ? color : Colors.grey[500],
            ),
          ),
        ),
      ),
    );
  }
}
