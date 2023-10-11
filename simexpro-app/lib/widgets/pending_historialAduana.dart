import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:simexpro/api.dart';
import 'package:simexpro/screens/historial_detalles_screen.dart';
import 'package:simexpro/widgets/upcoming_historial.dart';

import '../screens/historial_detallesAduana_screen.dart';

class OrderData {
  final int id;
  final String codigo;
  final String fechaEmision;
  final String fechaLimite;
  // final String estadoOrdenCompra;
  // final String nombreCliente;
  // final String direccionEntrega;
  // final String metodoPago;

  OrderData(
      {required this.id,
      required this.codigo,
      required this.fechaEmision,
      required this.fechaLimite
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
      // 'estadoOrdenCompra': estadoOrdenCompra,
      // 'nombreCliente': nombreCliente,
      // 'direccionEntrega': direccionEntrega,
      // 'metodoPago': metodoPago,
    };
  }
}

class PendinghistorialAduana extends StatefulWidget {
  @override
  _PendinghistorialAduanaState createState() => _PendinghistorialAduanaState();
}

class _PendinghistorialAduanaState extends State<PendinghistorialAduana> {
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
      Uri.parse('${apiUrl}Declaracion_Valor/ListarHistorial'),
      headers: {
        'XApiKey': apiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      final dataList = decodedJson["data"] as List<dynamic>;

      final orders = dataList
          // .where((data) => data['orco_EstadoOrdenCompra'] == 'P')
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
          fechaEmision: fechaEmision,
          fechaLimite: fechaLimite,
          // estadoOrdenCompra: data['orco_EstadoOrdenCompra'],
          // nombreCliente: data['clie_Nombre_O_Razon_Social'],
          // direccionEntrega: data['orco_DireccionEntrega'],
          // metodoPago: data['fopa_Descripcion'],
        );
      }).toList();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userData',
          jsonEncode(orders.map((order) => order.toJson()).toList()));

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
            shrinkWrap: true,
            itemCount: filteredOrders.isNotEmpty ? filteredOrders.length : 1,
            itemBuilder: (context, index) {
              if (filteredOrders.isNotEmpty) {
                return buildCard(filteredOrders[index]);
              } else {
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
              order.codigo.toLowerCase().contains(searchText.toLowerCase()) ||
              order.fechaEmision
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
                  "Deva #${order.id}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(order.codigo),
                trailing: SizedBox(
                  width: 100,
                  height: 25,
                  child: Image.network(
                    "https://i.ibb.co/9T4ST2V/pendiente.png",
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
                  Row(
                    children: [
                      Icon(
                        Icons.add_box,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 5),
                      Text(
                        order.codigo,
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 5),
                      Text(
                        order.fechaLimite,
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Pendiente",
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
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
                      prefs.setString('ordercodigo', order.codigo);
                      prefs.setString('orderid', order.id.toString());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Historial_detallesAduana_Screen(),
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
