import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/app_store.dart';
import '../../components/app_card.dart';
import '../../components/app_badges_and_stats.dart';
import '../../components/idrone_logo.dart';
import '../../app/theme/app_colors.dart';
import 'admin_calendar_screen.dart';

class AdminDashboardLayout extends StatefulWidget {
  const AdminDashboardLayout({super.key});

  @override
  State<AdminDashboardLayout> createState() => _AdminDashboardLayoutState();
}

class _AdminDashboardLayoutState extends State<AdminDashboardLayout> {
  int _selectedNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Row(
        children: [
          // SaaS Navigation Sidebar
          Container(
            width: 240,
            color: isDark ? AppColors.darkSurface : AppColors.deepForest,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: const [
                      IDroneLogoWidget(size: 40),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('iDRONE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                          Text('SaaS Admin', style: TextStyle(color: AppColors.limeAccent, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text('DASHBOARD', style: TextStyle(color: AppColors.limeAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                _SidebarItem(
                  icon: Icons.dashboard_rounded,
                  label: 'General & Métricas',
                  isSelected: _selectedNavIndex == 0,
                  onTap: () => setState(() => _selectedNavIndex = 0),
                ),
                _SidebarItem(
                  icon: Icons.tune_rounded,
                  label: 'Parametrización & Tarifas',
                  isSelected: _selectedNavIndex == 1,
                  onTap: () => setState(() => _selectedNavIndex = 1),
                ),
                _SidebarItem(
                  icon: Icons.calendar_month_rounded,
                  label: 'Calendario y Permisos',
                  isSelected: _selectedNavIndex == 2,
                  onTap: () => setState(() => _selectedNavIndex = 2),
                ),
                _SidebarItem(
                  icon: Icons.assignment_rounded,
                  label: 'Servicios y Reservas',
                  isSelected: _selectedNavIndex == 3,
                  onTap: () => setState(() => _selectedNavIndex = 3),
                ),
                _SidebarItem(
                  icon: Icons.flight_rounded,
                  label: 'Drones y Flota',
                  isSelected: _selectedNavIndex == 4,
                  onTap: () => setState(() => _selectedNavIndex = 4),
                ),
                _SidebarItem(
                  icon: Icons.people_rounded,
                  label: 'CRM Clientes',
                  isSelected: _selectedNavIndex == 5,
                  onTap: () => setState(() => _selectedNavIndex = 5),
                ),
                _SidebarItem(
                  icon: Icons.security_rounded,
                  label: 'Auditoría & Logs',
                  isSelected: _selectedNavIndex == 6,
                  onTap: () => setState(() => _selectedNavIndex = 6),
                ),
              ],
            ),
          ),

          // Main Workspace
          Expanded(
            child: Column(
              children: [
                // SaaS Header
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : Colors.black.withValues(alpha: 0.06))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Plataforma de Control Operativo iDrone', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.softGreen,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                CircleAvatar(radius: 4, backgroundColor: AppColors.emerald),
                                SizedBox(width: 8),
                                Text('Servidor Activo', style: TextStyle(color: AppColors.deepForest, fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),

                // Content Views
                Expanded(
                  child: IndexedStack(
                    index: _selectedNavIndex,
                    children: const [
                      _AdminMetricsView(),
                      AdminSettingsScreen(),
                      AdminCalendarAndFleetScreen(),
                      _AdminBookingsView(),
                      _AdminFleetView(),
                      _AdminCrmView(),
                      _AdminAuditView(),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        color: isSelected ? AppColors.emerald.withValues(alpha: 0.2) : Colors.transparent,
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.limeAccent : Colors.white70, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  final _depositController = TextEditingController();
  final _couponController = TextEditingController();
  final _discountController = TextEditingController();
  final _disclaimerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final store = Provider.of<AppStore>(context, listen: false);
    _depositController.text = (store.platformSettings.depositPercentage * 100).toStringAsFixed(0);
    _couponController.text = store.platformSettings.activePromoCoupon;
    _discountController.text = store.platformSettings.promoDiscountAmount.toStringAsFixed(0);
    _disclaimerController.text = store.platformSettings.readinessDisclaimerText;
  }

  void _saveParametrization() {
    final store = Provider.of<AppStore>(context, listen: false);
    final depPct = double.tryParse(_depositController.text.trim());
    final discAmt = double.tryParse(_discountController.text.trim());

    store.updatePlatformSettings(
      depositPercentage: depPct != null ? depPct / 100.0 : null,
      activePromoCoupon: _couponController.text.trim(),
      promoDiscountAmount: discAmt,
      readinessDisclaimerText: _disclaimerController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Parametrización global actualizada con éxito!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Consola de Parametrización Central', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('Modifica tarifas base, porcentajes de anticipo y reglas de servicio en tiempo real.', style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.mutedText, fontSize: 13)),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emerald,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                onPressed: _saveParametrization,
                icon: const Icon(Icons.save_rounded),
                label: const Text('Guardar Cambios', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Tariffs per Service
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tarifas Base por Hectárea (\$/Ha)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ...store.services.map((srv) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(srv.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        Expanded(
                          child: TextFormField(
                            initialValue: srv.basePricePerHectare.toStringAsFixed(0),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: '\$ ',
                              suffixText: 'MXN',
                              isDense: true,
                            ),
                            onChanged: (val) {
                              final p = double.tryParse(val);
                              if (p != null) {
                                store.updateServicePrice(srv.id, p);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Payment & Anticipo Config
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Configuración de Pagos y Anticipo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _depositController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Porcentaje de Anticipo Requerido',
                          suffixText: '%',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _couponController,
                        decoration: const InputDecoration(
                          labelText: 'Cupón Promocional Activo',
                          prefixIcon: Icon(Icons.confirmation_number_rounded),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _discountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Monto Descuento Promocional',
                          prefixText: '\$ ',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Disclaimer & Client Responsibility
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Declaración de Responsabilidad del Cliente (Agua e Insumos)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                TextField(
                  controller: _disclaimerController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Texto Legal de Confirmación',
                    hintText: 'Texto con el que el cliente declara que tendrá los productos y el agua listos.',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminMetricsView extends StatelessWidget {
  const _AdminMetricsView();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);
    final totalHectares = store.parcels.fold<double>(0, (sum, p) => sum + p.areaHectares);
    final totalRevenue = store.bookings.fold<double>(0, (sum, b) => sum + b.total);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: StatCard(title: 'INGRESOS TOTALES', value: '\$${totalRevenue.toStringAsFixed(0)} MXN', icon: Icons.attach_money_rounded)),
              const SizedBox(width: 16),
              Expanded(child: StatCard(title: 'HECTÁREAS ATENDIDAS', value: '${totalHectares.toStringAsFixed(0)} Ha', icon: Icons.landscape_rounded)),
              const SizedBox(width: 16),
              Expanded(child: StatCard(title: 'DRONES ACTIVOS', value: '${store.drones.length}', icon: Icons.radar_rounded)),
              const SizedBox(width: 16),
              Expanded(child: StatCard(title: 'PILOTOS', value: '${store.operators.length}', icon: Icons.person_rounded)),
            ],
          ),
          const SizedBox(height: 24),
          AppCard(
            padding: const EdgeInsets.all(20),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Resumen de Operaciones', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                Text('Plataforma iDrone lista para monitoreo en tiempo real y asignación de flotas.'),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _AdminBookingsView extends StatelessWidget {
  const _AdminBookingsView();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: store.bookings.length,
      itemBuilder: (context, index) {
        final b = store.bookings[index];
        return AppCard(
          child: ListTile(
            title: Text('Reserva #${b.id} - Área: ${b.areaHectares} Ha'),
            subtitle: Text('Total: \$${b.total} MXN | Pagado: \$${b.paidAmount} MXN'),
            trailing: StatusBadge.forBookingStatus(b.status.name),
          ),
        );
      },
    );
  }
}

class _AdminFleetView extends StatelessWidget {
  const _AdminFleetView();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: store.drones.length,
      itemBuilder: (context, index) {
        final d = store.drones[index];
        return AppCard(
          child: ListTile(
            leading: const Icon(Icons.radar_rounded, color: AppColors.emerald),
            title: Text('${d.identifier} (${d.model})'),
            subtitle: Text('Horas de vuelo: ${d.flightHours} hrs | Estado: ${d.status}'),
          ),
        );
      },
    );
  }
}

class _AdminCrmView extends StatelessWidget {
  const _AdminCrmView();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cliente Activo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(store.currentUser.name),
              subtitle: Text('${store.currentUser.email} | ${store.currentUser.phone}'),
            )
          ],
        ),
      ),
    );
  }
}

class _AdminAuditView extends StatelessWidget {
  const _AdminAuditView();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: store.auditLogs.length,
      itemBuilder: (context, index) {
        final log = store.auditLogs[index];
        return AppCard(
          child: ListTile(
            leading: const Icon(Icons.security_rounded, color: AppColors.emerald),
            title: Text(log.action),
            subtitle: Text('Usuario: ${log.userName} | Entidad: ${log.entity}'),
            trailing: Text('${log.timestamp.hour}:${log.timestamp.minute}'),
          ),
        );
      },
    );
  }
}
