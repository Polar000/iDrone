import 'package:flutter/material.dart';
import '../models/idrone_models.dart';

class PlatformSettings {
  double depositPercentage; // e.g. 0.25 (25%)
  String activePromoCoupon;
  double promoDiscountAmount;
  String heroBannerImageUrl;
  String readinessDisclaimerText;

  PlatformSettings({
    this.depositPercentage = 0.25,
    this.activePromoCoupon = 'CAMPO2026',
    this.promoDiscountAmount = 1500.0,
    this.heroBannerImageUrl = 'https://images.unsplash.com/photo-1508614589041-895b88991e3e',
    this.readinessDisclaimerText =
        'El cliente confirma que tendrá el agua limpia y los productos/insumos agrícolas listos en la parcela al momento de llegada del dron.',
  });
}

class AppStore extends ChangeNotifier {
  // Global Platform Parametrization Settings
  final PlatformSettings platformSettings = PlatformSettings();

  // Current logged in user & Theme
  UserModel _currentUser = UserModel(
    id: 'user_001',
    email: 'cliente@idrone.com',
    name: 'Roberto Gómez',
    phone: '+52 55 1234 5678',
    role: UserRole.cliente,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
  );

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  UserModel get currentUser => _currentUser;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void updatePlatformSettings({
    double? depositPercentage,
    String? activePromoCoupon,
    double? promoDiscountAmount,
    String? heroBannerImageUrl,
    String? readinessDisclaimerText,
  }) {
    if (depositPercentage != null) platformSettings.depositPercentage = depositPercentage;
    if (activePromoCoupon != null) platformSettings.activePromoCoupon = activePromoCoupon;
    if (promoDiscountAmount != null) platformSettings.promoDiscountAmount = promoDiscountAmount;
    if (heroBannerImageUrl != null) platformSettings.heroBannerImageUrl = heroBannerImageUrl;
    if (readinessDisclaimerText != null) platformSettings.readinessDisclaimerText = readinessDisclaimerText;
    _logAudit('Parametrización global actualizada por Admin', 'Configuración');
    notifyListeners();
  }

  void updateServicePrice(String serviceId, double newBasePrice) {
    final idx = _services.indexWhere((s) => s.id == serviceId);
    if (idx != -1) {
      final old = _services[idx];
      _services[idx] = ServiceModel(
        id: old.id,
        name: old.name,
        description: old.description,
        basePricePerHectare: newBasePrice,
        iconName: old.iconName,
        imageUrl: old.imageUrl,
        estimatedDuration: old.estimatedDuration,
        isAvailable: old.isAvailable,
      );
      _logAudit('Precio de servicio ${old.name} actualizado a \$$newBasePrice/Ha', 'Tarifas');
      notifyListeners();
    }
  }

  void switchUserRole(UserRole newRole) {
    switch (newRole) {
      case UserRole.cliente:
        _currentUser = UserModel(
          id: 'user_001',
          email: 'cliente@idrone.com',
          name: 'Roberto Gómez',
          phone: '+52 55 1234 5678',
          role: UserRole.cliente,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        );
        break;
      case UserRole.operador:
        _currentUser = UserModel(
          id: 'op_101',
          email: 'carlos.operador@idrone.com',
          name: 'Carlos Ruiz',
          phone: '+52 55 9876 5432',
          role: UserRole.operador,
          createdAt: DateTime.now().subtract(const Duration(days: 90)),
        );
        break;
      case UserRole.adminOperaciones:
      case UserRole.superAdmin:
        _currentUser = UserModel(
          id: 'admin_99',
          email: 'admin@idrone.com',
          name: 'Admin Central',
          phone: '+52 55 0000 1111',
          role: newRole,
          createdAt: DateTime.now().subtract(const Duration(days: 365)),
        );
        break;
    }
    _logAudit('Cambio de rol activo', 'Sistema');
    notifyListeners();
  }

