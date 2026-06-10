import 'package:burbojito/screens/exam_screen.dart';
import 'package:flutter/material.dart';

import '../models/patient.dart';
import '../services/api_service.dart';

/// Patient picker shown after tapping "INICIAR EXAME".
///
/// Loads the registered patients from GET /api/patients/ and lets the user
/// choose one before continuing to the exam.
class PatientSelectionScreen extends StatefulWidget {
  const PatientSelectionScreen({super.key});

  @override
  State<PatientSelectionScreen> createState() =>
      _PatientSelectionScreenState();
}

class _PatientSelectionScreenState extends State<PatientSelectionScreen> {
  final ApiService _api = ApiService();
  late Future<List<Patient>> _patientsFuture;

  Patient? _selectedPatient;

  @override
  void initState() {
    super.initState();
    _patientsFuture = _api.listPatients();
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  void _reload() {
    setState(() {
      _selectedPatient = null;
      _patientsFuture = _api.listPatients();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
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
                );
              }

              final patients = snapshot.data ?? const <Patient>[];
              if (patients.isEmpty) {
                return const _EmptyState();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 140),
                  const Text(
                    'Escolha o paciente',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A1B33),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFF8B3DFF),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Patient>(
                        value: _selectedPatient,
                        isExpanded: true,
                        hint: const Text('Selecione um paciente'),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF0A1B33),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF0A1B33),
                        ),
                        items: patients.map((patient) {
                          return DropdownMenuItem<Patient>(
                            value: patient,
                            child: Text(patient.name),
                          );
                        }).toList(),
                        onChanged: (Patient? newValue) {
                          setState(() {
                            _selectedPatient = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _selectedPatient == null
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ExamProgressScreen(),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 3, 3, 3),
                        disabledBackgroundColor: const Color(0xFFBDBDBD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Continuar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

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
            style: TextStyle(fontSize: 16, color: Color(0xFF0A1B33)),
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
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off_outlined, size: 56, color: Color(0xFF9AA7B8)),
          SizedBox(height: 16),
          Text(
            'Nenhum paciente cadastrado.',
            style: TextStyle(fontSize: 16, color: Color(0xFF9AA7B8)),
          ),
        ],
      ),
    );
  }
}
