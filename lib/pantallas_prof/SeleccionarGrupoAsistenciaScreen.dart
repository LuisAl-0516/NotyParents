import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'RegistrarAsistenciaScreen.dart';

class SeleccionarGrupoAsistenciaScreen extends StatelessWidget {
  const SeleccionarGrupoAsistenciaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona un grupo')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('grupos').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final grupos = snapshot.data!.docs;

          if (grupos.isEmpty) {
            return const Center(child: Text('No hay grupos disponibles.'));
          }

          return ListView.builder(
            itemCount: grupos.length,
            itemBuilder: (context, index) {
              final grupo = grupos[index];
              final nombreGrupo = grupo['nombre'];
              final claveGrupo = grupo['clave'];

              return ListTile(
                title: Text(nombreGrupo),
                subtitle: Text('Clave: $claveGrupo'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          RegistrarAsistenciaScreen(claveGrupo: claveGrupo),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
