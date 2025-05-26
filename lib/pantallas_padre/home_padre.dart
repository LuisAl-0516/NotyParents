import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePadre extends StatelessWidget {
  const HomePadre({super.key});

  @override
  Widget build(BuildContext context) {
    return const NotiParentsHome();
  }
}

class NotiParentsHome extends StatelessWidget {
  const NotiParentsHome({super.key});

  Future<Map<String, dynamic>?> _loadAlumnoYAsistencia() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return null;

    final tutorDoc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(currentUser.uid)
        .get();

    if (!tutorDoc.exists) return null;

    final tutorData = tutorDoc.data()!;
    final alumnoNombre = tutorData['alumno'];

    final alumnoQuery = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('nombre', isEqualTo: alumnoNombre)
        .where('tipo', isEqualTo: 'Alumno')
        .where('estado', isEqualTo: 'activo')
        .limit(1)
        .get();

    if (alumnoQuery.docs.isEmpty) return null;

    final alumnoData = alumnoQuery.docs.first.data();
    final alumnoId = alumnoQuery.docs.first.id;

    final asistenciaSnapshot = await FirebaseFirestore.instance
        .collection('asistencia')
        .where('alumnoId', isEqualTo: alumnoId)
        .orderBy('fecha', descending: true)
        .get();

    return {
      'alumno': alumnoData,
      'asistencias': asistenciaSnapshot.docs.map((doc) => doc.data()).toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _loadAlumnoYAsistencia(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            body: Center(
              child: Text('No se pudo cargar la información del alumno',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
          );
        }

        final alumno = snapshot.data!['alumno'];
        final asistencias = snapshot.data!['asistencias'] as List;

        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Text('Alumno: ${alumno['nombre']}'),
              Expanded(
                child: asistencias.isEmpty
                    ? const Text('No hay asistencias registradas.')
                    : ListView.builder(
                        itemCount: asistencias.length,
                        itemBuilder: (context, index) {
                          final asistencia = asistencias[index];
                          final fecha = asistencia['fecha']?.toDate();
                          final estado = asistencia['estado'] ?? 'Desconocido';
                          return ListTile(
                            title: Text('Fecha: ${fecha.toString()}'),
                            subtitle: Text('Estado: $estado'),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
