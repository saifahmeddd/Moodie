import 'package:flutter/material.dart';

class JournalReminderDropdown extends StatefulWidget {
  final String initialValue;
  final Function(String) onChanged;

  const JournalReminderDropdown({
    Key? key,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<JournalReminderDropdown> createState() =>
      _JournalReminderDropdownState();
}

class _JournalReminderDropdownState extends State<JournalReminderDropdown> {
  late String _selectedValue;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.indigo[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selectedValue,
                  style: TextStyle(fontSize: 14, color: Colors.indigo[800]),
                ),
                const SizedBox(width: 4),
                Icon(
                  _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.indigo[800],
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDropdownItem("Daily"),
                _buildDropdownItem("Weekly"),
                _buildDropdownItem("Off"),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDropdownItem(String value) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedValue = value;
          _isExpanded = false;
        });
        widget.onChanged(value);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color:
                _selectedValue == value ? Colors.indigo[800] : Colors.black87,
            fontWeight:
                _selectedValue == value ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// Usage example in the ProfileScreen:
// JournalReminderDropdown(
//   initialValue: journalPromptFrequency,
//   onChanged: (value) {
//     setState(() {
//       journalPromptFrequency = value;
//     });
//   },
// )
