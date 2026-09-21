class AppConfig {
  static const String appName = 'iDrone Platform';
  static const String appVersion = '1.0.0';

  // Supabase Configuration
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://xyzproductidrone.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.dummy_anon_key',
  );

  // Payment Gateways
  static const String stripePublishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: 'pk_test_sample_stripe_key',
  );

  static const String mercadoPagoPublicKey = String.fromEnvironment(
    'MERCADOPAGO_PUBLIC_KEY',
    defaultValue: 'APP_USR_sample_mercadopago_key',
  );

  // External APIs & Maps
  static const String esriTileUrl =
      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';

  static const String openStreetMapTileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  static const String openWeatherApiKey = String.fromEnvironment(
    'OPENWEATHER_API_KEY',
    defaultValue: 'sample_openweather_api_key',
  );

  // Push Notifications
  static const String fcmVapidKey = String.fromEnvironment(
    'FCM_VAPID_KEY',
    defaultValue: 'sample_fcm_vapid_key',
  );
}
