import 'package:flutter/material.dart';


//Esta clase solamente funciona para la decoracion del inicio de sesion, tanto el formato del correo como el de la contrasenia
class InputDecorations {
  static InputDecoration inputDecoration(
    {
      required String hinttext,
      required String labeltext,
      required Icon icono}){
        return InputDecoration(
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 58, 108, 183)),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 12, 80, 190), width: 2),
          ),
          hintText: hinttext,
          labelText: labeltext,
          prefixIcon: icono,
        );
      }
    }