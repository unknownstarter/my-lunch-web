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
    if (value <= 1) return '만원 미만';
    if (value <= 2) return '2만원대';
    return '3만원 이상';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            '가격대',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Slider(
          value: value,
          min: 0,
          max: 3,
          divisions: 3,
          label: _getPriceLabel(value),
          onChanged: onChanged,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('만원 미만', style: TextStyle(color: Colors.grey[600])),
              Text('1-2만원', style: TextStyle(color: Colors.grey[600])),
              Text('2-3만원', style: TextStyle(color: Colors.grey[600])),
              Text('3만원↑', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
      ],
    );
  }
}
