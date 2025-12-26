import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/utils/api_client.dart';
import '../domain/appointment_models.dart';

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  return AppointmentRepository(ApiClient().client);
});

class AppointmentRepository {
  final Dio _client;

  AppointmentRepository(this._client);

  /// Fetches taken slots for a given date (YYYY-MM-DD).
  Future<AvailabilityResponse> getAvailability(String date) async {
    try {
      final response = await _client.get(
        '/api/appointments/availability',
        queryParameters: {'date': date},
      );
      return AvailabilityResponse.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Submits a new appointment booking.
  Future<BookingSuccess> bookAppointment(AppointmentRequest request) async {
    try {
      final response = await _client.post(
        '/api/appointments',
        data: request.toJson(),
      );
      return BookingSuccess.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response?.statusCode == 409) {
        return Exception('Slot already taken');
      }
      return Exception(
          error.response?.data['error'] ?? 'Network error occurred');
    }
    return Exception('Unknown error occurred');
  }
}
