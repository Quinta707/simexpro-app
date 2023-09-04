import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simexpro/screens/change_password_screen.dart';
import 'package:simexpro/screens/login_screen.dart';
import 'package:simexpro/toastconfig/toastconfig.dart';
import 'package:http/http.dart' as http;
import 'package:simexpro/api.dart';

import '../widgets/navbar_roots.dart';
import 'package:random_string_generator/random_string_generator.dart';

class ConfirmCodeScreen extends StatefulWidget {
  @override
  State<ConfirmCodeScreen> createState() => _ConfirmCodeScreenState();
}

Future<void> ValidarCodigo(BuildContext context, String code) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.getString('code');
  if ( prefs.getString('code') == code) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangePasswordScreen(),
    ));
  } else {
    CherryToast.error(
      title: Text('El código no es correcto',
           style: TextStyle(color: Color.fromARGB(255, 226, 226, 226))),
      borderRadius: 0,
    ).show(context);
  }
}

class _ConfirmCodeScreenState extends State<ConfirmCodeScreen> {
  bool passToggle = true;
  String code = ''; 
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
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: TextField(
                  onChanged: (value) {
                      setState(() {
                        code = value;
                      });
                    },
                  decoration: InputDecoration(
                    labelText: "Ingrese el codigo recibido",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              SizedBox(height: 20),
               Padding(
                  padding: const EdgeInsets.all(15),
                  child: InkWell(
                    onTap: () {
                  if (code.isNotEmpty) {
                        ValidarCodigo(context, code);
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
                          "Validar Código",
                          style: TextStyle(
                            fontSize: 18, // Modifica el tamaño de la fuente
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
               ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => loginScreen(),
                          ));
                    },
                   child: Text(
                      "¿No has recibido tu código",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(87, 69, 223, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
