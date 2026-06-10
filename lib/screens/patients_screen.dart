import 'package:flutter/material.dart';

import '../models/patient.dart';
import '../services/api_service.dart';

/// "Pacientes" screen (the list tab).
///
/// Loads the patient list from GET /api/patients/. If the request fails,
/// the user can retry or fall back to sample data so the screen stays
/// presentable during demos.
class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final ApiService _api = ApiService();
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  late Future<List<Patient>> _patientsFuture;
  bool _usingMockData = false;

  @override
  void initState() {
    super.initState();
    _patientsFuture = _api.listPatients();
  }

  @override
  void dispose() {
    _api.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    setState(() {
      _usingMockData = false;
      _patientsFuture = _api.listPatients();
    });
    await _patientsFuture;
  }

  void _useMockData() {
    setState(() {
      _usingMockData = true;
      _patientsFuture = Future.value(_mockPatients());
    });
  }

  List<Patient> _mockPatients() {
    return [
      Patient(
        name: 'Helena Martinez',
        doctor: 'Dr.ª Sara Wilson',
        date: DateTime(2026, 5, 14),
        status: PatientStatus.novo,
      ),
      Patient(
        name: 'Maria de Lurdes',
        doctor: 'Dr.ª Sara Wilson',
        date: DateTime(2026, 5, 10),
        status: PatientStatus.revisado,
      ),
      Patient(
        name: 'Ricardo Silva',
        doctor: 'Dr.º Paulo Jorge',
        date: DateTime(2026, 5, 7),
        status: PatientStatus.novo,
      ),
      Patient(
        name: 'João Paulo Silva',
        doctor: 'Dr.ª Sara Wilson',
        date: DateTime(2026, 5, 5),
        status: PatientStatus.revisado,
      ),
      Patient(
        name: 'Camila Souza',
        doctor: 'Dr.º Paulo Jorge',
        date: DateTime(2026, 5, 2),
        status: PatientStatus.novo,
      ),
    ];
  }

  List<Patient> _filtered(List<Patient> patients) {
    if (_query.isEmpty) return patients;
    final q = _query.toLowerCase();
    return patients.where((p) => p.name.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: const Color(0xFF4A86E8),
        unselectedItemColor: Colors.black87,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, '/home');
              }
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/reports');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_red_eye_outlined),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                'Pacientes',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A1F3C),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Toque em nome para inspecionar e, em seguida, '
                'abra o relatório para revisar os resultados',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Color(0xFF9AA7B8),
                ),
              ),
              const SizedBox(height: 18),
              _SearchField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: FutureBuilder<List<Patient>>(
                  future: _patientsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return _ErrorState(
                        message: snapshot.error.toString(),
                        onRetry: _reload,
                        onUseMockData: _useMockData,
                      );
                    }

                    final patients = snapshot.data ?? const <Patient>[];
                    final filtered = _filtered(patients);
                    final novos = patients
                        .where((p) => p.status == PatientStatus.novo)
                        .length;
                    final revisados = patients
                        .where((p) => p.status == PatientStatus.revisado)
                        .length;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_usingMockData)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Exibindo dados de exemplo (sem conexão).',
                              style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: Color(0xFF9AA7B8),
                              ),
                            ),
                          ),
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                value: patients.length
                                    .toString()
                                    .padLeft(2, '0'),
                                label: 'Relatórios',
                                valueColor: const Color(0xFFE53935),
                                background: const Color(0xFFFDEDEC),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                value: novos.toString().padLeft(2, '0'),
                                label: 'Novos',
                                valueColor: const Color(0xFF2F80ED),
                                background: const Color(0xFFEAF2FE),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                value: revisados.toString().padLeft(2, '0'),
                                label: 'Revisados',
                                valueColor: const Color(0xFF8B5CF6),
                                background: const Color(0xFFF1EBFE),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Expanded(
                          child: filtered.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Nenhum paciente encontrado.',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF9AA7B8),
                                    ),
                                  ),
                                )
                              : RefreshIndicator(
                                  onRefresh: _reload,
                                  child: ListView.separated(
                                    padding:
                                        const EdgeInsets.only(bottom: 12),
                                    itemCount: filtered.length,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 14),
                                    itemBuilder: (context, index) =>
                                        _PatientCard(
                                            patient: filtered[index]),
                                  ),
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
    required this.onUseMockData,
  });

  final String message;
  final Future<void> Function() onRetry;
  final VoidCallback onUseMockData;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off, size: 56, color: Color(0xFF9AA7B8)),
          const SizedBox(height: 16),
          const Text(
            'Não foi possível carregar os pacientes.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Color(0xFF0A1F3C)),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              message,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: Color(0xFF9AA7B8)),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A86E8),
            ),
            child: const Text(
              'Tentar novamente',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: onUseMockData,
            child: const Text(
              'Usar dados de exemplo',
              style: TextStyle(color: Color(0xFF9AA7B8)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: const TextStyle(color: Color(0xFF9AA7B8)),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD7DEE8), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2F80ED), width: 1.5),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.valueColor,
    required this.background,
  });

  final String value;
  final String label;
  final Color valueColor;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A5568),
            ),
          ),
        ],
      ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  const _PatientCard({required this.patient});

  final Patient patient;

  static const List<String> _months = [
    'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
    'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez',
  ];

  String get _formattedDate {
    final date = patient.date;
    if (date == null) return '—';
    final m = _months[date.month - 1];
    final d = date.day.toString().padLeft(2, '0');
    return '$m $d, ${date.year}';
  }

  /// Second line of the card: the doctor when known (mock data), otherwise
  /// the most useful patient detail the backend does provide.
  String get _subtitle {
    if (patient.doctor != null) return patient.doctor!;
    if (patient.age != null) return 'Idade: ${patient.age} anos';
    return '—';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8C7A8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Text(
              patient.initials,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A5568),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.name,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A1B33),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 13,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formattedDate,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _StatusBadge(status: patient.status),
              const SizedBox(height: 12),
              _ActionButton(
                icon: Icons.remove_red_eye_outlined,
                background: const Color(0xFFEAF2FE),
                iconColor: const Color(0xFF2F80ED),
                onTap: () {},
              ),
              const SizedBox(height: 8),
              _ActionButton(
                icon: Icons.download_outlined,
                background: const Color(0xFFE6F6EC),
                iconColor: const Color(0xFF2EAE5C),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final PatientStatus status;

  @override
  Widget build(BuildContext context) {
    final isNovo = status == PatientStatus.novo;
    final label = isNovo ? 'NOVO' : 'REVISADO';
    final background =
        isNovo ? const Color(0xFFEAF2FE) : const Color(0xFFE6F6EC);
    final textColor =
        isNovo ? const Color(0xFF2F80ED) : const Color(0xFF2EAE5C);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.background,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final Color background;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: iconColor),
      ),
    );
  }
}
