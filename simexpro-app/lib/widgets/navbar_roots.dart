import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simexpro/screens/home_screen.dart';
import 'package:simexpro/screens/historial_screen.dart';
import 'package:simexpro/screens/login_screen.dart';
import 'package:simexpro/screens/maquinas_screen.dart';
import 'package:simexpro/screens/profile_screen.dart';
import 'package:simexpro/screens/rastreo_aduana.dart';
import 'package:simexpro/screens/timeline_screen.dart';
import 'package:simexpro/widgets/taps.dart';
import 'package:simexpro/widgets/taps_Aduana.dart';

import '../screens/historial_screen_Aduana.dart';
import '../screens/ordertracking/orders_screen.dart';
import 'package:simexpro/screens/deva_screen.dart';
import 'package:simexpro/screens/DEVA/devas_screen.dart';

import 'package:simexpro/screens/DUCA/duca_screen.dart';

enum MenuItem { item1, item2 }

class NavBarRoots extends StatefulWidget {
  @override
  State<NavBarRoots> createState() => _NavBarRootsState();
}

class _NavBarRootsState extends State<NavBarRoots> {
  int _selectedIndex = 0;
  List<Widget> _screens = [];
  bool esAduana1 = false;
  String imagenperfil = '';
  String username = '';
  @override
  void initState() {
    super.initState();
    Imagen();
  }


   Future<void> Imagen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    image = prefs.getString('image');
    imagenperfil = image;
    bool esAduana = prefs.getBool('esAduana');
    esAduana1 = esAduana;
    username = prefs.getString('username');
    setState(() {
      if (esAduana) {
      _screens = [
        GraficasAduanas(), // Usa la pantalla relacionada con la aduana
        historialAduanaScreen(), // Modifica esta línea a la pantalla de historial relacionada con la aduana
        TimelineAduanaScreen(),
        const OrdersScreen(),
      ];
    } else {
      _screens = [
        TapsProduccion(),
        historialScreen(), // Usa la pantalla de historial existente
        TimelineScreen(),
        const OrdersScreen(),
      ];
    }
    });
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: _selectedIndex != 0
              ? AppBar(
                  title: const Image(
                    height: 35,
                    image: NetworkImage('https://i.ibb.co/HgdBM0r/slogan.png'),
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
                  //systemOverlayStyle: SystemUiOverlayStyle.light,
                )
              : null,
          backgroundColor: Colors.white,
          body: _screens[_selectedIndex],
          bottomNavigationBar: Container(
            height: 80,
            child: BottomNavigationBar(
              backgroundColor: Color.fromRGBO(17, 24, 39, 1),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Color.fromRGBO(87, 69, 223, 1),
              unselectedItemColor: Colors.white,
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_filled), label: "Inicio"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month_outlined), label: "Historial"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.timelapse_outlined), label: "Rastreo"),
              ],
            ),
          ),
          drawer: Drawer(
            backgroundColor: Color.fromRGBO(17, 24, 39, 1),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                SizedBox(height: 10),
                Image.network('https://i.ibb.co/HgdBM0r/slogan.png', height: 50),
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(imagenperfil),
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: Text(username, style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700)),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    ListTile(
                       leading: Icon(Icons.person, color: Colors.white),
                      title: Text(
                        'Perfil',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                        ));
                      },
                    ),
                  ],
                ),
                esAduana1
                ? Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.document_scanner, color: Colors.white),
                      title: Text(
                        'Rastreo de declaraciones de valor',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onTap: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Devascreen(),
                        ));
                      },
                    ),
                    ListTile(
                       leading: Icon(Icons.edit_document, color: Colors.white),
                      title: Text(
                        'Rastreo de ducas',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onTap: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DucasScreen(),
                        ));
                      },
                    )
                  ],
                )
                : Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.precision_manufacturing_rounded, color: Colors.white),
                      title: Text(
                        'Rastreo de máquinas',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onTap: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MaquinasScreen(),
                        ));
                      },
                    ),
                    ListTile(
                       leading: Icon(Icons.shopping_bag_rounded, color: Colors.white),
                      title: Text(
                        'Rastreo de órdenes de compra',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onTap: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrdersScreen(),
                        ));
                      },
                    )
                  ],
                ),
              ],
            ),
          )
        ),
    );
  }
}
