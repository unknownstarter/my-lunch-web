import 'package:flutter/material.dart';

class DistanceSlider extends StatelessWidget {
  final double value;
  final Function(double) onChanged;

  const DistanceSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  String _getDistanceLabel(double value) {
    if (value <= 5) return '5분 이내';
    if (value <= 10) return '10분';
    if (value <= 15) return '15분';
    return '20분 이상';
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
            min: 5,
            max: 20,
            divisions: 3,
            label: _getDistanceLabel(value),
            onChanged: onChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('5분', style: TextStyle(color: Colors.grey[600])),
              Text('10분', style: TextStyle(color: Colors.grey[600])),
              Text('15분', style: TextStyle(color: Colors.grey[600])),
              Text('20분', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
      ],
    );
  }
}
