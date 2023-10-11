import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:simexpro/api.dart';
import 'package:simexpro/screens/historial_detalles_screen.dart';

class DetalleData {
  final int factId;
  final int devaId;
  final String factNumero;
  final String factFecha;

  DetalleData({
    required this.factId,
    required this.devaId,
    required this.factNumero,
    required this.factFecha,
  });

  Map<String, dynamic> toJson() {
    return {
      'factId': factId,
      'devaId': devaId,
      'factNumero': factNumero,
      'factFecha': factFecha,
    };
  }
}

class DetalleshistorialAduana extends StatefulWidget {
  @override
  _DetalleshistorialAduanaState createState() =>
      _DetalleshistorialAduanaState();
}

class _DetalleshistorialAduanaState extends State<DetalleshistorialAduana> {
  List<DetalleData> detalles = [];
  List<DetalleData> filtereddetalles = [];
  

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData().then((result) {
      setState(() {
        detalles = result;
        filtereddetalles = detalles;
      });
    });
  }

  Future<List<DetalleData>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var orderid = prefs.getString('orderid');

    final responsedetalles = await http.get(
      Uri.parse('${apiUrl}Declaracion_Valor/ListarFacturasByDeva?deva_Id=${orderid}'),
      headers: {
        'XApiKey': apiKey,
        'Content-Type': 'application/json',
      },
    );

    if (responsedetalles.statusCode == 200) {
      final decodedJson = jsonDecode(responsedetalles.body);
      final dataList = decodedJson["data"] as List<dynamic>;
       
       

      final ordersdetalles = dataList.map((data) {
        String codeFechaprocactual = data['fact_Fecha'];

         int indexOfT1 = codeFechaprocactual.indexOf('T');

         if (indexOfT1 >= 0) {
           codeFechaprocactual = codeFechaprocactual.substring(0, indexOfT1);
         }
             

        final detalle = DetalleData(
          factId: data['fact_Id'] ?? 0,
          devaId: data['deva_Id'] ?? 0,
          factNumero: data['fact_Numero'] ?? "",
          factFecha: codeFechaprocactual,
        );
      
         
        return detalle;
      }).toList();

      setState(() {
        detalles = ordersdetalles;
        filtereddetalles = detalles;
      });

      return detalles;
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
            itemCount:
                filtereddetalles.isNotEmpty ? filtereddetalles.length : 1,
            itemBuilder: (context, index) {
              if (filtereddetalles.isNotEmpty) {
              
                // Muestra la tarjeta de pedido si hay datos
                return buildCard(filtereddetalles[index]);
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
      filtereddetalles = detalles
          .where((detalle) =>
              detalle.factNumero.toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              detalle.factNumero.toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
          
    });
  }

  Widget buildCard(DetalleData detalle) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ExpansionTile(
          initiallyExpanded: false,
          title: ListTile(
            title: Text(
              "Detalle ID #${detalle.factId.toString()}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(detalle.factNumero.toString()),
          ),
          children: [
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  _buildDataRow("Factura ID:", detalle.factId.toString()),
                  _buildDataRow("Numero de factura:", detalle.factNumero.toString()),
                  _buildDataRow("Deva ID:", detalle.devaId.toString()),
                  _buildDataRow("Fecha Emision:", detalle.factFecha),
                
                ],
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
