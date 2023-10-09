import 'dart:convert';

import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simexpro/screens/historial_screen.dart';
import 'package:simexpro/screens/home_screen.dart';
import 'package:simexpro/screens/login_screen.dart';
import 'package:simexpro/screens/ordertracking/potracking_screen.dart';
import 'package:simexpro/screens/profile_screen.dart';
import 'package:simexpro/screens/ordertracking/qrscanner_screen.dart';
import 'package:simexpro/screens/timeline_screen.dart';
import 'package:simexpro/toastconfig/toastconfig.dart';
import 'package:simexpro/widgets/detalleshistorial_widget.dart';
import 'package:simexpro/widgets/taps.dart';
import 'package:http/http.dart' as http;

import '../api.dart';
import '../widgets/detalleshistorialAduana_widget.dart';

class OrderData {
  final int id;
  final String codigo;
  final String fechaEmision;
  final String fechaLimite;
  final String fact_Numero;
  final String fact_Fecha;
  
  // final String estadoOrdenCompra;
  // final String nombreCliente;
  // final String direccionEntrega;
  // final String metodoPago;

  OrderData({
    required this.id,
    required this.codigo,
    required this.fechaEmision,
    required this.fechaLimite,
    required this.fact_Numero,
    required this.fact_Fecha,
    // required this.estadoOrdenCompra,
    // required this.nombreCliente,
    // required this.direccionEntrega,
    // required this.metodoPago,
  });

   Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codigo': codigo,
      'fechaEmision': fechaEmision,
      'fechaLimite': fechaLimite,
      'fact_Numero':fact_Numero,
      'fact_Fecha':fact_Fecha,
      // 'estadoOrdenCompra': estadoOrdenCompra,
      // 'nombreCliente': nombreCliente,
      // 'direccionEntrega': direccionEntrega,
      // 'metodoPago': metodoPago,
    };
  }
}


Future<void> Imagen() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  image = prefs.getString('image');
}

class Historial_detallesAduana_Screen extends StatefulWidget {
  


  const Historial_detallesAduana_Screen({Key? key}) : super(key: key);
     
  @override
  _Historial_detallesAduana_ScreenState createState() =>
      _Historial_detallesAduana_ScreenState();
}

class _Historial_detallesAduana_ScreenState extends State<Historial_detallesAduana_Screen> {
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
    var orderid = prefs.getString('orderid');
      print('Order ID: $orderid');
     final response = await http.get(
    Uri.parse('${apiUrl}Declaracion_Valor/ListarHistorial'),
    headers: {
      'XApiKey': apiKey,
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final decodedJson = jsonDecode(response.body);
    final dataList = decodedJson["data"] as List<dynamic>;
    
    print('Order ID2: $orderid');
    final orders = dataList
        .where((data) => data['deva_Id'].toString() ==orderid ) // Filtra por deva_id
        .map((data) {
          String fechaEmision = data['deva_FechaAceptacion'];
          String fechaLimite = data['deva_FechaAceptacion'];

          int indexOfT1 = fechaEmision.indexOf('T');
          int indexOfT2 = fechaLimite.indexOf('T');

          if (indexOfT1 >= 0) {
            fechaEmision = fechaEmision.substring(0, indexOfT1);
          }

          if (indexOfT2 >= 0) {
            fechaLimite = fechaLimite.substring(0, indexOfT2);
          }

          return OrderData(
            id: data['deva_Id'],
            codigo: data['deva_DeclaracionMercancia'],
            fact_Numero: data['fact_Numero'],
            fact_Fecha: data['fact_Fecha'],
            fechaEmision: fechaEmision,
            fechaLimite: fechaLimite,
          );
        })
        .toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', jsonEncode(orders.map((order) => order.toJson()).toList()));

    return orders;
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
            
            DetalleshistorialAduana(),
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
              "Numero de deva #${order.id}",
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
                text: "Numero de Deva:",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${order.id}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              )),
              Text.rich(TextSpan(
                text: "Estado Mercancia:",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${order.codigo}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              )),
              Text.rich(TextSpan(
                text: "Fecha de Emisión",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${order.fechaEmision}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              )),
              // Text.rich(TextSpan(
              //   text: "Fecha Limite",
              //   style: TextStyle(
              //     color: Colors.grey,
              //   ),
              //   children: <TextSpan>[
              //     TextSpan(
              //       text: "\n${order.fechaLimite}",
              //       style: TextStyle(
              //         color: Colors.black,
              //       ),
              //     )
              //   ],
              // )),
              // Text.rich(TextSpan(
              //   text: "Embalaje general:",
              //   style: TextStyle(
              //     color: Colors.grey,
              //   ),
              //   children: <TextSpan>[
              //     TextSpan(
              //       text: "\n${order.embalaje}",
              //       style: TextStyle(
              //         color: Colors.black,
              //       ),
              //     )
              //   ],
              // )),
              // Text.rich(TextSpan(
              //   text: "Dirección de entrega:",
              //   style: TextStyle(
              //     color: Colors.grey,
              //   ),
              //   children: <TextSpan>[
              //     TextSpan(
              //       text: "\n${order.direccionEntrega}",
              //       style: TextStyle(
              //         color: Colors.black,
              //       ),
              //     ),
              //   ],
              // )),
            ],
          ),
        ),
      ],
    );
  }
}
