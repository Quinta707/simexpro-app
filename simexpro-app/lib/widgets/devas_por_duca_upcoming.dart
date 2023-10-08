import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:simexpro/api.dart';
import 'package:simexpro/screens/historial_detalles_screen.dart';


class DetalleData2 {
  final int id;
  final String devas;


  DetalleData2({
     required this.id,
    required this.devas,
 
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'devas': devas,
    };
  }
}

class Devas {
  final int deva_Id;
  final String adua_IngresoNombre;
  final String adua_DespachoNombre;
  final String deva_DeclaracionMercancia;
  final String deva_FechaAceptacion;
  final bool   deva_PagoEfectuado;
  final String   pais_ExportacionNombre;
  final String   deva_FechaExportacion;
  final String      regi_Codigo;
  final String   LugarEmbarque;
  final String   foen_Descripcion;


  final bool   deva_Finalizacion;



  Devas({
    required this.deva_Id,
    required this.adua_IngresoNombre,
    required this.adua_DespachoNombre,
    required this.deva_DeclaracionMercancia,
    required this.deva_FechaAceptacion,
    required this.deva_PagoEfectuado,
    required this.pais_ExportacionNombre,
    required this.deva_FechaExportacion,
    required this.regi_Codigo,
    required this.LugarEmbarque,
    required this.foen_Descripcion,

    required this.deva_Finalizacion,

   
  });

  factory Devas.fromJson(Map<String, dynamic> json) {
    return Devas(
      deva_Id: json['deva_Id'],
      adua_IngresoNombre: json['adua_IngresoNombre'],
      adua_DespachoNombre: json['adua_DespachoNombre'],
      deva_DeclaracionMercancia: json['deva_DeclaracionMercancia'],
      deva_FechaAceptacion: json['deva_FechaAceptacion'],
      deva_PagoEfectuado: json['deva_PagoEfectuado'],
      pais_ExportacionNombre: json['pais_ExportacionNombre'],
      deva_FechaExportacion: json['deva_FechaExportacion'],
      regi_Codigo: json['regi_Codigo'],
      LugarEmbarque: json['LugarEmbarque'],
      foen_Descripcion: json['foen_Descripcion'],

      deva_Finalizacion: json['deva_Finalizacion'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deva_Id': deva_Id,
      'adua_IngresoNombre': adua_IngresoNombre,
      'adua_DespachoNombre': adua_DespachoNombre,
      'deva_DeclaracionMercancia': deva_DeclaracionMercancia,
      'deva_FechaAceptacion': deva_FechaAceptacion,
      'deva_PagoEfectuado': deva_PagoEfectuado,
      'pais_ExportacionNombre': pais_ExportacionNombre,
      'deva_FechaExportacion': deva_FechaExportacion,
      'regi_Codigo': regi_Codigo,
      'LugarEmbarque': LugarEmbarque,
      'foen_Descripcion': foen_Descripcion,

      'deva_Finalizacion': deva_Finalizacion,

    };
  }
}




class devas_por_duca_upcoming extends StatefulWidget {
  @override
  _devas_por_duca_upcomingState createState() => _devas_por_duca_upcomingState();
}

class _devas_por_duca_upcomingState extends State<devas_por_duca_upcoming> {



  List<Devas> devas = [];
  List<Devas> filtereddetalles = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    

       fetchData2().then((result) {
      setState(() {
        devas = result;
        filtereddetalles = devas;
        
      });
    });
  }

  



Future<List<Devas>> fetchData2() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var orderid = prefs.getString('DucaId');

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
        devas: data['devas'],
      );
    }).toList();

    // Filtra los elementos con duca_Id igual a orderid
    final filteredOrders = orders.where((order) => order.id == int.parse(orderid)).toList();

print(filteredOrders);
    // Extrae el contenido de 'devas' y almacénalo en una lista de objetos Deva
    final devasList = filteredOrders
        .map((order) => (jsonDecode(order.devas) as List<dynamic>)
            .map((devaData) => Devas.fromJson(devaData))
            .toList())
        .expand((element) => element)
        .toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', jsonEncode(devasList.map((deva) => deva.toJson()).toList()));

          setState(() {
          devas = devasList;
          filtereddetalles = devas;
      });
   
    return devasList;
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
      filtereddetalles = devas
          .where((detalle) =>
              detalle.deva_Id.toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              detalle.deva_Id.toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    });
  }

  Widget buildCard(Devas devas) {
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
              "Declaración de Valor #${devas.deva_Id.toString()}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(devas.deva_Finalizacion == true ? "Finalizada": "No Finalizada"),
            
          ),
          children: [
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  _buildDataRow("Aduana Ingreso:",devas.adua_IngresoNombre.toString()),
                  _buildDataRow("Aduana Despacho:", devas.adua_DespachoNombre),
                  _buildDataRow("Declaración Mercancias:", devas.deva_DeclaracionMercancia.toString()),           
                  _buildDataRow("Fecha Aceptación:", (devas.deva_FechaAceptacion.substring(0, devas.deva_FechaAceptacion.indexOf('T')))),
                  _buildDataRow("Pago Efectuado:", (devas.deva_PagoEfectuado == false ? "No" : "Si" )),
                  _buildDataRow("Pais Exportado:",  devas.pais_ExportacionNombre),                
                  _buildDataRow("Fecha de Exportación:", devas.deva_FechaExportacion),
                  _buildDataRow("Regimen Aduanero:",  devas.regi_Codigo),
                  _buildDataRow("Lugar Embarque:", devas.LugarEmbarque),
                  _buildDataRow("Formas de Envio:", devas.foen_Descripcion),
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
