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
  final int bode_Id;
  final String bode_Concepto;
  final String bode_TipoObligacion;
  final int bode_CuentaPA01;

  Detalles({
    required this.bode_Id,
    required this.bode_Concepto,
    required this.bode_TipoObligacion,
    required this.bode_CuentaPA01,


   
  });

  factory Detalles.fromJson(Map<String, dynamic> json) {
    return Detalles(
      bode_Id: json['bode_Id'],
      bode_Concepto: json['bode_Concepto'],
      bode_TipoObligacion: json['bode_TipoObligacion'],
      bode_CuentaPA01: json['bode_CuentaPA01'],


    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bode_Id': bode_Id,
      'bode_Concepto': bode_Concepto,
      'bode_TipoObligacion': bode_TipoObligacion,
      'bode_CuentaPA01': bode_CuentaPA01,


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
      return DetalleData2(
        id: data['boen_Id'],
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
              detalle.bode_Id.toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              detalle.bode_Concepto.toString()
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
              "Detalle #${detalles.bode_Id.toString()}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text( "Concepto: #${detalles.bode_Concepto.toString()}",),
            
          ),
          children: [
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                   _buildDataRow("Tipo Obligación:",detalles.bode_TipoObligacion.toString()),
                   _buildDataRow("Cuenta Pa:", detalles.bode_CuentaPA01.toString()),
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
