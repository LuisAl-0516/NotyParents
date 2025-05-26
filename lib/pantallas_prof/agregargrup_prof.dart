import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class AgregargrupProf extends StatefulWidget {
  const AgregargrupProf({super.key});

  @override
  State<AgregargrupProf> createState() => _AgregargrupProfState();
}

class _AgregargrupProfState extends State<AgregargrupProf> {
  final TextEditingController _nombreGrupoController = TextEditingController();
  final TextEditingController _claveGrupoController = TextEditingController();

  @override
  void dispose() {
    _nombreGrupoController.dispose();
    _claveGrupoController.dispose();
    super.dispose();
  }

  void _crearGrupo() async {
    String nombreGrupo = _nombreGrupoController.text.trim();

    if (nombreGrupo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Por favor, introduce un nombre para el grupo.")),
      );
      return;
    }

    String claveGrupo = _generarClaveUnica();
    _claveGrupoController.text = claveGrupo;

    await FirebaseFirestore.instance.collection('grupos').add({
      'nombre': nombreGrupo,
      'clave': claveGrupo,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Grupo creado con éxito. Clave: $claveGrupo")),
    );

    _nombreGrupoController.clear();
  }

  String _generarClaveUnica() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    return String.fromCharCodes(
      Iterable.generate(
          6, (_) => chars.codeUnitAt(Random().nextInt(chars.length))),
    );
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
              const SizedBox(height: 40),
              const Text(
                'CREAR GRUPO',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _nombreGrupoController,
                      decoration: InputDecoration(
                        labelText: 'Nombre del grupo',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _claveGrupoController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Clave del grupo (auto-generada)',
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
                        onPressed: _crearGrupo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent.shade400,
                        ),
                        child: const Text(
                          'CREAR',
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
