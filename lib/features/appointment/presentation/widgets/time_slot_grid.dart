import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';

class TimeSlotGrid extends StatelessWidget {
  final String? selectedTime;
  final List<String> takenSlots;
  final Function(String) onTimeSelected;
  final bool isLoading;

  const TimeSlotGrid({
    super.key,
    required this.selectedTime,
    required this.takenSlots,
    required this.onTimeSelected,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Generate slots 09:00 to 16:30
    final slots = [
      "09:00", "09:30", "10:00", "10:30",
      "11:00", "11:30", "12:00", "12:30",
      "13:00", "13:30", "14:00", "14:30",
      "15:00", "15:30", "16:00", "16:30"
    ];

    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Time',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 2.2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: slots.length,
          itemBuilder: (context, index) {
            final slot = slots[index];
            final isTaken = takenSlots.contains(slot);
            final isSelected = slot == selectedTime;

            return AbsorbPointer(
              absorbing: isTaken,
              child: InkWell(
                onTap: () => onTimeSelected(slot),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : isTaken
                            ? Theme.of(context).disabledColor.withOpacity(0.1)
                            : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : isTaken
                              ? Colors.transparent
                              : Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    slot,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : isTaken
                              ? Colors.grey.withOpacity(0.5)
                              : Theme.of(context).textTheme.bodyMedium?.color,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      decoration: isTaken ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
