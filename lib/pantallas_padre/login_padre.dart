import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/extras/input_decorations.dart';

class LoginPadre extends StatefulWidget {
  const LoginPadre({super.key});

  @override
  State<LoginPadre> createState() => _LoginPadreState();
}

class _LoginPadreState extends State<LoginPadre> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      // Iniciar sesión
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final uid = credential.user!.uid;

      // Obtener el documento del usuario (tutor)
      final userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        _showDialog(context, 'Error', 'El usuario no existe en Firestore.');
        return;
      }

      final data = userDoc.data()!;
      final tipo = data['tipo'];
      final alumnoNombre = data['alumno'];

      if (tipo != 'Tutor') {
        _showDialog(context, 'Acceso denegado',
            'Solo los usuarios con tipo "Tutor" pueden ingresar.');
        return;
      }

      if (alumnoNombre == null || alumnoNombre.isEmpty) {
        _showDialog(context, 'Error',
            'El tutor no tiene un alumno asociado en su registro.');
        return;
      }

      // Validar que el alumno asociado exista y esté activo
      final alumnoQuery = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('nombre', isEqualTo: alumnoNombre)
          .where('tipo', isEqualTo: 'Alumno')
          .where('estado', isEqualTo: 'activo')
          .limit(1)
          .get();

      if (alumnoQuery.docs.isEmpty) {
        _showDialog(context, 'Acceso denegado',
            'El alumno asociado no existe o no está activo.');
        return;
      }

      // Redirigir a la pantalla principal del tutor
      Navigator.pushReplacementNamed(context, 'homepadre');
    } on FirebaseAuthException catch (e) {
      _showDialog(context, 'Error de inicio de sesión',
          e.message ?? 'Error desconocido');
    } catch (e) {
      _showDialog(context, 'Error inesperado', e.toString());
    }
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
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
            iconoprof(),
            loginform(context),
            Positioned(
              bottom: 30,
              left: size.width * 0.4,
              child: IconButton(
                icon: const Icon(Icons.arrow_circle_left_outlined,
                    color: Colors.black, size: 40),
                onPressed: () {
                  Navigator.pushNamed(context, 'inicio');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loginform(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 230),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            height: 350,
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
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text('Iniciar sesión',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54)),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        decoration: InputDecorations.inputDecoration(
                          hinttext: 'ejemplo@gmail.com',
                          labeltext: 'Correo',
                          icono: const Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          String pattern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          return RegExp(pattern).hasMatch(value ?? '')
                              ? null
                              : 'Correo inválido';
                        },
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        autocorrect: false,
                        decoration: InputDecorations.inputDecoration(
                          hinttext: '********',
                          labeltext: 'Contraseña',
                          icono: const Icon(Icons.lock_outline),
                        ),
                        validator: (value) {
                          return (value != null && value.length >= 6)
                              ? null
                              : 'Debe tener al menos 6 caracteres';
                        },
                      ),
                      const SizedBox(height: 30),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        disabledColor: Colors.grey,
                        color: const Color.fromARGB(255, 33, 113, 251),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80, vertical: 15),
                        child: const Text('Ingresar',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () => _login(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          TextButton(
            child: const Text('Crear cuenta',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black45)),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'registropadre');
            },
          ),
        ],
      ),
    );
  }

  SafeArea iconoprof() {
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
