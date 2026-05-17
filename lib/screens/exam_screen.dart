import 'package:flutter/material.dart';

class ExamProgressScreen extends StatefulWidget {
  const ExamProgressScreen({super.key});

  @override
  State<ExamProgressScreen> createState() =>
      _ExamProgressScreenState();
}

class _ExamProgressScreenState
    extends State<ExamProgressScreen> {
  int progress = 0;
  int filledCircles = 0;

  void increaseProgress() {
    setState(() {
      if (progress < 100) {
        progress += 10;

        if (progress > 100) {
          progress = 100;
        }
      }
    });
  }

  void increaseCircles() {
  setState(() {
    if (filledCircles < 5) {
      filledCircles++;
    }

    // MOSTRA ERRO AO CHEGAR EM 5
    if (filledCircles == 5) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text(
              'O desvio ocular atingiu o limite máximo. Por favor, reinicie o exame',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  });
}

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
            children: [
              const SizedBox(height: 120),

              const Text(
                'PROGRESO NO EXAME',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A1B33),
                ),
              ),

              const SizedBox(height: 40),

              // CÍRCULO DE PROGRESSO
              SizedBox(
                width: 220,
                height: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: CircularProgressIndicator(
                        value: progress / 100,
                        strokeWidth: 16,
                        backgroundColor:
                            Colors.grey.shade300,
                        valueColor:
                            const AlwaysStoppedAnimation(
                          Color(0xFF2F8FFF),
                        ),
                      ),
                    ),

                    Text(
                      '$progress%',
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              const Text(
                'DESVIO OCULAR',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 26),

              // CÍRCULOS
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  bool isFilled =
                      index < filledCircles;

                  return Container(
                    margin:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isFilled
                          ? const Color(0xFFEF6C00)
                          : Colors.transparent,
                      border: Border.all(
                        color: Colors.black87,
                        width: 2,
                      ),
                    ),
                  );
                }),
              ),

              const Spacer(),

              // BOTÃO AUMENTAR %
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: increaseProgress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF2F8FFF),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Progresso do exame',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // BOTÃO AUMENTAR CÍRCULO
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: increaseCircles,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFEF6C00),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Desvio ocular',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}