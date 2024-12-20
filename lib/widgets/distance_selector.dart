import 'package:flutter/material.dart';

class DistanceSelector extends StatelessWidget {
  final String? selectedDistance;
  final Function(String) onSelected;

  const DistanceSelector({
    super.key,
    required this.selectedDistance,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final distances = ['5분 이내', '10분', '15분', '20분 이상'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '거리 (도보 기준)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: distances.map((distance) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  selected: selectedDistance == distance,
                  label: Text(distance),
                  onSelected: (selected) {
                    if (selected) onSelected(distance);
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
