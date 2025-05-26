import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/extras/input_decorations.dart';

class LoginProf extends StatefulWidget {
  const LoginProf({super.key});

  @override
  State<LoginProf> createState() => _LoginProfState();
}

class _LoginProfState extends State<LoginProf> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      // Autenticar al usuario con Firebase Authentication
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Verificar en Firestore si el usuario está aprobado
      final userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(credential.user!.uid)
          .get();

      if (userDoc.exists && userDoc.data()?['aprobado'] == true) {
        Navigator.pushReplacementNamed(context, 'homeprof');
      } else {
        _showDialog('Acceso denegado',
            'Tu cuenta aún no ha sido aprobada. Contacta con la administración.');
        FirebaseAuth.instance.signOut(); // Cierra la sesión automáticamente
      }
    } on FirebaseAuthException catch (e) {
      _showDialog('Error al iniciar sesión', e.message ?? 'Error desconocido');
    } catch (e) {
      _showDialog('Error inesperado', e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDialog(String title, String message) {
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Iniciar sesión',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
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
                      RegExp regExp = RegExp(pattern);
                      return regExp.hasMatch(value ?? '')
                          ? null
                          : 'El valor ingresado no es un correo válido';
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
                    validator: (value) {
                      return (value != null && value.length >= 6)
                          ? null
                          : 'La contraseña debe contener al menos 6 caracteres';
                    },
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
                          onPressed: _login,
                          child: const Text('Ingresar',
                              style: TextStyle(color: Colors.white)),
                        ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
          TextButton(
            child: const Text(
              'Crear cuenta',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'registroprof');
            },
          )
        ],
      ),
    );
  }

  SafeArea iconoprof() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 70),
        width: double.infinity,
        child: const Icon(Icons.school, color: Colors.white, size: 100),
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
