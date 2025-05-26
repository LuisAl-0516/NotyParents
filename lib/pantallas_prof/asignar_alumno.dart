import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AsignarEstudianteScreen extends StatefulWidget {
  const AsignarEstudianteScreen({super.key});

  @override
  State<AsignarEstudianteScreen> createState() =>
      _AsignarEstudianteScreenState();
}

class _AsignarEstudianteScreenState extends State<AsignarEstudianteScreen> {
  final TextEditingController _nombreEstudianteController =
      TextEditingController();
  final TextEditingController _claveGrupoController = TextEditingController();

  @override
  void dispose() {
    _nombreEstudianteController.dispose();
    _claveGrupoController.dispose();
    super.dispose();
  }

  void _asignarEstudiante() async {
    String nombreEstudiante = _nombreEstudianteController.text.trim();
    String claveGrupo = _claveGrupoController.text.trim();

    if (nombreEstudiante.isEmpty || claveGrupo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, rellena todos los campos.")),
      );
      return;
    }

    // Verificar si el grupo existe
    QuerySnapshot grupoSnapshot = await FirebaseFirestore.instance
        .collection('grupos')
        .where('clave', isEqualTo: claveGrupo)
        .get();

    if (grupoSnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se encontró un grupo con esa clave.")),
      );
      return;
    }

    String grupoId = grupoSnapshot.docs.first.id;

    // Buscar usuario con el nombre ingresado
    QuerySnapshot usuarioSnapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('nombre', isEqualTo: nombreEstudiante)
        .get();

    if (usuarioSnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("No se encontró un usuario con ese nombre.")),
      );
      return;
    }

    DocumentSnapshot usuarioDoc = usuarioSnapshot.docs.first;
    Map<String, dynamic> usuarioData =
        usuarioDoc.data() as Map<String, dynamic>;

    // Verificar si ya tiene grupo
    if (usuarioData.containsKey('grupoId') && usuarioData['grupoId'] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Este usuario ya está asignado a un grupo.")),
      );
      return;
    }

    // Asignar el grupo al usuario
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuarioDoc.id)
        .update({'grupoId': grupoId});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Estudiante asignado al grupo con éxito.")),
    );

    _nombreEstudianteController.clear();
    _claveGrupoController.clear();
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
              const Text(
                'ASIGNAR ESTUDIANTE',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _nombreEstudianteController,
                      decoration: InputDecoration(
                        labelText: 'Nombre del estudiante',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _claveGrupoController,
                      decoration: InputDecoration(
                        labelText: 'Clave del grupo',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _asignarEstudiante,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent.shade400,
                        ),
                        child: const Text(
                          'ASIGNAR AL GRUPO',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GroupButton(
                      icon: Icons.group,
                      onPressed: () {
                        print('Grupo presionado');
                      },
                    ),
                    GroupButton(
                      icon: Icons.group_add,
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, 'agregarprof');
                      },
                    ),
                    GroupButton(
                      icon: Icons.checklist,
                      onPressed: () {
                        print('Checklist presionado');
                      },
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
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'homeprof');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GroupButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const GroupButton({super.key, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.blueAccent.shade400,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.black, size: 40),
      ),
    );
  }
}
