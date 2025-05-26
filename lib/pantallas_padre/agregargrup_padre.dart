import 'package:flutter/material.dart';

class AddPadre extends StatelessWidget {
  const AddPadre({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavButton(icon: Icons.group),
            _NavButton(icon: Icons.group_add),
          ],
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: 'Noti',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: ' Parents',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      const Text(
                        'AÑADIR GRUPO',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Clave del grupo',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          // lógica para unirse al grupo
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('UNIRME'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Flecha de retroceso
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'homepadre');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  const _NavButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: Colors.black, size: 32),
    );
  }
}
