import 'package:flutter/material.dart';

class FoodTypeSelector extends StatelessWidget {
  final List<String> selectedTypes;
  final Function(List<String>) onSelectionChanged;

  const FoodTypeSelector({
    super.key,
    required this.selectedTypes,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final foodTypes = ['한식', '양식', '일식', '중식'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '선호하는 음식 종류',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: foodTypes.map((type) {
            final isSelected = selectedTypes.contains(type);
            return FilterChip(
              selected: isSelected,
              label: Text(type),
              onSelected: (selected) {
                final newSelection = List<String>.from(selectedTypes);
                if (selected) {
                  newSelection.add(type);
                } else {
                  newSelection.remove(type);
                }
                onSelectionChanged(newSelection);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
