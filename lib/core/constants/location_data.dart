import 'package:latlong2/latlong.dart';

class LocationData {
  static const Map<String, Map<String, LatLng>> countriesAndDepartments = {
    'Guatemala': {
      'Guatemala (Capital)': LatLng(14.6349, -90.5069),
      'Petén': LatLng(16.9120, -89.8910),
      'Alta Verapaz': LatLng(15.4802, -90.3739),
      'Escuintla': LatLng(14.3009, -90.7882),
      'Quetzaltenango': LatLng(14.8347, -91.5181),
      'Izabal': LatLng(15.5392, -88.8505),
      'Suchitepéquez': LatLng(14.5361, -91.4398),
      'Huehuetenango': LatLng(15.3197, -91.4708),
      'San Marcos': LatLng(14.9639, -91.7944),
      'Zacapa': LatLng(14.9722, -89.5306),
    },
    'México': {
      'Ciudad de México': LatLng(19.4326, -99.1332),
      'Jalisco (Guadalajara)': LatLng(20.6597, -103.3496),
      'Sinaloa (Culiacán)': LatLng(24.8091, -107.3940),
      'Michoacán': LatLng(19.5665, -101.7068),
      'Sonora': LatLng(29.0729, -110.9559),
      'Guanajuato': LatLng(21.0190, -101.2574),
      'Veracruz': LatLng(19.1738, -96.1342),
    },
    'Colombia': {
      'Bogotá D.C.': LatLng(4.7110, -74.0721),
      'Valle del Cauca': LatLng(3.4516, -76.5320),
      'Antioquia': LatLng(6.2442, -75.5812),
      'Cundinamarca': LatLng(4.8624, -74.0340),
      'Meta': LatLng(4.1420, -73.6266),
    },
    'Argentina': {
      'Buenos Aires': LatLng(-34.6037, -58.3816),
      'Córdoba': LatLng(-31.4201, -64.1888),
      'Santa Fe': LatLng(-31.6333, -60.7000),
      'Mendoza': LatLng(-32.8895, -68.8458),
    },
  };
}
