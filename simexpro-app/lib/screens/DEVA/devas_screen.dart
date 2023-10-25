import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simexpro/screens/historial_screen.dart';
import 'package:simexpro/screens/home_screen.dart';
import 'package:simexpro/screens/login_screen.dart';
import 'package:simexpro/screens/ordertracking/potracking_screen.dart';
import 'package:simexpro/screens/profile_screen.dart';
import 'package:simexpro/screens/DEVA/deva_qr_screen.dart';
import 'package:simexpro/screens/timeline_screen.dart';
import 'package:simexpro/toastconfig/toastconfig.dart';
import 'package:simexpro/widgets/taps.dart';
import 'package:http/http.dart' as http;
import 'package:simexpro/screens/DEVA/deva_Found_screen.dart';

import '../../api.dart';

class Devascreen extends StatefulWidget {
  const Devascreen({Key? key}) : super(key: key);

  @override
  _DevaScreenState createState() => _DevaScreenState();
}

Future<void> Imagen() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  image = prefs.getString('image');
}

Future<void> TraerDatosDeva(String codigoDEVA, context) async {

  try {
    final response = await http.get(
      Uri.parse('${apiUrl}Declaracion_Valor/Listar_ByDevaId?id=$codigoDEVA'),
      headers: {
        'XApiKey': apiKey,
        'Content-Type': 'application/json',
      },
    );
     final response2 = await http.get(
      Uri.parse('${apiUrl}Declaracion_Valor/ListarFacturasByDeva?deva_Id=$codigoDEVA'),
      headers: {
        'XApiKey': apiKey,
        'Content-Type': 'application/json',
      },
    );

      final decodedJson = jsonDecode(response.body);
      final data = decodedJson["data"];

      final decodedJson2 = jsonDecode(response2.body);
      final factura = decodedJson2["data"];

      final response3 = await http.get(
      Uri.parse('${apiUrl}Items/ListarItemsByFactId?fact_Id=$codigoDEVA'),
      headers: {
        'XApiKey': apiKey,
        'Content-Type': 'application/json',
      },
      );
      final decodedJson3 = jsonDecode(response3.body);
      final items = decodedJson3["data"];
      
      if (data.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var deva_Id = data[0]['deva_Id']; 
        prefs.setInt('deva_Id', deva_Id);
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Deva_Found_Screen(data: data, factura: factura,items: items),
          ),
        );
      } else {
        CherryToast.warning(
          title: const Text('El código no es válido',
            style: TextStyle(color: Colors.white),
          ),
        ).show(context);
      }
  
  } catch (error) {

    CherryToast.error(
          title: const Text('ha ocurrido un error de... ',
            style: TextStyle(color: Colors.white),
          ),
        ).show(context);

  }
}




class _DevaScreenState extends State<Devascreen> {
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

    void updatedText (val){
      setState((){
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
                  "Rastrear la Declaración de Valor",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(148, 82, 249, 1)),
                ),
              ),
            ),
            //SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      updatedText(value);
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Ingrese el Id de la declaración de valor"),
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
                      TraerDatosDeva('$searchValue', context);
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
                  SizedBox(height: 35),
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
                          builder: (context) => const   QRScannerScreen(),
                        )
                      );
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
