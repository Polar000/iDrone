enum UserRole {
  cliente,
  operador,
  adminOperaciones,
  superAdmin,
}

extension UserRoleX on UserRole {
  String toValue() => name;

  static UserRole fromValue(String value) {
    switch (value.toLowerCase()) {
      case 'operador':
        return UserRole.operador;
      case 'adminoperaciones':
      case 'admin_operaciones':
        return UserRole.adminOperaciones;
      case 'superadmin':
      case 'super_admin':
        return UserRole.superAdmin;
      case 'cliente':
      default:
        return UserRole.cliente;
    }
  }

  String get displayName {
    switch (this) {
      case UserRole.cliente:
        return 'Cliente Agrícola';
      case UserRole.operador:
        return 'Operador Drone';
      case UserRole.adminOperaciones:
        return 'Admin Operaciones';
      case UserRole.superAdmin:
        return 'Super Admin';
    }
  }
}

class UserModel {
  final String id;
  final String email;
  final String name;
  final String phone;
  final UserRole role;
  final String? avatarUrl;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.role,
    this.avatarUrl,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String? ?? '',
      role: UserRoleX.fromValue(json['role'] as String? ?? 'cliente'),
      avatarUrl: json['avatar_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role.toValue(),
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    UserRole? role,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ParcelPoint {
  final double latitude;
  final double longitude;

  ParcelPoint({required this.latitude, required this.longitude});

  factory ParcelPoint.fromJson(Map<String, dynamic> json) {
    return ParcelPoint(
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'lat': latitude,
        'lng': longitude,
      };
}

class ParcelModel {
  final String id;
  final String userId;
  final String name;
  final String cropType;
  final double areaHectares;
  final double perimeterMeters;
  final String locationName;
  final List<ParcelPoint> points;
  final DateTime createdAt;

  ParcelModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.cropType,
    required this.areaHectares,
    required this.perimeterMeters,
    required this.locationName,
    required this.points,
    required this.createdAt,
  });

  factory ParcelModel.fromJson(Map<String, dynamic> json) {
    final pointsList = (json['points'] as List<dynamic>?)
            ?.map((p) => ParcelPoint.fromJson(p as Map<String, dynamic>))
            .toList() ??
        [];

    return ParcelModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      cropType: json['crop_type'] as String,
      areaHectares: (json['area_hectares'] as num).toDouble(),
      perimeterMeters: (json['perimeter_meters'] as num? ?? 0.0).toDouble(),
      locationName: json['location_name'] as String? ?? 'Ubicación registrada',
      points: pointsList,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'crop_type': cropType,
        'area_hectares': areaHectares,
        'perimeter_meters': perimeterMeters,
        'location_name': locationName,
        'points': points.map((p) => p.toJson()).toList(),
        'created_at': createdAt.toIso8601String(),
      };
}

class ServiceModel {
  final String id;
  final String name;
  final String description;
  final double basePricePerHectare;
  final String iconName;
  final String imageUrl;
  final String estimatedDuration;
  final bool isAvailable;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.basePricePerHectare,
    required this.iconName,
    required this.imageUrl,
    required this.estimatedDuration,
    required this.isAvailable,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      basePricePerHectare: (json['base_price_per_hectare'] as num).toDouble(),
      iconName: json['icon_name'] as String? ?? 'agriculture',
      imageUrl: json['image_url'] as String? ?? '',
      estimatedDuration: json['estimated_duration'] as String? ?? '2 horas',
      isAvailable: json['is_available'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'base_price_per_hectare': basePricePerHectare,
        'icon_name': iconName,
        'image_url': imageUrl,
        'estimated_duration': estimatedDuration,
        'is_available': isAvailable,
      };
}

enum BookingStatus {
  draft,
  pendingPayment,
  confirmed,
  scheduled,
  inProgress,
  completed,
  cancelled,
  rescheduled,
}

extension BookingStatusX on BookingStatus {
  String toValue() => name;

