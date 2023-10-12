import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:simexpro/api.dart';
import 'package:simexpro/screens/Historial_detallesAduana_concluded_Screen.dart';
import '../screens/historial_detallesAduana_screen.dart';


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

class ConcludedhistorialAduana extends StatefulWidget {
  @override
  _ConcludedhistorialAduanaState createState() => _ConcludedhistorialAduanaState();
}

class _ConcludedhistorialAduanaState extends State<ConcludedhistorialAduana> {
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
              order.id.toString().contains(searchText.toLowerCase()) ||
             order.boen_FechaEmision
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
                  "Boletin de Pago #${order.id}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text((order.boen_FechaEmision.substring(0, order.boen_FechaEmision.indexOf('T')))),
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
                        order.esbo_Descripcion,
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
                        order.copa_Descripcion,
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
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('BoletinId', order.id.toString());
             

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Historial_detallesAduana_concluded_Screen(),
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
