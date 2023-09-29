import 'package:flutter/material.dart';
import 'package:simexpro/screens/change_password_screen.dart';
import 'package:simexpro/screens/home_screen.dart';
import 'package:simexpro/screens/login_screen.dart';
import 'package:simexpro/utils/user_preferences.dart';
import 'package:simexpro/widgets/navbar_roots.dart';
import 'package:simexpro/widgets/profile_widget.dart';
import 'package:simexpro/model/user.dart';
import 'package:simexpro/widgets/button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simexpro/toastconfig/toastconfig.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:simexpro/api.dart';
import 'package:simexpro/widgets/navbar_roots.dart';
import 'package:image_picker/image_picker.dart';

import 'login_screen.dart';

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
  String newPassword = '';
  String VerifyNewPassword = '';

  bool newpasswordIsValid = false;
  bool newpasswordIsValid2 = false;

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

  Future<void> ValidarClaves(BuildContext context, String newpassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final tarea = {
      'usua_Nombre': username,
      'usua_Contrasenia': newpassword.trim()
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
      setState(() {
        isTextFieldVisible = false;
        isOldPasswordVisisble = false;
        isNewPasswordVisisble = false;
        oldPassworrd = "";
        newpassword = "";
        VerifyNewPassword = "";
      });

      CherryToast.success(
        title: Text('Su contraseña ha sido reestablecida',
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

  bool validatePassword(String value) {
    // Comprueba si la contraseña tiene al menos 8 caracteres
    if (value.length < 8) {
      return false;
    }

    // Comprueba si la contraseña contiene al menos una letra mayúscula
    bool hasUpperCase = value.contains(new RegExp(r'[A-Z]'));
    if (!hasUpperCase) {
      return false;
    }

    // Comprueba si la contraseña contiene al menos un carácter especial
    bool hasSpecialChar = value.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    if (!hasSpecialChar) {
      return false;
    }

    // Si todas las condiciones son verdaderas, la contraseña es válida
    return true;
  }

  @override
  Widget build(BuildContext context) {
    const user = UserPreferences.myUser;

    return Scaffold(
      appBar: AppBar(
        title: const Image(
          height: 35,
          image: AssetImage('images/slogan.png'),
        ),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(imagen),
              child: PopupMenuButton<MenuItem>(
                //padding: EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    imagen,
                    width: 50,
                  ),
                ),
               onSelected: (value) {
                  if (value == MenuItem.item2) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => loginScreen(),
                        ));
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<MenuItem>(
                    value: MenuItem.item2,
                    child: Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.logout,
                              color: Color.fromRGBO(99, 74, 158, 1),
                            )),
                        const Text(
                          'Cerrar Sesión',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
        backgroundColor: Color.fromRGBO(17, 24, 39, 1),
        //elevation: 50.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Regresar',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        //systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 30),
          ProfileWidget(
            imagePath: image,
            onClicked: () async {},
          ),
          const SizedBox(height: 10),
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
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
                      color: Color.fromRGBO(99, 74, 158, 1),
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
                  Divider(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.work,
                      color: Color.fromRGBO(99, 74, 158, 1),
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
                  Divider(height: 8), // Agrega una línea divisoria más pequeña
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.markunread_outlined,
                      color: Color.fromRGBO(99, 74, 158, 1),
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
            child: Container(// Ajusta la altura del botón
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isTextFieldVisible = true;
                    isOldPasswordVisisble = true;
                  });
                },
                child: Text('Cambiar Contraseña', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),),
                style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Color.fromRGBO(99, 74, 158, 1),
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
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
                      prefixIcon: Icon(Icons.key),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: 165,
                        height: 50,
                        margin: EdgeInsets.only(left: 20, right: 5),
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (oldPassworrd.trim() == "") {
                                    CherryToast.warning(
                                      title: Text(
                                          'Llene los campos correctamente',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 226, 226, 226))),
                                      borderRadius: 5,
                                    ).show(context);
                                  } else {
                                    fetchData(context, NombreUsuario,
                                        oldPassworrd.trim());
                                  }
                                });
                              },
                              child: Text('Validar', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Color.fromRGBO(99, 74, 158, 1),
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 165,
                        height: 50,
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
                              child: Text('Cancelar', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Color.fromRGBO(87, 87, 87, 1),
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
                    padding: const EdgeInsets.only(right: 18, left: 18),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          newpassword = value;
                          newpasswordIsValid = validatePassword(value);
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Nueva contraseña'),
                        prefixIcon: Icon(Icons.key),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 18, left: 18, bottom: 18),
                    child: newpasswordIsValid
                        ? Text('')
                        : Text(
                            'Ingrese mínimo 8 caracteres, al menos una mayúscula y al menos un carácter especial',
                            style: TextStyle(
                                color: Colors
                                    .red), // Puedes personalizar el estilo del mensaje de error
                          ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 18, left: 18, bottom: 18),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          VerifyNewPassword = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Confirmar contraseña'),
                        prefixIcon: Icon(Icons.key),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: 165,
                          height: 50,
                          margin: EdgeInsets.only(left: 20, right: 5),
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              child: ElevatedButton(
                                onPressed: newpasswordIsValid
                                    ? () {
                                        setState(() {
                                          if (newpassword.trim() == "" ||
                                              VerifyNewPassword.trim() == "") {
                                            CherryToast.warning(
                                              title: Text(
                                                'Llene los campos correctamente',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 226, 226, 226),
                                                ),
                                              ),
                                              borderRadius: 5,
                                            ).show(context);
                                          } else {
                                            if (newpassword.trim() !=
                                                VerifyNewPassword.trim()) {
                                              CherryToast.error(
                                                title: Text(
                                                  'Las contraseñas no coinciden',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 226, 226, 226),
                                                  ),
                                                ),
                                                borderRadius: 5,
                                              ).show(context);
                                            } else {
                                              ValidarClaves(
                                                  context, newpassword);
                                            }
                                          }
                                        });
                                      }
                                    : null, // Deshabilitar el botón si newpasswordIsValid es false
                                child: Text('Guardar contraseña', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                style:  newpasswordIsValid ? ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: Color.fromRGBO(99, 74, 158, 1),
                                  )
                                 : 
                                 ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Color.fromRGBO(87, 87, 87, 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: 165,
                          height: 50,
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
                                child: Text('Cancelar', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Color.fromRGBO(87, 87, 87, 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )),
          SizedBox(height: 15),
        ],
      );
}
