import 'package:flutter/material.dart';
import 'SeleccionarGrupoAsistenciaScreen.dart';
import 'RegistrarAsistenciaScreen.dart'; // Asegúrate de importar la pantalla

class HomeProf extends StatelessWidget {
  const HomeProf({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              // Encabezado
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

              // Estado
              const Spacer(),
              const Text(
                'SIN GRUPOS',
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'CREA UN GRUPO',
                style: TextStyle(color: Colors.black45, fontSize: 14),
              ),
              const Spacer(),

              // Botones inferiores
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GroupButton(
                      icon: Icons.group, // Ver grupos
                      onPressed: () {
                        Navigator.pushNamed(context, 'misprof');
                      },
                    ),
                    GroupButton(
                      icon: Icons.person_add_alt_1, // Agregar alumno
                      onPressed: () {
                        Navigator.pushNamed(context, 'agregaralumno');
                      },
                    ),
                    GroupButton(
                      icon: Icons.group_add, // Agregar grupo
                      onPressed: () {
                        Navigator.pushNamed(context, 'agregarprof');
                      },
                    ),
                    GroupButton(
                      icon: Icons.fact_check,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const SeleccionarGrupoAsistenciaScreen(),
                          ),
                        );
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
                Navigator.pushReplacementNamed(context, 'inicio');
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
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.black, size: 30),
      ),
    );
  }
}
