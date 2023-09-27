import 'package:flutter/material.dart';
import 'package:simexpro/screens/change_password_screen.dart';
import 'package:simexpro/screens/home_screen.dart';
import 'package:simexpro/utils/user_preferences.dart';
import 'package:simexpro/widgets/appbar_widget.dart';
import 'package:simexpro/widgets/profile_widget.dart';
import 'package:simexpro/model/user.dart';
import 'package:simexpro/widgets/button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simexpro/toastconfig/toastconfig.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:simexpro/api.dart';
import 'package:simexpro/widgets/navbar_roots.dart';

String imagen = '';
String NombreUsuario = '';
String NombreEmpleado = '';
String CorreoElectoinico = '';
String Rol = '';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => PerfilUsuario();
}

class PerfilUsuario extends State<ProfileScreen> {
  bool isTextFieldVisible =
      false; // Variable para controlar la visibilidad del campo de entrada
  bool isNewPasswordVisisble = false;
  bool isOldPasswordVisisble = false;

  String oldPassworrd = '';
  String NewPassword = '';
  String VerifyNewPassword = '';

  void initState() {
    super.initState();
    Imagen();
  }

  Future<void> Imagen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    imagen = prefs.getString('image');
    NombreUsuario = prefs.getString('username');
    NombreEmpleado = prefs.getString('userfullname');
    CorreoElectoinico = prefs.getString('email');
    Rol = prefs.getString('rol') != null ? prefs.getString('rol') : "Sin Rol";

    setState(
        () {}); // Esto fuerza una reconstrucción de la pantalla con la nueva imagen
  }

  Future<void> fetchData(
      BuildContext context, String username, String password) async {
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
      isNewPasswordVisisble = true;
      isOldPasswordVisisble = !isOldPasswordVisisble;
      setState(() {});
    } else {
      CherryToast.error(
        title: Text('Contraseña Incorrrecta',
            style: TextStyle(color: Color.fromARGB(255, 226, 226, 226))),
        borderRadius: 5,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    const user = UserPreferences.myUser;

    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: image,
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          buildName(user),
          const SizedBox(height: 20),
          buildAbout(user),
          const SizedBox(height: 20),
          buildButton(user),
          const SizedBox(height: 20),
          changuePassword(user),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // AQUI SE MUESTRA EL NOMBRE DEL USUARIO
  Widget buildName(User user) => Column(
        children: [
          Text(
            NombreUsuario,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          ),
        ],
      );

  //AQUI SE MUESTRA TODA LA INFORMACION DEL USUARIO
  Widget buildAbout(User user) => Column(
        children: [
          Visibility(
            visible: !isTextFieldVisible,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.person_outline,
                      color: Color.fromRGBO(87, 69, 223, 1),
                      size: 28.0,
                    ),
                    title: Text(
                      "Nombre",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      NombreEmpleado,
                      style: TextStyle(fontSize: 16, height: 1.4),
                    ),
                  ),
                  Divider(height: 8), // Agrega una línea divisoria más pequeña
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.markunread,
                      color: Color.fromRGBO(87, 69, 223, 1),
                      size: 24.0,
                    ),
                    title: Text(
                      'Correo Electrónico',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      CorreoElectoinico,
                      style: TextStyle(fontSize: 16, height: 1.4),
                    ),
                  ),
                  Divider(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.manage_accounts,
                      color: Color.fromRGBO(87, 69, 223, 1),
                      size: 24.0,
                    ),
                    title: Text(
                      'Rol',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      Rol,
                      style: TextStyle(fontSize: 16, height: 1.4),
                    ),
                  ),
                  Divider(height: 8),
                ],
              ),
            ),
          )
        ],
      );

  //AQUI SE MUESTRA EL BOTON DE CAMBIAR CONTRASEÑA
  Widget buildButton(User user) => Column(
        children: [
          Visibility(
            visible: !isTextFieldVisible,
            child: Container(
              width: 200.0, // Ajusta el ancho del botón
              height: 30.0, // Ajusta la altura del botón
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isTextFieldVisible = true;
                    isOldPasswordVisisble = true;
                  });
                },
                child: Text('Cambiar Contraseña'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromRGBO(99, 74, 158, 1.0)),
                ),
              ),
            ),
          )
        ],
      );

  Widget changuePassword(User user) => Column(
        children: [
          Visibility(
            visible: isOldPasswordVisisble,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: 18, left: 18, bottom: 18),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        oldPassworrd = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Contraseña Actual'),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: 165,
                        height: 40,
                        margin: EdgeInsets.only(left: 20, right: 5),
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (oldPassworrd == "") {
                                    CherryToast.warning(
                                      title: Text(
                                          'Llene los campos correctamente',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 226, 226, 226))),
                                      borderRadius: 5,
                                    ).show(context);
                                  } else {
                                    fetchData(
                                        context, NombreUsuario, oldPassworrd);
                                  }
                                });
                              },
                              child: Text('Validar'),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromRGBO(99, 74, 158, 1.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 165,
                        height: 40,
                        margin: EdgeInsets.only(left: 5, right: 20),
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isTextFieldVisible = false;
                                  isOldPasswordVisisble = false;
                                  isNewPasswordVisisble = false;
                                  oldPassworrd = "";
                                  newpassword = "";
                                  VerifyNewPassword = "";
                                  
                                });
                              },
                              child: Text('Cancelar'),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromRGBO(87, 87, 87, 1)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Visibility(
              visible: isNewPasswordVisisble,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 18, left: 18, bottom: 18),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          newpassword = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Nueva Contraseña'),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                  )
                ],
              )),
          SizedBox(height: 15),
        ],
      );
}
