import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/theme/app_colors.dart';
import 'domain/appointment_models.dart';
import 'presentation/appointment_controller.dart';
import 'presentation/widgets/date_selection_widget.dart';
import 'presentation/widgets/time_slot_grid.dart';
import 'presentation/widgets/booking_form.dart';

class AppointmentScreen extends ConsumerWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(bookingControllerProvider);
    final state = controller.state;

    // Listener for errors
    ref.listen(bookingControllerProvider, (previous, next) {
      if (next.state.error != null && !next.state.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.state.error!),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    if (state.isSuccess) {
      return _SuccessView(
        referenceId: state.bookingReferenceId,
        onReset: controller.reset,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DateSelectionWidget(
              selectedDate: state.selectedDate,
              onDateSelected: controller.selectDate,
            ),
             const SizedBox(height: 24),
            // Show slots only if date is selected
            if (state.selectedDate != null) ...[
              TimeSlotGrid(
                selectedTime: state.selectedTime,
                takenSlots: state.takenSlots,
                onTimeSelected: controller.selectTime,
                isLoading: state.isLoading && state.selectedTime == null, // Loading slots
              ),
              const SizedBox(height: 24),
            ],
            // Show form only if time is selected
            if (state.selectedDate != null && state.selectedTime != null) ...[
              BookingForm(
                isLoading: state.isLoading && state.selectedTime != null, // Loading submission
                onSubmit: (name, email, phone, practice, message, gdpr) {
                  final request = AppointmentRequest(
                    fullName: name,
                    email: email,
                    phone: phone,
                    practiceAreaSlug: practice,
                    message: message,
                    gdprConsent: gdpr,
                    appointmentDate: state.selectedDate!.toIso8601String().split('T').first,
                    appointmentTime: state.selectedTime!,
                  );
                  controller.bookAppointment(request);
                },
              ),
              const SizedBox(height: 40), // Bottom padding
            ],
          ],
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final String? referenceId;
  final VoidCallback onReset;

  const _SuccessView({this.referenceId, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
              const SizedBox(height: 24),
              Text(
                'Booking Confirmed!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your appointment request has been sent successfully.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (referenceId != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: SelectableText(
                    'Ref ID: $referenceId',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Courier'),
                  ),
                ),
              ],
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onReset,
                  child: const Text('Book Another'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
