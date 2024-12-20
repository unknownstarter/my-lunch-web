import 'package:flutter/material.dart';

class FoodTypeSelector extends StatelessWidget {
  final List<String> selectedTypes;
  final Function(List<String>) onChanged;

  const FoodTypeSelector({
    super.key,
    required this.selectedTypes,
    required this.onChanged,
  });

  static const foodTypes = [
    '한식',
    '중식',
    '일식',
    '양식',
    '분식',
    '카페',
    '패스트푸드',
    '치킨',
    '피자',
    '고기',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            '음식 종류',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
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
                onChanged(newSelection);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
