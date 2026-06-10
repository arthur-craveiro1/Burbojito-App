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
    });

    // MOSTRA ERRO AO CHEGAR EM 5
    if (filledCircles == 5) {
      _showExamCancelledDialog();
    }
  }

  void _showExamCancelledDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // EYE ICON WITH RED X BADGE
                SizedBox(
                  width: 110,
                  height: 90,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.remove_red_eye,
                        size: 84,
                        color: Color(0xFF2F8FFF),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 6,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.cancel,
                            size: 38,
                            color: Color(0xFFE53935),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'Exame cancelado',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A1B33),
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  'O paciente ultrapassou o limite de 5 desvios. '
                  'O teste não é clinicamente válido. '
                  'Por favor, reajuste e tente novamente.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: Color(0xFF4A5568),
                  ),
                ),

                const SizedBox(height: 26),

                // VOLTAR AO INÍCIO
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home',
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEB6D17),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'VOLTAR AO INÍCIO',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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