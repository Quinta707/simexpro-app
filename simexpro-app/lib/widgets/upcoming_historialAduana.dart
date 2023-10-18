import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:simexpro/api.dart';
import 'package:simexpro/screens/Historial_detallesAduana_upcoming_Screen.dart';

import '../screens/historial_detallesAduana_screen.dart';

class OrderData {
  final int id;
  final String duca_No_Duca;
  final String duca_No_Correlativo_Referencia;
  final String nombre_Aduana_Registro;
  final String nombre_Aduana_Destino;
   

  OrderData({
    required this.id,
    required this.duca_No_Duca,
    required this.duca_No_Correlativo_Referencia,
    required this.nombre_Aduana_Registro,
    required this.nombre_Aduana_Destino,
 
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'duca_No_Duca': duca_No_Duca,
      'duca_No_Correlativo_Referencia': duca_No_Correlativo_Referencia,
      'nombre_Aduana_Registro': nombre_Aduana_Registro,
      'nombre_Aduana_Destino': nombre_Aduana_Destino,
      
    };
  }
}

class UpcominghistorialAduana extends StatefulWidget {
  @override
  _UpcominghistorialAduanaState createState() => _UpcominghistorialAduanaState();
}

class _UpcominghistorialAduanaState extends State<UpcominghistorialAduana> {
  List<OrderData> orders = [];
  List<OrderData> filteredOrders = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData().then((result) {
      setState(() {
        orders = result;
        filteredOrders = orders;
      });
    });
  }

  Future<List<OrderData>> fetchData() async {
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
      return OrderData(
        id: data['duca_Id'],
        duca_No_Duca: data['duca_No_Duca'],
        duca_No_Correlativo_Referencia: data['duca_No_Correlativo_Referencia'],
        nombre_Aduana_Registro: data['nombre_Aduana_Registro'],
        nombre_Aduana_Destino: data['nombre_Aduana_Destino'],
      

      );
    }).toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'userData', jsonEncode(orders.map((order) => order.toJson()).toList()));


    return orders;
    
  } else {
    
    throw Exception('Failed to load data');
  }
}


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: TextField(
              controller: searchController,
              onChanged: onSearchTextChanged,
              decoration: InputDecoration(
                hintText: 'Buscar',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: filteredOrders.isNotEmpty ? filteredOrders.length : 1,
            itemBuilder: (context, index) {
              if (filteredOrders.isNotEmpty) {
                // Muestra la tarjeta de pedido si hay datos
                return buildCard(filteredOrders[index]);
              } else {
                // Muestra la imagen predeterminada con el tamaño deseado
                return Center(
                  child: Image.network(
                    "https://i.ibb.co/9sgcf39/image.png",
                    fit: BoxFit.contain,
                    width: 400,
                    height: 400,
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }

  void onSearchTextChanged(String searchText) {
    setState(() {
      filteredOrders = orders
          .where((order) =>
              order.duca_No_Duca.toLowerCase().contains(searchText.toLowerCase()) ||
              order.duca_No_Correlativo_Referencia
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    });
  }

  Widget buildCard(OrderData order) {
    return Container(
        margin: EdgeInsets.only(bottom: 16.0),
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              ListTile(
                title: Text(
                  "Duca #${order.id}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(order.duca_No_Duca),
                trailing: SizedBox(
                  width: 100,
                  height: 25,
                  child: Image.network(
                    "https://i.ibb.co/GVHnGxg/encurso.png",
                    fit: BoxFit
                        .contain, // Ajusta la imagen para que cubra el espacio
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  // color: Colors.black,
                  thickness: 1,
                  height: 20,
                ),
              ),
             Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    Expanded(
      flex: 1,
      child: Row(
        children: [
          Icon(
            Icons.add_location_alt,
            color: Colors.black54,
          ),
          SizedBox(width: 5),
          Expanded(
            child: Text(
              order.nombre_Aduana_Registro,
              style: TextStyle(
                color: Colors.black54,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
    Expanded(
      flex: 1,
      child: Row(
        children: [
          Icon(
            Icons.add_location_alt,
            color: Colors.black54,
          ),
          SizedBox(width: 5),
          Expanded(
            child: Text(
              order.nombre_Aduana_Destino ?? 'No Asignado',
              style: TextStyle(
                color: Colors.black54,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
    Expanded(
      flex: 1,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.yellow,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: Text(
              "En Curso",
              style: TextStyle(
                color: Colors.black54,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  ],
),

              
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('DucaId', order.id.toString());
             

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Historial_detallesAduana_upcoming_Screen(),
                        ),
                      );
                    },
                    child: Container(
                      width: 150,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(87, 69, 223, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Ver detalles",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
            ],
          ),
        ));
  }
}
