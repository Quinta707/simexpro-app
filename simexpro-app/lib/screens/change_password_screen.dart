import 'dart:convert';
import 'dart:html';
import 'dart:js';

import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simexpro/screens/home_screen.dart';
import 'package:simexpro/screens/recover_password_screen.dart';
import 'package:simexpro/widgets/navbar_roots.dart';
import 'package:http/http.dart' as http;
import 'package:simexpro/api.dart';
import 'package:simexpro/toastconfig/toastconfig.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

Future<void> ValidarClaves(BuildContext context, String newpassword) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final username =  prefs.getString('username');
  final tarea = {
    'usua_Nombre':      username, 
    'usua_Contrasenia': newpassword 
  };
  final jsonTarea = jsonEncode(tarea);
  final response = await http.post(
    Uri.parse('${apiUrl}Usuarios/CambiarContrasenia'),
    headers: {
      'XApiKey': apiKey,
      'Content-Type': 'application/json',
    },
    body: jsonTarea,
  );
  if (response.statusCode == 200) {
    CherryToast.success(
      title: Text('Su contraseña ha sido reestablecida',
           style: TextStyle(color: Color.fromARGB(255, 226, 226, 226))),
      borderRadius: 0,
    ).show(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NavBarRoots(),
    ));
  } else {
    CherryToast.error(
      title: Text('Algo salió mal. Inténtelo nuevamente',
           style: TextStyle(color: Color.fromARGB(255, 226, 226, 226))),
      borderRadius: 0,
    ).show(context);
  }
}


class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool passToggle = true;
  String newpassword = ''; 
  String confirmpassword = '';
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Image.network(
                  "https://i.ibb.co/vk2tjx1/SIMEXPRO-V3-PNG.png",
                ),
              ),
              SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.all(18),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        newpassword = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Nueva contraseña"),
                      prefixIcon: Icon(Icons.person),
                      suffixIcon: InkWell(
                        onTap: () {
                          if (passToggle == true) {
                            passToggle = false;
                          } else {
                            passToggle = true;
                          }
                          setState(() {});
                        },
                        child: passToggle
                            ? Icon(CupertinoIcons.eye_slash_fill)
                            : Icon(CupertinoIcons.eye_fill),
                      ), // Personaliza el tamaño
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        confirmpassword = value;
                      });
                    },
                    obscureText: passToggle ? true : false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Confirmar contraseña"),
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: InkWell(
                        onTap: () {
                          if (passToggle == true) {
                            passToggle = false;
                          } else {
                            passToggle = true;
                          }
                          setState(() {});
                        },
                        child: passToggle
                            ? Icon(CupertinoIcons.eye_slash_fill)
                            : Icon(CupertinoIcons.eye_fill),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 20),
              Padding(
                  padding: const EdgeInsets.all(15),
                  child: InkWell(
                    onTap: () {
                      if (newpassword.isNotEmpty && confirmpassword.isNotEmpty) {
                        if (newpassword == confirmpassword){
                        ValidarClaves(context, newpassword);
                        } else{
                          CherryToast.error(
                          title: Text('Las contraseñas no coinciden',
                              style: TextStyle(color: Color.fromARGB(255, 226, 226, 226))),
                          borderRadius: 0,
                        ).show(context);
                        }
                      } else {
                        CherryToast.warning(
                          title: Text('Llene los campos correctamente',
                              style: TextStyle(color: Color.fromARGB(255, 226, 226, 226))),
                          borderRadius: 0,
                        ).show(context);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Personaliza el tamaño
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(87, 69, 223, 1),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Guardar nueva contraseña",
                          style: TextStyle(
                            fontSize: 18, // Modifica el tamaño de la fuente
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