  static BookingStatus fromValue(String value) {
    switch (value.toLowerCase()) {
      case 'pendingpayment':
      case 'pending_payment':
        return BookingStatus.pendingPayment;
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'scheduled':
        return BookingStatus.scheduled;
      case 'inprogress':
      case 'in_progress':
        return BookingStatus.inProgress;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      case 'rescheduled':
        return BookingStatus.rescheduled;
      case 'draft':
      default:
        return BookingStatus.draft;
    }
  }
}

class BookingModel {
  final String id;
  final String userId;
  final String serviceId;
  final String parcelId;
  final String cropType;
  final double areaHectares;
  final DateTime scheduledDate;
  final double subtotal;
  final double discount;
  final double total;
  final double paidAmount;
  final BookingStatus status;
  final String? operatorId;
  final String? droneId;
  final String? notes;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.parcelId,
    required this.cropType,
    required this.areaHectares,
    required this.scheduledDate,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.paidAmount,
    required this.status,
    this.operatorId,
    this.droneId,
    this.notes,
    required this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      serviceId: json['service_id'] as String,
      parcelId: json['parcel_id'] as String,
      cropType: json['crop_type'] as String,
      areaHectares: (json['area_hectares'] as num).toDouble(),
      scheduledDate: DateTime.parse(json['scheduled_date'] as String),
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: (json['discount'] as num? ?? 0.0).toDouble(),
      total: (json['total'] as num).toDouble(),
      paidAmount: (json['paid_amount'] as num? ?? 0.0).toDouble(),
      status: BookingStatusX.fromValue(json['status'] as String? ?? 'draft'),
      operatorId: json['operator_id'] as String?,
      droneId: json['drone_id'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'service_id': serviceId,
        'parcel_id': parcelId,
        'crop_type': cropType,
        'area_hectares': areaHectares,
        'scheduled_date': scheduledDate.toIso8601String(),
        'subtotal': subtotal,
        'discount': discount,
        'total': total,
        'paid_amount': paidAmount,
        'status': status.toValue(),
        'operator_id': operatorId,
        'drone_id': droneId,
        'notes': notes,
        'created_at': createdAt.toIso8601String(),
      };

  BookingModel copyWith({
    String? id,
    String? userId,
    String? serviceId,
    String? parcelId,
    String? cropType,
    double? areaHectares,
    DateTime? scheduledDate,
    double? subtotal,
    double? discount,
    double? total,
    double? paidAmount,
    BookingStatus? status,
    String? operatorId,
    String? droneId,
    String? notes,
    DateTime? createdAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      serviceId: serviceId ?? this.serviceId,
      parcelId: parcelId ?? this.parcelId,
      cropType: cropType ?? this.cropType,
      areaHectares: areaHectares ?? this.areaHectares,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      paidAmount: paidAmount ?? this.paidAmount,
      status: status ?? this.status,
      operatorId: operatorId ?? this.operatorId,
      droneId: droneId ?? this.droneId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class OperatorModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String status; // 'disponible', 'en_servicio', 'fuera_de_turno'
  final String? assignedDroneId;

  OperatorModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.status,
    this.assignedDroneId,
  });

  factory OperatorModel.fromJson(Map<String, dynamic> json) => OperatorModel(
        id: json['id'] as String,
        name: json['name'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String,
        status: json['status'] as String? ?? 'disponible',
        assignedDroneId: json['assigned_drone_id'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'status': status,
        'assigned_drone_id': assignedDroneId,
      };
}

class DroneModel {
  final String id;
  final String identifier;
  final String model;
  final String status; // 'disponible', 'en_servicio', 'mantenimiento'
  final double flightHours;
  final String? currentOperatorId;

  DroneModel({
    required this.id,
    required this.identifier,
    required this.model,
    required this.status,
    required this.flightHours,
    this.currentOperatorId,
  });

  factory DroneModel.fromJson(Map<String, dynamic> json) => DroneModel(
        id: json['id'] as String,
        identifier: json['identifier'] as String,
        model: json['model'] as String,
        status: json['status'] as String? ?? 'disponible',
        flightHours: (json['flight_hours'] as num? ?? 0.0).toDouble(),
        currentOperatorId: json['current_operator_id'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'identifier': identifier,
        'model': model,
        'status': status,
        'flight_hours': flightHours,
        'current_operator_id': currentOperatorId,
      };
}

class ServiceTrackingModel {
  final String bookingId;
  final String currentPhase; // 'preparando', 'en_camino', 'en_sitio', 'en_curso', 'finalizando', 'completado'
  final double progressPercentage; // 0.0 to 100.0
  final double droneLat;
  final double droneLng;
  final double coveredAreaHectares;
  final String estimatedTimeRemaining;

  ServiceTrackingModel({
    required this.bookingId,
    required this.currentPhase,
    required this.progressPercentage,
    required this.droneLat,
    required this.droneLng,
    required this.coveredAreaHectares,
    required this.estimatedTimeRemaining,
  });
}

class WeatherModel {
  final double temperature;
  final double humidity;
  final double windSpeedKmH;
  final double rainProbability;
  final String condition;
  final bool isFavorableForDrone;

  WeatherModel({
    required this.temperature,
    required this.humidity,
    required this.windSpeedKmH,
    required this.rainProbability,
    required this.condition,
    required this.isFavorableForDrone,
  });
}

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final DateTime createdAt;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });
}

class AuditLogModel {
  final String id;
  final String userName;
  final String action;
  final String entity;
  final DateTime timestamp;

  AuditLogModel({
    required this.id,
    required this.userName,
    required this.action,
    required this.entity,
    required this.timestamp,
  });
}
