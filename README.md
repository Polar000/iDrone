# iDRONE — Plataforma Agrícola Integral

Plataforma profesional para la gestión y ejecución de servicios agrícolas mediante drones, construida con **Flutter** y **Dart**.

---

## 🚀 Requisitos Previos

- **Flutter SDK**: 3.10.0 o superior ([Guía de instalación de Flutter](https://docs.flutter.dev/get-started/install))
- **Dart SDK**: Incluido con Flutter.
- Un navegador web (Chrome / Edge / Firefox) o un simulador/dispositivo (Android, iOS, macOS, Windows, Linux).

---

## 🛠️ Cómo Levantar la Aplicación

### 1. Clonar el repositorio e instalar dependencias

```bash
git clone <URL_DEL_REPOSITO>
cd idrone
flutter pub get
```

### 2. Ejecutar en Web (Recomendado para probar Admin y Cliente en paralelo)

```bash
flutter run -d chrome
```

### 3. Ejecutar en Dispositivo o Emulador Móvil / Desktop

Para listar los dispositivos disponibles:
```bash
flutter devices
```

Para ejecutar en un dispositivo específico (ej. Android o macOS):
```bash
flutter run -d android
# o
flutter run -d macos
```

---

## 🧪 Pruebas Unitarias y Análisis Estático

Para validar el código y ejecutar las pruebas automatizadas:

```bash
# Ejecutar análisis estático de código
flutter analyze

# Ejecutar la suite de pruebas unitarias y de widgets
flutter test
```

---

## 👥 Cambio y Prueba de Roles

Dentro de la aplicación puedes alternar dinámicamente entre los diferentes módulos y pantallas según el rol seleccionado:

1. **CLIENTE**:
   - Accede al panel principal, catálogo de servicios, trazado interactivo de parcelas en mapa y cotizador en 5 pasos.
2. **OPERADOR**:
   - Accede al panel de piloto con misiones asignadas, control de estados de vuelo y registro de evidencia.
3. **ADMIN / SUPER ADMIN**:
   - Accede a la plataforma SaaS administrativa con métricas, flota de drones, auditoría de logs y asignaciones.

Puedes cambiar de rol en la pantalla de **Login** o desde la pestaña de **Perfil** en la aplicación.
