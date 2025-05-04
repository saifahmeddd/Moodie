import 'package:flutter/material.dart';

class DropdownOverlay extends StatelessWidget {
  final List<String> options;
  final String selected;
  final Function(String) onSelect;
  final double width;
  final Offset position;

  const DropdownOverlay({
    Key? key,
    required this.options,
    required this.selected,
    required this.onSelect,
    required this.width,
    required this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) => _buildOption(option)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildOption(String option) {
    final bool isSelected = option == selected;

    return InkWell(
      onTap: () => onSelect(option),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Text(
          option,
          style: TextStyle(
            color: isSelected ? Colors.indigo : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// Usage example:
// The dropdown overlay should be added to an Overlay or inserted into a Stack
// when the dropdown button is clicked. You'll need to calculate the position
// based on the RenderBox of the dropdown button.
