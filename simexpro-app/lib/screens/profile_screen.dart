import 'package:flutter/material.dart';
import 'package:simexpro/screens/home_screen.dart';
import 'package:simexpro/screens/login_screen.dart';
import 'package:simexpro/utils/user_preferences.dart';
import 'package:simexpro/widgets/appbar_widget.dart';
import 'package:simexpro/widgets/navbar_roots.dart';
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
  bool isTextFieldVisible =
      false; // Variable para controlar la visibilidad del campo de entrada

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
              backgroundImage: NetworkImage(image),
              child: PopupMenuButton<MenuItem>(
                //padding: EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    image,
                    width: 50,
                  ),
                ),
                onSelected: (value) {
                  if (value == MenuItem.item1) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(),
                        ));
                  }
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
                    value: MenuItem.item1,
                    child: Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.person_2_outlined,
                              color: Color.fromRGBO(87, 69, 223, 1),
                            )),
                        const Text(
                          'Mi Perfil',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<MenuItem>(
                    value: MenuItem.item2,
                    child: Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.logout,
                              color: Color.fromRGBO(87, 69, 223, 1),
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

  Widget buildName(User user) => Column(
        children: [
          Text(
            NombreUsuario,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
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
          Container(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isTextFieldVisible =
                      true; // Mostrar el campo de entrada al presionar el botón
                });
              },
              child: Text('Cambiar Contraseña', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Color.fromRGBO(99, 74, 158, 1),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),
          )
        ],
      );

  Widget changuePassword(User user) => Column(
        children: [
          Visibility(
            visible: isTextFieldVisible,
            child: Padding(
              padding: const EdgeInsets.only(right: 18, left: 18, bottom: 18),
              child: TextField(
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Usuario"),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              
            ),
          ),
        ],
      );
}
