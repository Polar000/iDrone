import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/idrone_models.dart';

class SupabaseDataSource {
  final SupabaseClient? _client;

  SupabaseDataSource({SupabaseClient? client}) : _client = client;

  bool get isConnected => _client != null;

  Future<List<ParcelModel>> fetchParcels(String userId) async {
    if (_client == null) return [];
    final response = await _client.from('parcels').select().eq('user_id', userId);
    return (response as List<dynamic>).map((json) => ParcelModel.fromJson(json)).toList();
  }

  Future<void> saveParcel(ParcelModel parcel) async {
    if (_client == null) return;
    await _client.from('parcels').insert(parcel.toJson());
  }

  Future<List<BookingModel>> fetchBookings(String userId) async {
    if (_client == null) return [];
    final response = await _client.from('bookings').select().eq('user_id', userId);
    return (response as List<dynamic>).map((json) => BookingModel.fromJson(json)).toList();
  }

  Future<void> saveBooking(BookingModel booking) async {
    if (_client == null) return;
    await _client.from('bookings').insert(booking.toJson());
  }
}
