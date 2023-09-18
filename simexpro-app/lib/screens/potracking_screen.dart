import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simexpro/screens/profile_screen.dart';

import '../widgets/navbar_roots.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class POTrackingScreen extends StatefulWidget {
  const POTrackingScreen({Key? key}) : super (key: key);

  @override
  _POTrackingScreenState createState() => _POTrackingScreenState();
}

Future<void> Imagen() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  image = prefs.getString('image');
}

class _POTrackingScreenState extends State<POTrackingScreen> {
  @override 
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: const Image(
          height: 35,
          image: NetworkImage('https://i.ibb.co/HgdBM0r/slogan.png'),
        ),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
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
                      children: const [
                        Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.person_2_outlined,
                              color: Color.fromRGBO(87, 69, 223, 1),
                            )),
                        Text(
                          'Mi Perfil',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<MenuItem>(
                    value: MenuItem.item2,
                    child: Row(
                      children: const [
                        Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.logout,
                              color: Color.fromRGBO(87, 69, 223, 1),
                            )),
                        Text(
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
        backgroundColor: const Color.fromRGBO(17, 24, 39, 1),
        // leading: IconButton(
        //   icon: const Icon(Icons.menu),
        //   tooltip: 'Menú',
        //   onPressed: () {},
        // ),
      ),
      backgroundColor: Colors.purple,
      body: 
          Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(10),
              //   child: Text(
              //     "Orden de Compra: PRUE123",
              //     style: TextStyle(background: Paint()..color = Colors.black12
              //                     ..strokeWidth = 17
              //                     ..style = PaintingStyle.stroke,)
              //   ),  
              // ),
              Container(
                // width: ,
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                child: const Text(
                  "Orden de Compra: PRUE123",
                ),
              ),
              const SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 5.0,
                crossAxisCount: 3,
                childAspectRatio: 17.0,
                // height: ,
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                                    color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ],
              )                     
            ],
          ),
        // child: Container(
          // child: 
        // ),
      ),
    );
  }
}