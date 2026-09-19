import 'package:flutter_test/flutter_test.dart';
import 'package:idrone/data/repositories/app_store.dart';
import 'package:idrone/data/models/idrone_models.dart';

void main() {
  group('iDrone AppStore Unit Tests', () {
    late AppStore store;

    setUp(() {
      store = AppStore();
    });

    test('Initial store contains default services and user', () {
      expect(store.currentUser.role, equals(UserRole.cliente));
      expect(store.services.length, greaterThan(0));
      expect(store.parcels.length, greaterThan(0));
    });

    test('Role switching updates user role', () {
      store.switchUserRole(UserRole.operador);
      expect(store.currentUser.role, equals(UserRole.operador));

      store.switchUserRole(UserRole.superAdmin);
      expect(store.currentUser.role, equals(UserRole.superAdmin));
    });

    test('Adding and removing parcels works correctly', () {
      final initialCount = store.parcels.length;
      final newParcel = ParcelModel(
        id: 'test_p1',
        userId: 'user_001',
        name: 'Campo Test',
        cropType: 'Trigo',
        areaHectares: 50.0,
        perimeterMeters: 2000.0,
        locationName: 'Zona Test',
        points: [],
        createdAt: DateTime.now(),
      );

      store.addParcel(newParcel);
      expect(store.parcels.length, equals(initialCount + 1));

      store.deleteParcel('test_p1');
      expect(store.parcels.length, equals(initialCount));
    });

    test('Quote subtotal calculation is accurate', () {
      final srv = store.services.first;
      final total = store.calculateQuoteSubtotal(srv.id, 10.0);
      expect(total, equals(srv.basePricePerHectare * 10.0));
    });
  });
}
