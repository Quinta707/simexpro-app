import 'dart:convert';
import 'dart:html';
import 'dart:js';

import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simexpro/screens/home_screen.dart';
import 'package:simexpro/screens/sign_up_screen.dart';
import 'package:simexpro/widgets/navbar_roots.dart';
import 'package:http/http.dart' as http;
import 'package:simexpro/api.dart';
import 'package:simexpro/toastconfig/toastconfig.dart';

class loginScreen extends StatefulWidget {
  @override
  State<loginScreen> createState() => _loginScreenState();
}

Future<void> fetchData(BuildContext context, String username, String password) async {
  print('fetchdata');
  final tarea = {'usua_Nombre': username, 'usua_Contrasenia': password};
  final jsonTarea = jsonEncode(tarea);
  final response = await http.post(
    Uri.parse('${apiUrl}Usuarios/Login'),
    headers: {
      'XApiKey': apiKey,
      'Content-Type': 'application/json',
    },
    body: jsonTarea,
  );
  if (response.statusCode == 200) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NavBarRoots(),
    ));
  } else {
    print('a');
    CherryToast.error(
      title: Text('El usuario o contraseña son incorrectos',
           style: TextStyle(color: Color.fromARGB(255, 226, 226, 226))),
      borderRadius: 0,
    ).show(context);
    // CherryToast.error(
    //     title: Text('Error',
    //           style: TextStyle(color: Color(0xffE43837)),),
    //     enableIconAnimation: false,
    //     displayTitle: true,
    //     description: Text('El usuario o la contraseña son incorrectos',
    //     style: TextStyle(color: Colors.white),),
    //     animationType: AnimationType.fromRight,
    //     animationDuration: Duration(milliseconds: 1000),
    //     autoDismiss: true,
    // ).show(context);
  }
}


class _loginScreenState extends State<loginScreen> {
  bool passToggle = true;
  String username = ''; 
  String password = '';
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
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        username = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Usuario"),
                      prefixIcon: Icon(Icons.person),
                      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10), // Personaliza el tamaño
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    obscureText: passToggle ? true : false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Contraseña"),
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
                      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10), // Personaliza el tamaño
                    ),
                  ),
                ),
              SizedBox(height: 20),
              Padding(
                  padding: const EdgeInsets.all(15),
                  child: InkWell(
                    onTap: () {
                      if (username.isNotEmpty && password.isNotEmpty) {
                        fetchData(context, username, password);
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
                          "Iniciar sesión",
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
              SizedBox(height: 20),
             Row(
                mainAxisAlignment: MainAxisAlignment.end, // Alinea a la derecha
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Recuperar contraseña",
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
