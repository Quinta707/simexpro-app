import 'package:flutter/material.dart';
import 'package:simexpro/screens/profile_screen.dart';

import '../widgets/navbar_roots.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class ItemTrackingScreen extends StatefulWidget {
  const ItemTrackingScreen({Key? key}) : super(key: key);

  @override
  State<ItemTrackingScreen> createState() => _ItemTrackingScreenState();
}

class _ItemTrackingScreenState extends State<ItemTrackingScreen> with TickerProviderStateMixin{

  @override
  Widget build(BuildContext context){

    TabController _TabController = 
    TabController(length: 2, vsync: this);

    return Scaffold(
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
      body: Column(
        children: [
          Container(
            child: TabBar(
              controller: _TabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: "Información general",),
                Tab(text: "Proceso")
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            height: 300,
            child: TabBarView(
              controller: _TabController,
              children: const [
                Text("Hi"),
                Text("what's up?")
              ],
            ),
          )
        ],
      ),
    );
  }
}