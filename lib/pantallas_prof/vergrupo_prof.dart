import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListarAlumnosPorGrupoScreen extends StatelessWidget {
  const ListarAlumnosPorGrupoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Selecciona un Grupo")),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('grupos').get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final grupos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: grupos.length,
            itemBuilder: (context, index) {
              final grupo = grupos[index];
              final nombreGrupo = grupo['nombre']; // Ej: "1A"
              final claveGrupo = grupo['clave']; // Usado para filtrar alumnos

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text("Grupo $nombreGrupo"),
                  subtitle: Text("Clave: $claveGrupo"),
                  trailing: ElevatedButton(
                    child: const Text("Ver"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AlumnosDelGrupoScreen(
                            claveGrupo: claveGrupo,
                            nombreGrupo: nombreGrupo,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AlumnosDelGrupoScreen extends StatelessWidget {
  final String claveGrupo;
  final String nombreGrupo;

  const AlumnosDelGrupoScreen({
    super.key,
    required this.claveGrupo,
    required this.nombreGrupo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Alumnos del grupo $nombreGrupo")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('usuarios')
            .where('tipo', isEqualTo: 'Alumno')
            .where('clave', isEqualTo: claveGrupo)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final alumnos = snapshot.data!.docs;

          if (alumnos.isEmpty) {
            return const Center(child: Text("No hay alumnos en este grupo."));
          }

          return ListView.builder(
            itemCount: alumnos.length,
            itemBuilder: (context, index) {
              final alumno = alumnos[index];
              final id = alumno.id;
              final nombre = alumno['nombre'];
              final estado = alumno['estado'];

              return ListTile(
                title: Text(nombre),
                subtitle: Text("Estado: $estado"),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'editar') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditarAlumnoScreen(alumnoId: id),
                        ),
                      );
                    } else if (value == 'inactivar') {
                      await FirebaseFirestore.instance
                          .collection('usuarios')
                          .doc(id)
                          .update({'estado': 'inactivo'});

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Alumno inactivado")),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'editar', child: Text('Editar')),
                    const PopupMenuItem(
                        value: 'inactivar', child: Text('Inactivar')),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EditarAlumnoScreen extends StatefulWidget {
  final String alumnoId;

  const EditarAlumnoScreen({super.key, required this.alumnoId});

  @override
  State<EditarAlumnoScreen> createState() => _EditarAlumnoScreenState();
}

class _EditarAlumnoScreenState extends State<EditarAlumnoScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _grupoController = TextEditingController();
  final TextEditingController _claveController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  void cargarDatos() async {
    final doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(widget.alumnoId)
        .get();
    final data = doc.data()!;
    _nombreController.text = data['nombre'];
    _grupoController.text = data['grupo'];
    _claveController.text = data['clave'];
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _grupoController.dispose();
    _claveController.dispose();
    super.dispose();
  }

  void guardarCambios() async {
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(widget.alumnoId)
        .update({
      'nombre': _nombreController.text.trim(),
      'grupo': _grupoController.text.trim(),
      'clave': _claveController.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Alumno actualizado con éxito")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Alumno")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _grupoController,
              decoration: const InputDecoration(labelText: 'Grupo'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _claveController,
              decoration: const InputDecoration(labelText: 'Clave'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: guardarCambios,
              child: const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}
