import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/app_store.dart';
import '../../data/models/idrone_models.dart';
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
                  icon: Icons.calendar_month_rounded,
                  label: 'Calendario y Permisos',
                  isSelected: _selectedNavIndex == 1,
                  onTap: () => setState(() => _selectedNavIndex = 1),
                ),
                _SidebarItem(
                  icon: Icons.assignment_rounded,
                  label: 'Servicios y Reservas',
                  isSelected: _selectedNavIndex == 2,
                  onTap: () => setState(() => _selectedNavIndex = 2),
                ),
                _SidebarItem(
                  icon: Icons.flight_rounded,
                  label: 'Drones y Flota',
                  isSelected: _selectedNavIndex == 3,
                  onTap: () => setState(() => _selectedNavIndex = 3),
                ),
                _SidebarItem(
                  icon: Icons.people_rounded,
                  label: 'CRM Clientes',
                  isSelected: _selectedNavIndex == 4,
                  onTap: () => setState(() => _selectedNavIndex = 4),
                ),
                _SidebarItem(
                  icon: Icons.security_rounded,
                  label: 'Auditoría & Logs',
                  isSelected: _selectedNavIndex == 5,
                  onTap: () => setState(() => _selectedNavIndex = 5),
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
