import 'package:flutter/material.dart';

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    return const RoleSelectionScreen(); // ✅ Solo retornamos el widget principal
  }
}

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  Widget roleCard({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 80, color: Colors.black87),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Ingresar'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue.shade700,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            constraints: const BoxConstraints(
              maxWidth: 400,
              minWidth: 300,
              maxHeight: 680,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/logoEsc.png',
                    height: 170,
                    width: 300,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '¿QUIEN ERES?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 30),
                  roleCard(
                    icon: Icons.school,
                    label: 'PROFESOR',
                    color: Colors.blue.shade800,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, 'loginprof');
                    },
                  ),
                  const SizedBox(height: 30),
                  roleCard(
                    icon: Icons.account_circle_outlined,
                    label: 'PADRE',
                    color: Colors.blue.shade500,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, 'loginpadre');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
