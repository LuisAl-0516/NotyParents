import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RegistrarAsistenciaScreen extends StatefulWidget {
  final String claveGrupo;
  const RegistrarAsistenciaScreen({super.key, required this.claveGrupo});

  @override
  State<RegistrarAsistenciaScreen> createState() =>
      _RegistrarAsistenciaScreenState();
}

class _RegistrarAsistenciaScreenState extends State<RegistrarAsistenciaScreen> {
  final Map<String, bool> asistencia = {};
  late String fechaHoy;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    fechaHoy = "${now.year}-${now.month}-${now.day}";
    _cargarAsistenciaSiExiste();
  }

  Future<void> _cargarAsistenciaSiExiste() async {
    final docId = "${widget.claveGrupo}_$fechaHoy";
    final doc = await FirebaseFirestore.instance
        .collection('asistencia')
        .doc(docId)
        .get();

    if (doc.exists) {
      final datos = doc.data()!;
      final asistenciaGuardada = Map<String, dynamic>.from(datos['alumnos']);
      setState(() {
        asistencia.clear();
        asistenciaGuardada.forEach((key, value) {
          asistencia[key] = value as bool;
        });
      });
    }
  }

  void _guardarAsistencia() async {
    final docId = "${widget.claveGrupo}_$fechaHoy";
    await FirebaseFirestore.instance.collection('asistencia').doc(docId).set({
      'grupo': widget.claveGrupo,
      'fecha': fechaHoy,
      'alumnos': asistencia,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Asistencia guardada exitosamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Asistencia: ${widget.claveGrupo}")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('usuarios')
            .where('tipo', isEqualTo: 'Alumno')
            .where('clave', isEqualTo: widget.claveGrupo)
            .where('estado', isEqualTo: 'activo')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final alumnos = snapshot.data!.docs;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: alumnos.length,
                  itemBuilder: (context, index) {
                    final alumno = alumnos[index];
                    final id = alumno.id;
                    final nombre = alumno['nombre'];

                    final presente = asistencia[id] ?? false;

                    return CheckboxListTile(
                      title: Text(nombre),
                      value: presente,
                      onChanged: (value) {
                        setState(() {
                          asistencia[id] = value ?? false;
                        });
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  onPressed: _guardarAsistencia,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.shade400,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text("Guardar Asistencia",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
