import 'package:flutter/material.dart';

/// "Perfil" screen (the person tab).
///
/// Currently backed by mock data showing the logged-in user's details.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock profile data.
  static const String _firstName = 'Arthur';

  final TextEditingController _nameController =
      TextEditingController(text: 'Arthur Moreira Craveiro');
  final TextEditingController _emailController =
      TextEditingController(text: 'arthut@gmail.br');
  final TextEditingController _phoneController =
      TextEditingController(text: '+55 12 1234 5678');
  final TextEditingController _birthController =
      TextEditingController(text: '18 / 02 / 1996');

  String _sex = 'Masculino';
  final List<String> _sexOptions = const ['Masculino', 'Femenino', 'Otro'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
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
            case 1:
              Navigator.pushReplacementNamed(context, '/patients');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/reports');
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28),
              const Text(
                'Ola, $_firstName',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A1F3C),
                ),
              ),
              const SizedBox(height: 28),
              _LabeledField(
                label: 'Nombre completo',
                child: _InputBox(controller: _nameController),
              ),
              const SizedBox(height: 18),
              _LabeledField(
                label: 'Correo Electrónico',
                child: _InputBox(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 18),
              _LabeledField(
                label: 'Número de celular o teléfono',
                child: _InputBox(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(height: 18),
              _LabeledField(
                label: 'Fecha de nacimiento',
                child: _InputBox(
                  controller: _birthController,
                  readOnly: true,
                  suffixIcon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF0A1B33),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _LabeledField(
                label: 'Sexo biológico',
                child: _SexDropdown(
                  value: _sex,
                  options: _sexOptions,
                  onChanged: (value) {
                    if (value != null) setState(() => _sex = value);
                  },
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

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _InputBox extends StatelessWidget {
  const _InputBox({
    required this.controller,
    this.readOnly = false,
    this.keyboardType,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final bool readOnly;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 16, color: Color(0xFF0A1B33)),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffixIcon,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFBCC8DA), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF2F80ED), width: 1.5),
        ),
      ),
    );
  }
}

class _SexDropdown extends StatelessWidget {
  const _SexDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      onChanged: onChanged,
      isExpanded: true,
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: Color(0xFF0A1B33),
      ),
      style: const TextStyle(fontSize: 16, color: Color(0xFF0A1B33)),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFBCC8DA), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF2F80ED), width: 1.5),
        ),
      ),
      items: options
          .map((o) => DropdownMenuItem<String>(value: o, child: Text(o)))
          .toList(),
    );
  }
}
