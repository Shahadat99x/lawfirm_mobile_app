import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/appointment_repository.dart';
import '../domain/appointment_models.dart';

// State class for booking
class BookingState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final DateTime? selectedDate;
  final String? selectedTime; // "09:00"
  final List<String> takenSlots;
  final String? bookingReferenceId;

  const BookingState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.selectedDate,
    this.selectedTime,
    this.takenSlots = const [],
    this.bookingReferenceId,
  });

  BookingState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
    DateTime? selectedDate,
    String? selectedTime,
    List<String>? takenSlots,
    String? bookingReferenceId,
  }) {
    return BookingState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      takenSlots: takenSlots ?? this.takenSlots,
      bookingReferenceId: bookingReferenceId ?? this.bookingReferenceId,
    );
  }
}

// Controller using ChangeNotifier
class AppointmentController extends ChangeNotifier {
  final Ref _ref;
  BookingState _state = const BookingState();

  AppointmentController(this._ref);

  BookingState get state => _state;

  AppointmentRepository get _repository => _ref.read(appointmentRepositoryProvider);

  void _updateState(BookingState newState) {
    _state = newState;
    notifyListeners();
  }

  void selectDate(DateTime date) async {
    _updateState(_state.copyWith(
      selectedDate: date,
      selectedTime: null,
      isLoading: true,
      error: null,
    ));

    try {
      final dateStr = date.toIso8601String().split('T').first;
      final availability = await _repository.getAvailability(dateStr);
      _updateState(_state.copyWith(
        isLoading: false,
        takenSlots: availability.takenSlots,
      ));
    } catch (e) {
      _updateState(_state.copyWith(
        isLoading: false,
        error: "Failed to load availability: ${e.toString()}",
      ));
    }
  }

  void selectTime(String time) {
    _updateState(_state.copyWith(selectedTime: time, error: null));
  }

  Future<void> bookAppointment(AppointmentRequest request) async {
    _updateState(_state.copyWith(isLoading: true, error: null));
    try {
      final success = await _repository.bookAppointment(request);
      if (success.ok) {
        _updateState(_state.copyWith(
          isLoading: false,
          isSuccess: true,
          bookingReferenceId: success.id,
        ));
      } else {
        throw Exception("Booking failed without error message");
      }
    } catch (e) {
      if (e.toString().contains("Slot already taken")) {
        if (_state.selectedDate != null) {
          selectDate(_state.selectedDate!);
        }
      }
      _updateState(_state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void reset() {
    _updateState(const BookingState());
  }
}

// Provider definition
final bookingControllerProvider = ChangeNotifierProvider.autoDispose<AppointmentController>((ref) {
  return AppointmentController(ref);
});
