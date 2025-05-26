import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/extras/input_decorations.dart';

class RegisterPadre extends StatefulWidget {
  const RegisterPadre({super.key});

  @override
  State<RegisterPadre> createState() => _RegisterPadreState();
}

class _RegisterPadreState extends State<RegisterPadre> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _alumnoController = TextEditingController();

  bool _isLoading = false;

  Future<void> _register(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final nombre = _nombreController.text.trim();
    final alumno = _alumnoController.text.trim();

    try {
      // Verificar que el alumno exista y esté activo
      final alumnoQuery = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('nombre', isEqualTo: alumno)
          .where('tipo', isEqualTo: 'Alumno')
          .where('estado', isEqualTo: 'activo')
          .limit(1)
          .get();

      if (alumnoQuery.docs.isEmpty) {
        _showDialog(context, 'Error de validación',
            'El alumno ingresado no existe o no está activo.');
        return;
      }

      // Verificar si ya hay un tutor para este alumno
      final tutorQuery = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('tipo', isEqualTo: 'Tutor')
          .where('alumno', isEqualTo: alumno)
          .limit(1)
          .get();

      if (tutorQuery.docs.isNotEmpty) {
        _showDialog(context, 'Registro denegado',
            'Este alumno ya tiene un tutor registrado.');
        return;
      }

      // Crear cuenta en Firebase Auth
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Guardar en Firestore
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(credential.user!.uid)
          .set({
        'nombre': nombre,
        'correo': email,
        'tipo': 'Tutor',
        'alumno': alumno,
      });

      Navigator.pushReplacementNamed(context, 'homepadre');
    } on FirebaseAuthException catch (e) {
      _showDialog(
          context, 'Error al registrar', e.message ?? 'Error desconocido');
    } catch (e) {
      _showDialog(context, 'Error inesperado', e.toString());
    }
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            cajaazul(size),
            iconoProf(),
            registerForm(context),
          ],
        ),
      ),
    );
  }

  Widget registerForm(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          children: [
            const SizedBox(height: 230),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15,
                      offset: Offset(0, 5)),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text('Registro',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54)),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _nombreController,
                      decoration: InputDecorations.inputDecoration(
                        hinttext: 'Ingresa tu nombre',
                        labeltext: 'Nombre',
                        icono: const Icon(Icons.person_outline),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Campo requerido'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecorations.inputDecoration(
                        hinttext: 'Correo',
                        labeltext: 'Correo electrónico',
                        icono: const Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo requerido';
                        }
                        final pattern = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        return pattern.hasMatch(value)
                            ? null
                            : 'Correo no válido';
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecorations.inputDecoration(
                        hinttext: '********',
                        labeltext: 'Contraseña',
                        icono: const Icon(Icons.lock_outline),
                      ),
                      validator: (value) => value != null && value.length >= 6
                          ? null
                          : 'La contraseña debe tener al menos 6 caracteres',
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _alumnoController,
                      decoration: InputDecorations.inputDecoration(
                        hinttext: 'Nombre del alumno',
                        labeltext: 'Alumno',
                        icono: const Icon(Icons.school_outlined),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Campo requerido'
                          : null,
                    ),
                    const SizedBox(height: 30),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: const Color.fromARGB(255, 33, 113, 251),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80, vertical: 15),
                            onPressed: () => _register(context),
                            child: const Text('Registrar',
                                style: TextStyle(color: Colors.white)),
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextButton(
              child: const Text('¿Ya tienes cuenta? Inicia sesión',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45)),
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'loginpadre');
              },
            )
          ],
        ),
      ),
    );
  }

  SafeArea iconoProf() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 70),
        width: double.infinity,
        child: const Icon(Icons.account_circle_outlined,
            color: Colors.white, size: 100),
      ),
    );
  }

  Container cajaazul(Size size) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromARGB(173, 58, 103, 226),
          Color.fromARGB(201, 0, 34, 255),
        ]),
      ),
      width: double.infinity,
      height: size.height * 0.3,
      child: Stack(
        children: [
          Positioned(top: 90, left: 30, child: burbuja()),
          Positioned(top: -40, left: -30, child: burbuja()),
          Positioned(bottom: -50, right: -20, child: burbuja()),
          Positioned(bottom: -50, left: 10, child: burbuja()),
          Positioned(bottom: 120, right: -20, child: burbuja()),
        ],
      ),
    );
  }

  Container burbuja() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromRGBO(255, 255, 255, 0.15),
      ),
    );
  }
}
