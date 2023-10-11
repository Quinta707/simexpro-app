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
import 'package:simexpro/widgets/detallesBoletin_concluded.dart';
import 'package:simexpro/widgets/taps.dart';
import 'package:http/http.dart' as http;

import '../api.dart';

class OrderData {
  final int id;
  final String boen_FechaEmision;
 
  


  OrderData({
    required this.id,
    required this.boen_FechaEmision,

  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'boen_FechaEmision': boen_FechaEmision,

    };
  }
}


Future<void> Imagen() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  image = prefs.getString('image');
}

class Historial_detallesAduana_concluded_Screen extends StatefulWidget {
  const Historial_detallesAduana_concluded_Screen({Key? key}) : super(key: key);

  @override
  _Historial_detallesAduana_concluded_ScreenState createState() =>
      _Historial_detallesAduana_concluded_ScreenState();
}

class _Historial_detallesAduana_concluded_ScreenState extends State<Historial_detallesAduana_concluded_Screen> {
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
  var BoletinId = prefs.getString('BoletinId');

  
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

       String fechaemision = data['boen_FechaEmision'];
    
        int indexOfT1 = fechaemision.indexOf('T');
flutter doctor
        if (indexOfT1 >= 0) {
          fechaemision = fechaemision.substring(0, indexOfT1);
        }

      return OrderData(
        id: data['boen_Id'],
        boen_FechaEmision: fechaemision,
       
      );
    }).toList();

    // Filtra los elementos con duca_Id igual a orderid
    final filteredOrders = orders.where((order) => order.id == int.parse(BoletinId)).toList();

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
            
            detallesBoletin_concluded(),
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
              "Boletin de Pago #${order.id}",
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
                text: "Fecha Emisión:",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${order.boen_FechaEmision}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              )),
              Text.rich(TextSpan(
                text: "RTN:",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${"order.RTN"}",
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
                    text: "\n${"order.fechaEmision"}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              )),
              Text.rich(TextSpan(
                text: "Fecha Limite",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${"order.fechaLimite"}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              )),
              Text.rich(TextSpan(
                text: "Embalaje general:",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${"order.embalaje"}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              )),
              Text.rich(TextSpan(
                text: "Dirección de entrega:",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${"order.direccionEntrega"}",
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
