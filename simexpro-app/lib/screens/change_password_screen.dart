import 'dart:async';
import 'dart:convert';

import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simexpro/screens/home_screen.dart';
import 'package:simexpro/screens/login_screen.dart';
import 'package:simexpro/screens/recover_password_screen.dart';
import 'package:simexpro/widgets/navbar_roots.dart';
import 'package:http/http.dart' as http;
import 'package:simexpro/api.dart';
import 'package:simexpro/toastconfig/toastconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}


Future<void> delayFunction(BuildContext context) async {
   CherryToast.success(
      title: Text('Su contraseña ha sido reestablecida',
           style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
           textAlign: TextAlign.justify),
      borderRadius: 5,
    ).show(context);
  await Future.delayed(Duration(seconds: 3));
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => loginScreen(),
    ));
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
    delayFunction(context);

  } else {
    CherryToast.error(
      title: Text('Algo salió mal. Inténtelo nuevamente',
           style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
           textAlign: TextAlign.justify),
      borderRadius: 5,
    ).show(context);
  }
}

 String newpassword = ''; 
  String confirmpassword = '';
class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool passToggle = true;
 
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: SafeArea(
          child: Container(
             alignment: Alignment.center,
             decoration: BoxDecoration(
                  image: DecorationImage(
                    image:AssetImage("images/fondo.png"),
                    fit: BoxFit.cover,
                  ),
                ),
            child: Column(
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Image.asset(
                  "images/SIMEXPRO-V3-PNG.png",
                  height: 230,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Reestablecer contraseña',
                                style: TextStyle( fontWeight: FontWeight.bold, fontSize: 28),),
                              Text('Ingresa la nueva contraseña de tu cuenta',
                                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                              ),
                            ]
                           ),
                          ),  
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
                              prefixIcon: Icon(Icons.key), // Personaliza el tamaño
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
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Confirmar contraseña"),
                              prefixIcon: Icon(Icons.key),
                            ),
                          ),
                        ),
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
                                      style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
                                      textAlign: TextAlign.justify),
                                  borderRadius: 5,
                                ).show(context);
                                }
                              } else {
                                CherryToast.warning(
                                  title: Text('Llene los campos correctamente',
                                      style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
                                      textAlign: TextAlign.justify),
                                  borderRadius: 5,
                                ).show(context);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Personaliza el tamaño
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(87, 69, 223, 1),
                                borderRadius: BorderRadius.circular(50),
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
                                  "Guardar contraseña",
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
                      // Padding(
                      //   padding: EdgeInsets.only(left: 15, right: 15),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       TextButton(
                      //         onPressed: () {
                      //           Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                 builder: (context) => loginScreen(),
                      //               ));
                      //         },
                      //       child: Text(
                      //           "Regresar al login",
                      //           style: TextStyle(
                      //             fontSize: 18,
                      //             fontWeight: FontWeight.bold,
                      //             color: Color.fromRGBO(87, 69, 223, 1),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(height: 15),
                    ]
                  ),
                ),
              ),
              SizedBox(height: 200),
            ],
          ),
        ),
      ),
     ),
    );
  }
}