  // PARCELS
  final List<ParcelModel> _parcels = [
    ParcelModel(
      id: 'par_1',
      userId: 'user_001',
      name: 'Finca El Paraíso',
      cropType: 'Maíz',
      areaHectares: 120.5,
      perimeterMeters: 4500.0,
      locationName: 'Petén, Guatemala',
      points: [
        ParcelPoint(latitude: 16.9120, longitude: -89.8910),
        ParcelPoint(latitude: 16.9150, longitude: -89.8850),
        ParcelPoint(latitude: 16.9100, longitude: -89.8800),
        ParcelPoint(latitude: 16.9080, longitude: -89.8860),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    ParcelModel(
      id: 'par_2',
      userId: 'user_001',
      name: 'Lote San José',
      cropType: 'Agave Azul',
      areaHectares: 85.0,
      perimeterMeters: 3200.0,
      locationName: 'Jalisco, México',
      points: [
        ParcelPoint(latitude: 20.6597, longitude: -103.3496),
        ParcelPoint(latitude: 20.6620, longitude: -103.3450),
        ParcelPoint(latitude: 20.6550, longitude: -103.3420),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  List<ParcelModel> get parcels => List.unmodifiable(_parcels);

  void addParcel(ParcelModel parcel) {
    _parcels.add(parcel);
    _logAudit('Parcela registrada: ${parcel.name}', 'Parcela');
    notifyListeners();
  }

  void updateParcel(ParcelModel updated) {
    final idx = _parcels.indexWhere((p) => p.id == updated.id);
    if (idx != -1) {
      _parcels[idx] = updated;
      _logAudit('Parcela actualizada: ${updated.name}', 'Parcela');
      notifyListeners();
    }
  }

  void deleteParcel(String parcelId) {
    _parcels.removeWhere((p) => p.id == parcelId);
    _logAudit('Parcela eliminada', 'Parcela');
    notifyListeners();
  }

  // SERVICES
  final List<ServiceModel> _services = [
    ServiceModel(
      id: 'srv_1',
      name: 'Fumigación Agrícola',
      description: 'Aplicación ultralocalizada de fitosanitarios con drones de alta precisión.',
      basePricePerHectare: 250.0,
      iconName: 'cleaning_services',
      imageUrl: 'https://images.unsplash.com/photo-1508614589041-895b88991e3e',
      estimatedDuration: '2.5 hrs/100ha',
      isAvailable: true,
    ),
    ServiceModel(
      id: 'srv_2',
      name: 'Abonado y Sólidos',
      description: 'Dispersión granular homogénea de fertilizantes y semillas.',
      basePricePerHectare: 300.0,
      iconName: 'grass',
      imageUrl: 'https://images.unsplash.com/photo-1500382017468-9049fed747ef',
      estimatedDuration: '3 hrs/100ha',
      isAvailable: true,
    ),
    ServiceModel(
      id: 'srv_3',
      name: 'Fertilización Foliar',
      description: 'Nutrición directa al follaje con microgotas optimizadas.',
      basePricePerHectare: 280.0,
      iconName: 'eco',
      imageUrl: 'https://images.unsplash.com/photo-1625246333195-78d9c38ad449',
      estimatedDuration: '2 hrs/100ha',
      isAvailable: true,
    ),
    ServiceModel(
      id: 'srv_4',
      name: 'Monitoreo Multiespectral',
      description: 'Índice NDVI, estrés hídrico y conteo computacional de cultivos.',
      basePricePerHectare: 180.0,
      iconName: 'sensors',
      imageUrl: 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46',
      estimatedDuration: '1.5 hrs/100ha',
      isAvailable: true,
    ),
  ];

  List<ServiceModel> get services => List.unmodifiable(_services);

  // BOOKINGS
  final List<BookingModel> _bookings = [
    BookingModel(
      id: 'bk_1001',
      userId: 'user_001',
      serviceId: 'srv_1',
      parcelId: 'par_1',
      cropType: 'Maíz',
      areaHectares: 120.5,
      scheduledDate: DateTime.now().add(const Duration(days: 1)),
      subtotal: 30125.0,
      discount: 1500.0,
      total: 28625.0,
      paidAmount: 7156.25, // 25% deposit
      status: BookingStatus.confirmed,
      operatorId: 'op_101',
      droneId: 'dr_03',
      notes: 'Producto: Fungicida Karate 500ml/Ha (Cliente provee agua y producto)',
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
  ];

  List<BookingModel> get bookings => List.unmodifiable(_bookings);

  void addBooking(BookingModel booking) {
    _bookings.add(booking);
    _logAudit('Reserva creada: #${booking.id}', 'Reserva');
    _addNotification('Reserva Solicitada', 'Tu solicitud #${booking.id} ha sido registrada con éxito.');
    notifyListeners();
  }

  void updateBookingStatus(String bookingId, BookingStatus newStatus) {
    final idx = _bookings.indexWhere((b) => b.id == bookingId);
    if (idx != -1) {
      final old = _bookings[idx];
      _bookings[idx] = old.copyWith(status: newStatus);
      _logAudit('Estado de reserva #${old.id} actualizado a ${newStatus.name}', 'Reserva');
      _addNotification('Actualización de Servicio', 'Tu servicio #${old.id} ahora está: ${newStatus.name}');
      notifyListeners();
    }
  }

  void assignOperatorAndDrone(String bookingId, String operatorId, String droneId) {
    final idx = _bookings.indexWhere((b) => b.id == bookingId);
    if (idx != -1) {
      final old = _bookings[idx];
      _bookings[idx] = old.copyWith(
        operatorId: operatorId,
        droneId: droneId,
        status: BookingStatus.scheduled,
      );
      _logAudit('Operador y Drone asignados a reserva #${old.id}', 'Operaciones');
      notifyListeners();
    }
  }

  // OPERATORS & DRONES
  final List<OperatorModel> _operators = [
    OperatorModel(
      id: 'op_101',
      name: 'Carlos Ruiz',
      phone: '+52 55 9876 5432',
      email: 'carlos.operador@idrone.com',
      status: 'disponible',
      assignedDroneId: 'dr_03',
    ),
    OperatorModel(
      id: 'op_102',
      name: 'María Fernández',
      phone: '+52 55 8888 7777',
      email: 'maria.f@idrone.com',
      status: 'en_servicio',
      assignedDroneId: 'dr_01',
    ),
  ];

  List<OperatorModel> get operators => List.unmodifiable(_operators);

  final List<DroneModel> _drones = [
    DroneModel(
      id: 'dr_01',
      identifier: 'DRONE-AG-01',
      model: 'DJI Agras T40',
      status: 'en_servicio',
      flightHours: 142.5,
      currentOperatorId: 'op_102',
    ),
    DroneModel(
      id: 'dr_03',
      identifier: 'DRONE-AG-03',
      model: 'DJI Agras T30',
      status: 'disponible',
      flightHours: 88.0,
      currentOperatorId: 'op_101',
    ),
  ];

  List<DroneModel> get drones => List.unmodifiable(_drones);

  // NOTIFICATIONS
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: 'notif_1',
      userId: 'user_001',
      title: 'Bienvenido a iDrone',
      message: 'Gestiona tus cultivos y solicita servicios de aplicación aérea con drones.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: false,
    ),
  ];

  List<NotificationModel> get notifications => List.unmodifiable(_notifications);

  void markNotificationAsRead(String id) {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notifications[idx].isRead = true;
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void _addNotification(String title, String message) {
    _notifications.insert(
      0,
      NotificationModel(
        id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        userId: _currentUser.id,
        title: title,
        message: message,
        createdAt: DateTime.now(),
      ),
    );
  }

  // AUDIT LOGS
  final List<AuditLogModel> _auditLogs = [];

  List<AuditLogModel> get auditLogs => List.unmodifiable(_auditLogs);

  void _logAudit(String action, String entity) {
    _auditLogs.insert(
      0,
      AuditLogModel(
        id: 'audit_${DateTime.now().millisecondsSinceEpoch}',
        userName: _currentUser.name,
        action: action,
        entity: entity,
        timestamp: DateTime.now(),
      ),
    );
  }

  // PRICING CALCULATOR
  double calculateQuoteSubtotal(String serviceId, double hectares) {
    final srv = _services.firstWhere((s) => s.id == serviceId, orElse: () => _services.first);
    return srv.basePricePerHectare * hectares;
  }
}
