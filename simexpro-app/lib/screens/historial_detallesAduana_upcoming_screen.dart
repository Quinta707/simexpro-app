import 'dart:convert';

import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:simexpro/screens/historial_screen.dart';
import 'package:simexpro/screens/home_screen.dart';
import 'package:simexpro/screens/login_screen.dart';
import 'package:simexpro/screens/ordertracking/potracking_screen.dart';
import 'package:simexpro/screens/profile_screen.dart';
import 'package:simexpro/screens/ordertracking/qrscanner_screen.dart';
import 'package:simexpro/screens/timeline_screen.dart';
import 'package:simexpro/toastconfig/toastconfig.dart';
import 'package:simexpro/widgets/devas_por_duca_upcoming.dart';
import 'package:simexpro/widgets/taps.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';



import '../api.dart';

class OrderData {
  final int id;
  final String duca_No_Duca;
  final String duca_No_Correlativo_Referencia;
  final String nombre_Aduana_Registro;
  final String nombre_Aduana_Destino;
  final String nombre_pais_procedencia;
  final String duca_FechaVencimiento;
  final String duca_Manifiesto;
  final String duca_Titulo;
   
  
  
  
  OrderData({
    required this.id,
    required this.duca_No_Duca,
    required this.duca_No_Correlativo_Referencia,
    required this.nombre_Aduana_Registro,
    required this.nombre_Aduana_Destino,
    required this.nombre_pais_procedencia,
    required this.duca_FechaVencimiento,
    required this.duca_Manifiesto,
    required this.duca_Titulo,
 
 
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'duca_No_Duca': duca_No_Duca,
      'duca_No_Correlativo_Referencia': duca_No_Correlativo_Referencia,
      'nombre_Aduana_Registro': nombre_Aduana_Registro,
      'nombre_Aduana_Destino': nombre_Aduana_Destino,
      'nombre_pais_procedencia': nombre_pais_procedencia,
      'duca_FechaVencimiento': duca_FechaVencimiento,
      'duca_FechaVencimiento': duca_Manifiesto,
      'duca_FechaVencimiento': duca_Titulo,
      
    };
  }
}


Future<void> Imagen() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  image = prefs.getString('image');
}

class Historial_detallesAduana_upcoming_Screen extends StatefulWidget {
  const Historial_detallesAduana_upcoming_Screen({Key? key}) : super(key: key);

  @override
  _Historial_detallesAduana_upcoming_ScreenState createState() =>
      _Historial_detallesAduana_upcoming_ScreenState();
}

class _Historial_detallesAduana_upcoming_ScreenState extends State<Historial_detallesAduana_upcoming_Screen> {
  List<OrderData> orders = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData().then((result) {
      setState(() {
        orders = result;
      });
    });
  }

Future<List<OrderData>> fetchData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var orderid = prefs.getString('DucaId');

  
  final response = await http.get(
    Uri.parse('${apiUrl}Duca/DucaHistorial'),
    headers: {
      'XApiKey': apiKey,
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final decodedJson = jsonDecode(response.body);
    final dataList = decodedJson["data"] as List<dynamic>;

    final orders = dataList.map((data) {

       String fechavencimiento = data['duca_FechaVencimiento'];
    
        int indexOfT1 = fechavencimiento.indexOf('T');

        if (indexOfT1 >= 0) {
          fechavencimiento = fechavencimiento.substring(0, indexOfT1);
        }

      return OrderData(
        id: data['duca_Id'],
        duca_No_Duca: data['duca_No_Duca'],
        duca_No_Correlativo_Referencia: data['duca_No_Correlativo_Referencia'],
        nombre_Aduana_Registro: data['nombre_Aduana_Registro'],
        nombre_Aduana_Destino: data['nombre_Aduana_Destino'],
        nombre_pais_procedencia: data['nombre_pais_procedencia'],
        duca_Manifiesto: data['duca_Manifiesto'],
        duca_Titulo: data['duca_Titulo'],
        duca_FechaVencimiento: fechavencimiento,
      );
    }).toList();

    // Filtra los elementos con duca_Id igual a orderid
    final filteredOrders = orders.where((order) => order.id == int.parse(orderid)).toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'userData', jsonEncode(filteredOrders.map((order) => order.toJson()).toList()));

    return filteredOrders;
  } else {
    throw Exception('Failed to load data');
  }
}




  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Image(
          height: 35,
          image: NetworkImage('https://i.ibb.co/HgdBM0r/slogan.png'),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Add the back button icon here
          onPressed: () {
            Navigator.pop(context); // Navigate back when the button is pressed
          },
        ),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            //encabezado

            if (orders.isNotEmpty) buildEncabezado(orders[0]),
           

            //cards
            SizedBox(height: 16),
            
            devas_por_duca_upcoming(),
          ],
        ),
      ),
    );
  }


  Widget buildEncabezado(OrderData order) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              "Codigo de Duca #${order.duca_No_Duca}",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w200,
                color: Color.fromRGBO(148, 82, 249, 1),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: GridView.count(
            // shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            // mainAxisSpacing: 1,
            childAspectRatio: 3 / 1,
            children: [
              Text.rich(TextSpan(
                text: "Numero Correlativo:",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${order.duca_No_Correlativo_Referencia}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              )),
              Text.rich(TextSpan(
                text: "Pais Procedencia:",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${order.nombre_pais_procedencia}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              )),
              Text.rich(TextSpan(
                text: "Aduana Registro",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${order.nombre_Aduana_Registro }",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              )),
              Text.rich(TextSpan(
                text: "Aduana Destino",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${order.nombre_Aduana_Destino}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              )),
              Text.rich(TextSpan(
                text: "Regimen Aduanero:",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${"4000"}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              )),
              Text.rich(TextSpan(
                text: "Fecha Vencimiento:",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${order.duca_FechaVencimiento}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              )),
               Text.rich(TextSpan(
                text: "Manifiesto:",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${order.duca_Manifiesto}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              )),
               Text.rich(TextSpan(
                text: "Titulo:",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${order.duca_Titulo}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
      ],
    );
  }
}
