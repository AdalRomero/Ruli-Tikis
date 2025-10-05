import 'dart:async';

import 'package:flutter/material.dart';
import 'package:the_man_who_sold_the_world/Code/metricas.dart';
import 'package:the_man_who_sold_the_world/Plugins/Colores.dart';
import 'package:the_man_who_sold_the_world/Plugins/Widgets/Containers.dart';
import 'package:the_man_who_sold_the_world/Plugins/Widgets/appBar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final c = Colores();
  bool cargando = true;
  // Opacidades de los iconos
  double opacityLeft = 1.0;
  double opacityCenter = 0.5;
  double opacityRight = 1.0;

  @override
  void initState() {
    super.initState();
    _cargarMetricas();
    _startIconAnimation();
  }

  Future<void> _cargarMetricas() async {
    if (!mounted) return;
    setState(() => cargando = true);

    await MetricasService.instance.inicializar();

    if (!mounted) return; // <-- evita setState si ya no está montado
    setState(() => cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    final metrics = MetricasService.instance;

    return Scaffold(
      backgroundColor: c.backgroundDark,
      appBar: CustomAppBar(
        title: 'Leo & Chilanguitos',
        shadowColor: c.appBarSombra.withOpacity(0.38),
        textColor: c.textPrimary,
        primaryColor: c.primaryGreen,
        accentColor: c.accentGreen,
      ),
      body: SafeArea(
        child: cargando
            ? Center(child: CircularProgressIndicator(color: c.accentGreen))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  spacing: 20,
                  children: [
                    // ───────── Fila 1: 3 botones circulares con íconos ─────────
                    Row(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _metricCircle(
                          icon: Icons.attach_money,
                          value: '${metrics.totalVentasMes.toStringAsFixed(2)}',
                          title: 'Ventas mes',
                          description:
                              'Total de ventas realizadas en el mes actual. Muestra cuántos productos se han vendido en este mes.',
                          color: c.accentGreen,
                          position: 0,
                        ),
                        _metricCircle(
                          icon: Icons.person,
                          value:
                              '${metrics.promedioVentasCliente.toStringAsFixed(2)}',
                          title: 'Promedio por cliente',
                          description:
                              'Promedio de ventas por cliente. Calcula cuántos productos, en promedio, compra cada cliente.',
                          color: c.primaryGreen,
                          position: 1,
                        ),
                        _metricCircle(
                          icon: Icons.shopping_cart,
                          value: '${metrics.ventasTotales.toStringAsFixed(2)}',
                          title: 'Total vendida',
                          description:
                              'Cantidad total de productos vendidos desde el inicio. Muestra la venta acumulada.',
                          color: c.appBarSombra,
                          position: 2,
                        ),
                      ],
                    ),
                    // ───────── Card grande ─────────
                    CustomContainer(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            children: [
                              _metricLargeContent(
                                'Producto más vendido',
                                metrics.productoMasVendido,
                              ),
                              Spacer(),
                              _metricLargeContent(
                                'Cliente mayor gasto',
                                metrics.clienteMayorGasto,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ───────── Estadísticas ─────────
                    CustomContainer(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 400, // altura máxima antes de hacer scroll
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Porcentaje ventas por categoría',
                                style: TextStyle(
                                  color: c.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // ───────── Primeras 3 estadísticas como círculos ─────────
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: metrics
                                    .porcentajeVentasCategoria
                                    .entries
                                    .take(3)
                                    .map(
                                      (e) => GestureDetector(
                                        onTap: () => _showInfoSnackBar(
                                          '${e.key} : ${e.value.toStringAsFixed(1)}% de ventas',
                                        ),
                                        child: CustomContainer(
                                          width: 100,
                                          height: 100,
                                          borderRadius: 50,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.category,
                                                  color: c.primaryGreen,
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  e.key,
                                                  style: TextStyle(
                                                    color: c.textPrimary,
                                                    fontSize: 12,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  '${e.value.toStringAsFixed(1)}%',
                                                  style: TextStyle(
                                                    color: c.textPrimary,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 16),

                              // ───────── Resto de estadísticas ─────────
                              ...metrics.porcentajeVentasCategoria.entries
                                  .skip(3)
                                  .map(
                                    (e) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      child: Text(
                                        '${e.key} : ${e.value.toStringAsFixed(1)}%',
                                        style: TextStyle(color: c.textPrimary),
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // ───────── Estadísticas de clientes por ciudad ─────────
                    CustomContainer(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 400, // altura máxima antes de scroll
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Clientes por ciudad',
                                style: TextStyle(
                                  color: c.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Primeras 3 ciudades como círculos
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: metrics.clientesPorCiudad.entries
                                    .take(3)
                                    .map(
                                      (e) => GestureDetector(
                                        onTap: () => _showInfoSnackBar(
                                          '${e.key}: ${e.value} clientes',
                                        ),
                                        child: CustomContainer(
                                          width: 100,
                                          height: 100,
                                          borderRadius: 50,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.location_city,
                                                  color: c.primaryGreen,
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  e.key,
                                                  style: TextStyle(
                                                    color: c.textPrimary,
                                                    fontSize: 12,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  '${e.value}',
                                                  style: TextStyle(
                                                    color: c.textPrimary,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 16),

                              // Resto de ciudades
                              ...metrics.clientesPorCiudad.entries
                                  .skip(3)
                                  .map(
                                    (e) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      child: Text(
                                        '${e.key}: ${e.value} clientes',
                                        style: TextStyle(color: c.textPrimary),
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _metricLargeContent(String title, String value) {
    return Column(
      children: [
        Text(title, style: TextStyle(color: c.textPrimary, fontSize: 16)),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(color: c.textPrimary, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _metricCircle({
    required IconData icon,
    required String value,
    required String title,
    required String description,
    required Color color,
    required int position, // 0 = left, 1 = center, 2 = right
  }) {
    double currentOpacity = 1.0;
    if (position == 0) currentOpacity = opacityLeft;
    if (position == 1) currentOpacity = opacityCenter;
    if (position == 2) currentOpacity = opacityRight;

    return Expanded(
      child: GestureDetector(
        onTap: () => _showInfoSnackBar(description),
        child: CustomContainer(
          height: 130,
          borderRadius: 90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: currentOpacity,
                duration: const Duration(milliseconds: 500),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  color: c.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para mostrar el SnackBar con información
  void _showInfoSnackBar(String info) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(info, style: TextStyle(color: c.textPrimary)),
        backgroundColor: c.primaryGreen.withOpacity(0.5),
        duration: const Duration(seconds: 2), // dura 3 segundos
        behavior: SnackBarBehavior.floating, // flota sobre la UI
      ),
    );
  }

  void _startIconAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() {
          // alterna las opacidades
          opacityLeft = opacityLeft == 1.0 ? 0.2 : 1.0;
          opacityRight = opacityRight == 1.0 ? 0.2 : 1.0;
          opacityCenter = opacityCenter == 1.0 ? 0.2 : 1.0;
        });
      });
    });
  }
}
