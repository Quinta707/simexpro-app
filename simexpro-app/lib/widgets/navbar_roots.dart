import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simexpro/screens/home_screen.dart';
import 'package:simexpro/screens/historial_screen.dart';
import 'package:simexpro/screens/login_screen.dart';
import 'package:simexpro/screens/profile_screen.dart';
import 'package:simexpro/screens/timeline_screen.dart';
import 'package:simexpro/widgets/taps.dart';
import 'package:simexpro/widgets/taps_Aduana.dart';

enum MenuItem { item1, item2 }

class NavBarRoots extends StatefulWidget {
  @override
  State<NavBarRoots> createState() => _NavBarRootsState();
}

Future<void> Imagen() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  image = prefs.getString('image');
}

class _NavBarRootsState extends State<NavBarRoots> {
  int _selectedIndex = 0;
  final _screens = [
    GraficasAduanas(),
    historialScreen(),
    TimelineScreen(),
  ];

  @override
  void initState() {
    super.initState();
    Imagen();
  }

  Widget build(BuildContext context) {
    return Scaffold(
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
              leading: IconButton(
                icon: const Icon(Icons.menu),
                tooltip: 'Menú',
                onPressed: () {},
              ),
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
    );
  }
}
