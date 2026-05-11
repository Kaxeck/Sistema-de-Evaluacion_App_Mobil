import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const EvaluacionApp());
}

class EvaluacionApp extends StatelessWidget {
  const EvaluacionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema TBC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A1854), // blue-900 exacto de la web
          background: const Color(0xFFF8FAFC), // gray-50
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        useMaterial3: true,
        fontFamily: 'Roboto', // Fuente limpia por defecto
      ),
      home: const BuscarAlumnoScreen(),
    );
  }
}

class BuscarAlumnoScreen extends StatefulWidget {
  const BuscarAlumnoScreen({super.key});

  @override
  State<BuscarAlumnoScreen> createState() => _BuscarAlumnoScreenState();
}

class _BuscarAlumnoScreenState extends State<BuscarAlumnoScreen> {
  final TextEditingController _matriculaController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _alumnoData;
  String? _errorMessage;

  Future<void> _buscarAlumno() async {
    final matricula = _matriculaController.text.trim();
    if (matricula.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _alumnoData = null;
    });

    try {
      final url = Uri.parse(
        'https://sistema-de-evaluacion-production.up.railway.app/api/alumnos/$matricula',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          _alumnoData = json['data'];
        });
      } else {
        setState(() {
          _errorMessage = 'Alumno no encontrado. Verifique la matrícula.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error de conexión. Verifique su internet.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Widget para renderizar un Badge (etiqueta) estilo web
  Widget _buildBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.2)),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // Widget para renderizar cada parcial individualmente
  Widget _buildParcialCol(String label, dynamic value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value == null ? '--' : value.toString(),
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sistema de Evaluación',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              'Gestor Escolar',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0A1854),
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          // CABECERA AZUL CON BÚSQUEDA
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
            decoration: const BoxDecoration(
              color: Color(0xFF0A1854),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  const Icon(Icons.search, color: Color(0xFF64748B)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _matriculaController,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Buscar por Matrícula...',
                        hintStyle: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.normal,
                        ),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _buscarAlumno(),
                    ),
                  ),
                  InkWell(
                    onTap: _buscarAlumno,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Buscar',
                        style: TextStyle(
                          color: Color(0xFF2563EB),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ÁREA DE RESULTADOS
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF2563EB)),
                  )
                : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Color(0xFFEF4444),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Color(0xFF1E293B),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : _alumnoData != null
                ? ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    children: [
                      // TARJETA DE PERFIL Y ESCUELA
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: const Color(0xFFEFF6FF),
                                  child: Text(
                                    _alumnoData!['perfil']['genero'],
                                    style: const TextStyle(
                                      color: Color(0xFF2563EB),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _alumnoData!['perfil']['nombre_completo'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Matrícula: ${_alumnoData!['perfil']['matricula']}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF64748B),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(color: Color(0xFFE2E8F0)),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Plantel Asignado',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF94A3B8),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _alumnoData!['escuela']['nombre_centro'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF1E293B),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildBadge(
                                  _alumnoData!['perfil']['estatus'],
                                  _alumnoData!['perfil']['estatus']
                                          .toString()
                                          .toUpperCase()
                                          .trim() == 'ALUMNO ACTIVO'
                                      ? const Color(0xFFD1FAE5)
                                      : const Color(0xFFFEE2E2),
                                  _alumnoData!['perfil']['estatus']
                                          .toString()
                                          .toUpperCase()
                                          .trim() == 'ALUMNO ACTIVO'
                                      ? const Color(0xFF065F46)
                                      : const Color(0xFF991B1B),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // BOLETA DE CALIFICACIONES
                      const Text(
                        'Resumen Académico',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Cabecera Boleta
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                                border: Border(
                                  bottom: BorderSide(color: Color(0xFFE2E8F0)),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'PROMEDIO GENERAL',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                  Text(
                                    _alumnoData!['academico']['promedio_general'] !=
                                            null
                                        ? _alumnoData!['academico']['promedio_general']
                                              .toString()
                                        : 'N/A',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2563EB),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Lista de Materias
                            ...(_alumnoData!['academico']['boleta'] as List)
                                .asMap()
                                .entries
                                .map((entry) {
                                  final index = entry.key;
                                  final materia = entry.value;

                                  final dynamic promRaw = materia['promedio'];
                                  final double? prom = promRaw != null
                                      ? double.tryParse(promRaw.toString())
                                      : null;

                                  final isReprobado =
                                      prom != null && prom < 6.0;
                                  final isLast =
                                      index ==
                                      (_alumnoData!['academico']['boleta']
                                                  as List)
                                              .length -
                                          1;

                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      border: isLast
                                          ? null
                                          : const Border(
                                              bottom: BorderSide(
                                                color: Color(0xFFF1F5F9),
                                              ),
                                            ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                materia['materia'],
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF334155),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  top: 8,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 10,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFF8FAFC,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFFF1F5F9,
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    _buildParcialCol(
                                                      'PARCIAL 1',
                                                      materia['parcial1'],
                                                    ),
                                                    Container(
                                                      width: 1,
                                                      height: 24,
                                                      color: const Color(
                                                        0xFFE2E8F0,
                                                      ),
                                                    ),
                                                    _buildParcialCol(
                                                      'PARCIAL 2',
                                                      materia['parcial2'],
                                                    ),
                                                    Container(
                                                      width: 1,
                                                      height: 24,
                                                      color: const Color(
                                                        0xFFE2E8F0,
                                                      ),
                                                    ),
                                                    _buildParcialCol(
                                                      'PARCIAL 3',
                                                      materia['parcial3'],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            const Text(
                                              'PROMEDIO',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Color(0xFF64748B),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: prom == null
                                                ? const Color(0xFFF1F5F9)
                                                : (isReprobado
                                                      ? const Color(0xFFFEF2F2)
                                                      : const Color(
                                                          0xFFECFDF5,
                                                        )),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            border: Border.all(
                                              color: prom == null
                                                  ? const Color(0xFFE2E8F0)
                                                  : (isReprobado
                                                        ? const Color(
                                                            0xFFFECACA,
                                                          )
                                                        : const Color(
                                                            0xFFA7F3D0,
                                                          )),
                                            ),
                                          ),
                                          child: Text(
                                            prom == null
                                                ? '--'
                                                : prom.toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: prom == null
                                                  ? const Color(0xFF94A3B8)
                                                  : (isReprobado
                                                        ? const Color(
                                                            0xFFDC2626,
                                                          )
                                                        : const Color(
                                                            0xFF059669,
                                                          )),
                                            ),
                                          ),
                                        ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                })
                                .toList(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
