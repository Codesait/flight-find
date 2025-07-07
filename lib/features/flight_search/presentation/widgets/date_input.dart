import 'package:flutter/material.dart';

class DateInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;

  const DateInputField({
    super.key,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50, // Light blue background
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: true, // Make it read-only so date picker is the only input
        decoration: InputDecoration(
          labelText: 'Departure Date',
          labelStyle: TextStyle(color: Colors.blueGrey.shade700),
          border: InputBorder.none, // No border for TextFormField
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
        ),
        onTap: onTap,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}
