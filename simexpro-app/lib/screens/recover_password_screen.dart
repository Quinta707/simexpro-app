import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simexpro/screens/confirm_code_screen.dart';
import 'package:simexpro/screens/login_screen.dart';
import 'package:simexpro/toastconfig/toastconfig.dart';
import 'package:http/http.dart' as http;
import 'package:simexpro/api.dart';

import '../widgets/navbar_roots.dart';
import 'package:random_string_generator/random_string_generator.dart';

class RecoverPasswordScreen extends StatefulWidget {
  @override
  State<RecoverPasswordScreen> createState() => _RecoverPasswordScreenState();
}

void GenerateCode(){
  var generator = RandomStringGenerator(
    hasAlpha: true,
    alphaCase: AlphaCase.MIXED_CASE,
    hasDigits: true,
    hasSymbols: false,
    minLength: 5,
    maxLength: 5,
    mustHaveAtLeastOneOfEach: false,
  );

print(generator.generate());
}

Future<void> ObtenerCodigoVerificacion(BuildContext context, String username) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setString('usuariotemp', username);

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
           style: TextStyle(color: Color.fromARGB(255, 226, 226, 226))),
        borderRadius: 5,
      ).show(context);
    }
  });
  } else if(response.statusCode == 404){
    CherryToast.error(
      title: Text('El usuario no existe o no está disponible',
           style: TextStyle(color: Color.fromARGB(255, 226, 226, 226))),
      borderRadius: 5,
    ).show(context);
  } else {
    CherryToast.error(
      title: Text('Algo salió mal. Inténtelo nuevamente',
           style: TextStyle(color: Color.fromARGB(255, 226, 226, 226))),
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
   
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmCodeScreen(),
      ));
  } else {
    CherryToast.error(
      title: Text('Algo salió mal. Contacte un administrador',
           style: TextStyle(color: Color.fromARGB(255, 226, 226, 226))),
      borderRadius: 5,
    ).show(context);
    print(response);
  }
}


class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  bool passToggle = true;
  String username = ''; 
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
                    image: NetworkImage("https://i.ibb.co/0yqp5w1/fondo.png"),
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
                              Text('¿Contraseña olvidada?',
                                style: TextStyle( fontWeight: FontWeight.bold, fontSize: 28),),
                              Text('Completa el formulario para recuperarla',
                                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                              ),
                            ]
                           ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                          child: TextField(
                            onChanged: (value) {
                                setState(() {
                                  username = value;
                                });
                              },
                          decoration: InputDecoration(
                            labelText: "Ingrese su usuario",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(15),
                      child: InkWell(
                          onTap: () {
                      if (username.isNotEmpty) {
                            ObtenerCodigoVerificacion(context, username);
                          } else {
                            CherryToast.warning(
                              title: Text('Llene los campos correctamente',
                                  style: TextStyle(color: Color.fromARGB(255, 226, 226, 226))),
                              borderRadius: 5,
                            ).show(context);
                          }
                    },
                    child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Personaliza el tamaño
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(79, 70, 229, 1),
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
                              "Enviar correo",
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
                      Padding(padding: EdgeInsets.only(right: 15, left: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Regresar al",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(121, 129, 132, 1),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => loginScreen(),
                                ));
                              },
                            child: Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(79, 70, 229, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                     SizedBox(height: 10),
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
