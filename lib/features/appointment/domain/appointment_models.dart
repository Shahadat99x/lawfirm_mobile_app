class AppointmentRequest {
  final String fullName;
  final String email;
  final String? phone;
  final String practiceAreaSlug;
  final String? message;
  final bool gdprConsent;
  final String appointmentDate; // YYYY-MM-DD
  final String appointmentTime; // HH:MM

  AppointmentRequest({
    required this.fullName,
    required this.email,
    this.phone,
    required this.practiceAreaSlug,
    this.message,
    required this.gdprConsent,
    required this.appointmentDate,
    required this.appointmentTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'practice_area_slug': practiceAreaSlug,
      'message': message,
      'gdpr_consent': gdprConsent,
      'appointment_date': appointmentDate,
      'appointment_time': appointmentTime,
    };
  }
}

class AvailabilityResponse {
  final List<String> takenSlots;

  AvailabilityResponse({required this.takenSlots});

  factory AvailabilityResponse.fromJson(Map<String, dynamic> json) {
    return AvailabilityResponse(
      takenSlots: List<String>.from(json['takenSlots'] ?? []),
    );
  }
}

class BookingSuccess {
  final bool ok;
  final String id;

  BookingSuccess({required this.ok, required this.id});

  factory BookingSuccess.fromJson(Map<String, dynamic> json) {
    return BookingSuccess(
      ok: json['ok'] ?? false,
      id: json['id'] ?? '',
    );
  }
}
