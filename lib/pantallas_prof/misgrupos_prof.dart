import 'package:flutter/material.dart';
//Esta pagina es temporal, ya que estos cambios los tendra que hacer automaticamente el programa
class MisGrupos extends StatelessWidget {
  final List<String> grupos = ['GRUPO 1', 'GRUPO 2', 'GRUPO 3'];

  MisGrupos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'homeprof'); // Puedes cambiar esta ruta si es otra
          },
        ),
        title: const Text('NotiParents'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: grupos.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            grupos[index],
                            style: const TextStyle(fontSize: 18),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Acción para el botón VER
                              Navigator.pushReplacementNamed(context, 'vergrupo');
                              print('Ver grupo: ${grupos[index]}');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text('VER'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '< 2025 >',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
