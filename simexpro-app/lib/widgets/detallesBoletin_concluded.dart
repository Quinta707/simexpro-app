import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:simexpro/api.dart';
import 'package:simexpro/screens/historial_detalles_screen.dart';


class DetalleData2 {
  final int id;
  final String detalles;


  DetalleData2({
     required this.id,
     required this.detalles,
 
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'detalles': detalles,
    };
  }
}

class Detalles {
  final int boen_Id;
  final String bode_Concepto;




  Detalles({
    required this.boen_Id,
    required this.bode_Concepto,


   
  });

  factory Detalles.fromJson(Map<String, dynamic> json) {
    return Detalles(
      boen_Id: json['boen_Id'],
      bode_Concepto: json['bode_Concepto'],


    );
  }

  Map<String, dynamic> toJson() {
    return {
      'boen_Id': boen_Id,
      'bode_Concepto': bode_Concepto,


    };
  }
}




class detallesBoletin_concluded extends StatefulWidget {
  @override
  _detallesBoletin_concludedState createState() => _detallesBoletin_concludedState();
}

class _detallesBoletin_concludedState extends State<detallesBoletin_concluded> {



  List<Detalles> detalles = [];
  List<Detalles> filtereddetalles = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
       fetchData2().then((result) {
      setState(() {
        detalles = result;
        filtereddetalles = detalles;
        
      });
    });
  }

  
Future<List<Detalles>> fetchData2() async {
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
      return DetalleData2(
        id: data['duca_Id'],
        detalles: data['detalles'],
      );
    }).toList();

  
    final filteredOrders = orders.where((boletin) => boletin.id == int.parse(BoletinId)).toList();

    final detallesList = filteredOrders
        .map((order) => (jsonDecode(order.detalles) as List<dynamic>)
            .map((detalleData) => Detalles.fromJson(detalleData))
            .toList())
        .expand((element) => element)
        .toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', jsonEncode(detallesList.map((detalle) => detalle.toJson()).toList()));

          setState(() {
          detalles = detallesList;
          filtereddetalles = detalles;
      });
   
    return detallesList;
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
              detalle.boen_Id.toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              detalle.boen_Id.toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    });
  }

  Widget buildCard(Detalles detalles) {
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
              "Detalle #${detalles.boen_Id.toString()}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(detalles.bode_Concepto),
            
          ),
          children: [
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  // _buildDataRow("Aduana Ingreso:",detalles.adua_IngresoNombre.toString()),
                  // _buildDataRow("Aduana Despacho:", detalles.adua_DespachoNombre),
                  // _buildDataRow("Declaración Mercancias:", detalles.deva_DeclaracionMercancia.toString()),           
                  // _buildDataRow("Fecha Aceptación:", (detalles.deva_FechaAceptacion.substring(0, detalles.deva_FechaAceptacion.indexOf('T')))),
                  // _buildDataRow("Pago Efectuado:", (detalles.deva_PagoEfectuado == false ? "No" : "Si" )),
                  // _buildDataRow("Pais Exportado:",  detalles.pais_ExportacionNombre),                
                  // _buildDataRow("Fecha de Exportación:", detalles.deva_FechaExportacion),
                  // _buildDataRow("Regimen Aduanero:",  detalles.regi_Codigo),
                  // _buildDataRow("Lugar Embarque:", detalles.LugarEmbarque),
                  // _buildDataRow("Formas de Envio:", detalles.foen_Descripcion),
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
