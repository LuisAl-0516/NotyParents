import 'package:app/inicio_elegir.dart';
import 'package:app/pantallas_prof/agrega_alumno.dart';
import 'package:app/pantallas_padre/agregargrup_padre.dart';
import 'package:app/pantallas_padre/home_padre.dart';
import 'package:app/pantallas_padre/login_padre.dart';
import 'package:app/pantallas_padre/registro_padre.dart';
import 'package:app/pantallas_prof/agregargrup_prof.dart';
import 'package:app/pantallas_prof/home_prof.dart';
import 'package:app/pantallas_prof/login_prof.dart';
import 'package:app/pantallas_prof/misgrupos_prof.dart';
import 'package:app/pantallas_prof/registro_prof.dart';
import 'package:app/pantallas_prof/vergrupo_prof.dart';
import 'package:flutter/material.dart';
// Importaciones de Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      routes: {
        'loginpadre': (_) => const LoginPadre(),
        'loginprof': (_) => const LoginProf(),
        'registropadre': (_) => const RegisterPadre(),
        'registroprof': (_) => const RegisterProf(),
        'homeprof': (_) => const HomeProf(),
        'homepadre': (_) => const HomePadre(),
        'agregarpadre': (_) => const AddPadre(),
        'agregarprof': (_) => const AgregargrupProf(), // Corregido
        'misprof': (_) => const ListarAlumnosPorGrupoScreen(),
        'agregaralumno': (_) => const RegistrarAlumnoScreen(),
        'vergrupo': (_) => ListarAlumnosPorGrupoScreen(),
        'inicio': (_) => const Inicio(),
      },
      initialRoute: 'inicio',
    );
  }
}
