import 'dart:convert';

import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simexpro/screens/DUCA/duca_found_screen.dart';
import 'package:simexpro/screens/DUCA/ducaqrscanner_screen.dart';
import 'package:simexpro/screens/historial_screen.dart';
import 'package:simexpro/screens/home_screen.dart';
import 'package:simexpro/screens/login_screen.dart';
import 'package:simexpro/screens/ordertracking/potracking_screen.dart';
import 'package:simexpro/screens/profile_screen.dart';
import 'package:simexpro/screens/ordertracking/qrscanner_screen.dart';
import 'package:simexpro/screens/timeline_screen.dart';
import 'package:simexpro/toastconfig/toastconfig.dart';
import 'package:simexpro/widgets/taps.dart';
import 'package:http/http.dart' as http;

import '../../api.dart';

class DucasScreen extends StatefulWidget {
  const DucasScreen({Key? key}) : super(key: key);

  @override
  _DucasScreenState createState() => _DucasScreenState();
}

Future<void> Imagen() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  image = prefs.getString('image');
}

Future<void> TraerDatos(String NoDuca, context) async {
  final response = await http.post(
    Uri.parse('${apiUrl}Duca/List_ByNoDuca?NoDuca=$NoDuca'),
    headers: {
      'XApiKey': apiKey,
      'Content-Type': 'application/json',
    },
  );
  final decodedJson = jsonDecode(response.body);
  final data = decodedJson["data"];
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var duca_Id = data[0]['duca_Id'];
  prefs.setInt('duca_Id', duca_Id);

  if (data.length > 0) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Duca_Found_Screen(data: data),
        ));
  } else {
    CherryToast.warning(
            title: const Text('El código no es válido',
                style: TextStyle(color: Colors.white)))
        .show(context);
  }
}

Future<void> TraerDatosById(int Id_Duca, context) async {
  final response = await http.post(
    Uri.parse('${apiUrl}Duca/Listar_ById?id=$Id_Duca'),
    headers: {
      'XApiKey': apiKey,
      'Content-Type': 'application/json',
    },
  );
  final decodedJson = jsonDecode(response.body);
  final data = decodedJson["data"];
  String NoDuca = data[0]['duca_No_Duca'];

  if (data.length > 0) {
    TraerDatos(NoDuca, context);
  }
}

class _DucasScreenState extends State<DucasScreen> {
  int _selectedIndex = 0;
  final _screens = [
    TapsProduccion(),
    historialScreen(),
    TimelineScreen(),
  ];
  @override
  void initState() {
    super.initState();
    Imagen();
  }

  String searchValue = '';

  void updatedText(val) {
    setState(() {
      searchValue = val;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
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
        //elevation: 50.0
        //systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Búsqueda de DUCA",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(148, 82, 249, 1)),
                ),
              ),
            ),
            //SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      updatedText(value);
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Ingrese el Número de DUCA"),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Color.fromRGBO(99, 74, 158, 1),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    ),
                    onPressed: () {
                      // CherryToast.success(
                      //         title: Text('Trae los datoss',
                      //             style: TextStyle(color: Colors.white)))
                      //     .show(context);
                      TraerDatos('$searchValue', context);
                    },
                    icon: Icon(Icons.search),
                    label: Text(
                      'Buscar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: new Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: Divider(
                          color: Colors.black,
                        ),
                      )),
                      Text("O"),
                      Expanded(
                          child: new Container(
                        margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                        child: Divider(
                          color: Colors.black,
                        ),
                      ))
                    ],
                  ),
                  SizedBox(height: 40),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Color.fromRGBO(99, 74, 158, 1),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DucaQRScannerScreen(),
                          ));
                    },
                    icon: Icon(Icons.qr_code),
                    label: Text(
                      'Escanear',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
