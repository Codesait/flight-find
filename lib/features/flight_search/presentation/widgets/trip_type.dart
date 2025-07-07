import 'package:flight_search/components/shared/custom_text.dart';
import 'package:flutter/material.dart';

class TripTypeSegmentControl extends StatefulWidget {
  final String selectedValue;
  final ValueChanged<String> onChanged;

  const TripTypeSegmentControl({super.key, 
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  State<TripTypeSegmentControl> createState() =>
      _TripTypeSegmentControlState();
}

class _TripTypeSegmentControlState extends State<TripTypeSegmentControl> {
  late String _currentSelection;

  @override
  void initState() {
    super.initState();
    _currentSelection = widget.selectedValue;
  }

  @override
  void didUpdateWidget(covariant TripTypeSegmentControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedValue != widget.selectedValue) {
      _currentSelection = widget.selectedValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            Colors.blue.shade50, // Light blue background for the whole control
        borderRadius: BorderRadius.circular(50),
      ),
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            ['One way', 'Round trip', 'Multi-City'].map((type) {
              bool isSelected = _currentSelection == type;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentSelection = type;
                    });
                    widget.onChanged(type);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(45),
                    ),
                    alignment: Alignment.center,
                    child: TextView(
                      text: type,
                      color:
                          isSelected ? Colors.black : Colors.blueGrey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
