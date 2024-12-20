import 'package:flutter/material.dart';

class PreferenceSelector extends StatelessWidget {
  final String? selectedPreference;
  final Function(String) onSelected;

  const PreferenceSelector({
    super.key,
    required this.selectedPreference,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final preferences = ['매운맛', '다이어트', '해장', '혼밥 가능', '소개팅', '미팅', '건강식'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '기타 선호도',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: preferences.map((pref) {
            return ChoiceChip(
              selected: selectedPreference == pref,
              label: Text(pref),
              onSelected: (selected) {
                if (selected) onSelected(pref);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
