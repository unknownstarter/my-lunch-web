import 'package:flutter/material.dart';

class PriceRangeSlider extends StatelessWidget {
  final double value;
  final Function(double) onChanged;

  const PriceRangeSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  String _getPriceLabel(double value) {
    if (value <= 1) return '1만원 미만';
    if (value <= 2) return '2만원대';
    return '3만원 이상';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.black,
            inactiveTrackColor: Colors.grey[300],
            thumbColor: Colors.black,
            overlayColor: Colors.black.withOpacity(0.1),
            valueIndicatorColor: Colors.black,
            valueIndicatorTextStyle: const TextStyle(color: Colors.white),
          ),
          child: Slider(
            value: value,
            min: 1,
            max: 3,
            divisions: 2,
            label: _getPriceLabel(value),
            onChanged: onChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1만원 미만', style: TextStyle(color: Colors.grey[600])),
              Text('2만원대', style: TextStyle(color: Colors.grey[600])),
              Text('3만원 이상', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
      ],
    );
  }
}
