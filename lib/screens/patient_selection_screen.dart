import 'package:burbojito/screens/exam_screen.dart';
import 'package:flutter/material.dart';

class PatientSelectionScreen extends StatefulWidget {
  const PatientSelectionScreen({super.key});

  @override
  State<PatientSelectionScreen> createState() =>
      _PatientSelectionScreenState();
}

class _PatientSelectionScreenState
    extends State<PatientSelectionScreen> {
  String? selectedPatient = 'Arthur';

  final List<String> patients = [
    'Arthur',
    'Luis Filipe',
    'Diana',
    'Rodrigo',
    'Thiago',
    'Marilene'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFF8B3DFF),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedPatient,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xFF0A1B33),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF0A1B33),
                    ),
                    items: patients.map((String patient) {
                      return DropdownMenuItem<String>(
                        value: patient,
                        child: Text(patient),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPatient = newValue;
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
                  onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ExamProgressScreen(),
                        ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 3, 3, 3),
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
          ),
        ),
      ),
    );
  }
}