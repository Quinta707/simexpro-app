import 'package:flutter/material.dart';
import 'package:simexpro/screens/home_screen.dart';
import 'package:simexpro/utils/user_preferences.dart';
import 'package:simexpro/widgets/appbar_widget.dart';
import 'package:simexpro/widgets/profile_widget.dart';
import 'package:simexpro/model/user.dart';
import 'package:simexpro/widgets/button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    Rol = prefs.getString('rol');

    setState(() {}); // Esto fuerza una reconstrucción de la pantalla con la nueva imagen
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
        ],
      ),
    );
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            NombreUsuario,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          ),
        ],
      );

  Widget buildAbout(User user) => Container(
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                Rol,
                style: TextStyle(fontSize: 16, height: 1.4),
              ),
            ),
            Divider(height: 8),
          ],
        ),
      );

  Widget buildButton(User user) => Column(
        children: [
          Text(
            user.username,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          ),
        ],
      );
}
