import 'package:flutter/material.dart';

class FoodTypeSelector extends StatelessWidget {
  final String selectedType;
  final Function(String) onChanged;

  const FoodTypeSelector({
    super.key,
    required this.selectedType,
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
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: foodTypes.map((type) {
        return ChoiceChip(
          selected: selectedType == type,
          label: Text(type),
          onSelected: (selected) {
            onChanged(selected ? type : '');
          },
        );
      }).toList(),
    );
  }
}
