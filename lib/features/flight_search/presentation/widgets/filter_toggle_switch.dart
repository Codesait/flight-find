import 'package:flutter/material.dart';

class FilterToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const FilterToggleRow({super.key, 
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blue.shade700,
        ),
      ],
    );
  }
}