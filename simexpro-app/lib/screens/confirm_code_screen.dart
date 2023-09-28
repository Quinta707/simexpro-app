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
           style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
           textAlign: TextAlign.justify),
      borderRadius: 5,
    ).show(context);
  }
}

Future<void> ObtenerCodigoVerificacion(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var username =  prefs.getString('usuariotemp');
  final response = await http.get(
    Uri.parse('${apiUrl}Usuarios/UsuarioCorreo?usua_Nombre=$username'),
    headers: {
      'XApiKey': apiKey,
      'Content-Type': 'application/json',
    },
  );
  final decodedJson = jsonDecode(response.body);
    final data = decodedJson["data"]; 

  if (response.statusCode == 200) {

    var generator = RandomStringGenerator(
      minLength: 5,
      maxLength: 6,
      hasSymbols: false,
    );

  Iterable.generate(1).forEach((_) async {
    try {
      var string = generator.generate();
      EnviarEmail(context, username, data["messageStatus"], string);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('code', string);

    } on RandomStringGeneratorException catch (e) {
      print(e.message);

       CherryToast.error(
      title: Text('El código no pudo ser generado',
           style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
           textAlign: TextAlign.justify),
        borderRadius: 5,
      ).show(context);
    }
  });
  } else if(response.statusCode == 404){
    CherryToast.error(
      title: Text('El usuario no existe o no está disponible',
           style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
           textAlign: TextAlign.justify),
      borderRadius: 5,
    ).show(context);
  } else {
    CherryToast.error(
      title: Text('Algo salió mal. Inténtelo nuevamente',
           style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
           textAlign: TextAlign.justify),
      borderRadius: 5,
    ).show(context);
  }
}

Future<void> EnviarEmail(BuildContext context, String username, String email, String codigo) async {
  final cuerpo = {
    'service_id': 'service_vmi2fud',
    'template_id': 'template_7pts636',
    'user_id': 'v8MonHOTfcrwu9Q4E',
    'template_params': {
        'to_name': username,
        'message': codigo,
        'send_to': email,
    }
  };
  final jsoncuerpo = jsonEncode(cuerpo);
  final response = await http.post(
    Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsoncuerpo,
  );
  if (response.statusCode == 200) {
   CherryToast.success(
      title: Text('Se ha enviado un nuevo código a tu correo',
           style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
           textAlign: TextAlign.justify),
      borderRadius: 5,
    ).show(context);
    
  } else {
    CherryToast.error(
      title: Text('Algo salió mal. Contacte un administrador',
           style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
           textAlign: TextAlign.justify),
      borderRadius: 5,
    ).show(context);
    print(response);
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
                    child: Image.network(
                      "https://i.ibb.co/vk2tjx1/SIMEXPRO-V3-PNG.png",
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
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Validar token',
                                style: TextStyle( fontWeight: FontWeight.bold, fontSize: 30),),
                              Text('Se te fue enviado un token a tu correo electrónico',
                                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                              ),
                            ]
                           ),
                          ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      child: TextField(
                        onChanged: (value) {
                            setState(() {
                              code = value;
                            });
                          },
                        decoration: InputDecoration(
                          labelText: "Ingrese el token recibido",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.token),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                        padding: const EdgeInsets.all(15),
                        child: InkWell(
                          onTap: () {
                        if (code.isNotEmpty) {
                              ValidarCodigo(context, code);
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
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                                "Validar token",
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
                    Padding(
                      padding: EdgeInsets.only(right: 15, left: 15),
                      child: Text(
                          "¿No has recibido tu token?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(121, 129, 132, 1),
                          ),
                        ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.only(right: 15, left: 15),
                        child: InkWell(
                      onTap: () {
                        ObtenerCodigoVerificacion(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        width: 170,
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
                            "Reenviar Token",
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
