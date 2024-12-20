import 'package:flutter/material.dart';

class PriceRangeSelector extends StatelessWidget {
  final String? selectedPrice;
  final Function(String) onSelected;

  const PriceRangeSelector({
    super.key,
    required this.selectedPrice,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final priceRanges = ['1만원 미만', '2만원대', '3만원 이상'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '가격대',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: priceRanges.map((price) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  selected: selectedPrice == price,
                  label: Text(price),
                  onSelected: (selected) {
                    if (selected) onSelected(price);
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
