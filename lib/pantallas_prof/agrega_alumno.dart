import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RegistrarAlumnoScreen extends StatefulWidget {
  const RegistrarAlumnoScreen({super.key});

  @override
  State<RegistrarAlumnoScreen> createState() => _RegistrarAlumnoScreenState();
}

class _RegistrarAlumnoScreenState extends State<RegistrarAlumnoScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _grupoController = TextEditingController();
  final TextEditingController _claveController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _grupoController.dispose();
    _claveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                color: Colors.grey[300],
                padding: const EdgeInsets.symmetric(vertical: 40),
                width: double.infinity,
                child: Center(
                  child: RichText(
                    text: const TextSpan(
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            text: 'Noti',
                            style: TextStyle(color: Colors.black)),
                        TextSpan(
                            text: ' Parents',
                            style: TextStyle(color: Colors.blue)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text('REGISTRAR ALUMNO',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _nombreController,
                      decoration: InputDecoration(
                        labelText: 'Nombre del alumno',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _grupoController,
                      decoration: InputDecoration(
                        labelText: 'Nombre del grupo',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _claveController,
                      decoration: InputDecoration(
                        labelText: 'Clave del grupo',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _registrarAlumno,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent.shade400),
                        child: const Text('REGISTRAR',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 35,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 35),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  void _registrarAlumno() async {
    String nombre = _nombreController.text.trim();
    String grupo = _grupoController.text.trim();
    String clave = _claveController.text.trim();

    if (nombre.isEmpty || grupo.isEmpty || clave.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, rellena todos los campos.")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('usuarios').add({
      'nombre': nombre,
      'grupo': grupo,
      'clave': clave,
      'estado': 'activo',
      'tipo': 'Alumno',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Alumno registrado con éxito.")),
    );

    _nombreController.clear();
    _grupoController.clear();
    _claveController.clear();
  }
}
