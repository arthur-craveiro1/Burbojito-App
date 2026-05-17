import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 120),

              // LOGO
              Center(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                    children: [
                      TextSpan(
                        text: 'B',
                        style: TextStyle(color: Color(0xFF2F80ED)),
                      ),
                      TextSpan(
                        text: 'URB',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'O',
                        style: TextStyle(color: Color(0xFFF4A261)),
                      ),
                      TextSpan(
                        text: 'JITO',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 80),

              // USUÁRIO
              const Text(
                'Usuario',
                style: TextStyle(
                  color: Color(0xFF2F80ED),
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFE9EEF5),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF2F80ED),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF2F80ED),
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // SENHA
              const Text(
                'Contraseña',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFE9EEF5),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF4F5D75),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF2F80ED),
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Olvidé mi contraseña',
                    style: TextStyle(
                      color: Color(0xFF2F80ED),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // BOTÃO
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context,'/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F80ED),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'INGRESAR',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
}