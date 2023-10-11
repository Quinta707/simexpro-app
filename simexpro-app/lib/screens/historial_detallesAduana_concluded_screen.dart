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

  final int duca_No_Duca;
  final String tipl_Descripcion;
  final String esbo_Descripcion;
  final String boen_Observaciones;
  final String boen_NDeclaracion;
  final String boen_Preimpreso;
  final int boen_TotalPagar;
  final int boen_TotalGarantizar;
  final String coim_Descripcion;
  final String copa_Descripcion;
  
 
  


  OrderData({
    required this.id,
    required this.boen_FechaEmision,

    required this.duca_No_Duca,
    required this.tipl_Descripcion,
    required this.esbo_Descripcion,
    required this.boen_Observaciones,
    required this.boen_NDeclaracion,
    required this.boen_Preimpreso,
    required this.boen_TotalPagar,
    required this.boen_TotalGarantizar,
    required this.coim_Descripcion,
    required this.copa_Descripcion,

  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'boen_FechaEmision': boen_FechaEmision,

      'duca_No_Duca': duca_No_Duca,
      'tipl_Descripcion': tipl_Descripcion,
      'esbo_Descripcion': esbo_Descripcion,
      'boen_Observaciones': boen_Observaciones,
      'boen_NDeclaracion': boen_NDeclaracion,
      'boen_Preimpreso': boen_Preimpreso,
      'boen_TotalPagar': boen_TotalPagar,
      'boen_TotalGarantizar': boen_TotalGarantizar,
      'coim_Descripcion': coim_Descripcion,
      'copa_Descripcion': copa_Descripcion,
     

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
    Uri.parse('${apiUrl}BoletinPago/ListarHistorial'),
    headers: {
      'XApiKey': apiKey,
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final decodedJson = jsonDecode(response.body);
    final dataList = decodedJson["data"] as List<dynamic>;

    final orders = dataList.map((data) {

     

      return OrderData(
          id: data['boen_Id'],
        boen_FechaEmision: data['boen_FechaEmision'],

        duca_No_Duca: data['duca_No_Duca'],
        tipl_Descripcion: data['tipl_Descripcion'],
        esbo_Descripcion: data['esbo_Descripcion'],
        boen_Observaciones: data['boen_Observaciones'],
        boen_NDeclaracion: data['boen_NDeclaracion'],
        boen_Preimpreso: data['boen_Preimpreso'],
        boen_TotalPagar: data['boen_TotalPagar'],
        boen_TotalGarantizar: data['boen_TotalGarantizar'],
        coim_Descripcion: data['coim_Descripcion'],
        copa_Descripcion: data['copa_Descripcion'],
       
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
                    text: "\n${(order.boen_FechaEmision.substring(0, order.boen_FechaEmision.indexOf('T')))}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              )),
              Text.rich(TextSpan(
                text: "Numero Duca:",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${order.duca_No_Duca}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              )),
              Text.rich(TextSpan(
                text: "Tipo Liquidación",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${order.tipl_Descripcion}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              )),
              Text.rich(TextSpan(
                text: "Estado Boletin",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${order.esbo_Descripcion}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              )),
              Text.rich(TextSpan(
                text: "Concepto de Pago:",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${order.coim_Descripcion}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              )),
              Text.rich(TextSpan(
                text: "Codigo Impuesto:",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${order.copa_Descripcion}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              )),
               Text.rich(TextSpan(
                text: "Total Garantizar:",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${order.boen_TotalGarantizar}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              )),
               Text.rich(TextSpan(
                text: "Total a Pagar:",
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${order.boen_TotalPagar}",
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
