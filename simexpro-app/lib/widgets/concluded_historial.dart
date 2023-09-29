import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:simexpro/api.dart';

class OrderData {
  final int id;
  final String codigo;
  final String fechaEmision;
  final String fechaLimite;
  final String estadoOrdenCompra;
  final String nombreCliente;
  final String direccionEntrega;
  final String metodoPago;

  OrderData({
    required this.id,
    required this.codigo,
    required this.fechaEmision,
    required this.fechaLimite,
    required this.estadoOrdenCompra,
    required this.nombreCliente,
    required this.direccionEntrega,
    required this.metodoPago,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codigo': codigo,
      'fechaEmision': fechaEmision,
      'fechaLimite': fechaLimite,
      'estadoOrdenCompra': estadoOrdenCompra,
      'nombreCliente': nombreCliente,
      'direccionEntrega': direccionEntrega,
      'metodoPago': metodoPago,
    };
  }
}

class Concludedhistorial extends StatefulWidget {
  @override
  _ConcludedhistorialState createState() => _ConcludedhistorialState();
}

class _ConcludedhistorialState extends State<Concludedhistorial> {
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
      Uri.parse('${apiUrl}OrdenCompra/Listar'),
      headers: {
        'XApiKey': apiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      final dataList = decodedJson["data"] as List<dynamic>;

      final orders = dataList
          .where((data) => data['orco_EstadoOrdenCompra'] == 'T')
          .map((data) {
        String fechaEmision = data['orco_FechaEmision'];
        String fechaLimite = data['orco_FechaLimite'];

        int indexOfT1 = fechaEmision.indexOf('T');
        int indexOfT2 = fechaLimite.indexOf('T');

        if (indexOfT1 >= 0) {
          fechaEmision = fechaEmision.substring(0, indexOfT1);
        }

        if (indexOfT2 >= 0) {
          fechaLimite = fechaLimite.substring(0, indexOfT2);
        }

        return OrderData(
          id: data['orco_Id'],
          codigo: data['orco_Codigo'],
          fechaEmision: fechaEmision,
          fechaLimite: fechaLimite,
          estadoOrdenCompra: data['orco_EstadoOrdenCompra'],
          nombreCliente: data['clie_Nombre_O_Razon_Social'],
          direccionEntrega: data['orco_DireccionEntrega'],
          metodoPago: data['fopa_Descripcion'],
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
              order.codigo.toLowerCase().contains(searchText.toLowerCase()) ||
              order.nombreCliente
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
                  "Orden #${order.codigo}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(order.nombreCliente),
                trailing: SizedBox(
                  width: 100,
                  height: 25,
                  child: Image.network(
                    "https://i.ibb.co/7GtzvVv/completada.png",
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
                        Icons.calendar_month_outlined,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 5),
                      Text(
                        order.fechaEmision,
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
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Completada",
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
                    onTap: () {},
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
