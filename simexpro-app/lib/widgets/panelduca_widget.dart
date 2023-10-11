import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:simexpro/api.dart';
import 'package:simexpro/screens/DUCA/duca_screen.dart';
import 'package:simexpro/screens/historial_detalles_screen.dart';
import 'package:simexpro/widgets/upcoming_historial.dart';

class DevaData {
  final int deva_Id;
  final String adua_IngresoNombre;
  final String deva_DeclaracionMercancia;
  final String deva_FechaAceptacion;
  final String regi_Codigo;
  final String regi_Descripcion;
  final String impo_NumRegistro;
  final String nico_Descripcion;
  final String impo_NivelComercial_Otro;
  final String impo_Nombre_Raso;
  final String impo_Direccion_Exacta;
  final String impo_Correo_Electronico;
  final String impo_Telefono;
  final String prov_Nombre_Raso;
  final String prov_Direccion_Exacta;
  final String prov_Correo_Electronico;
  final String prov_Telefono;
  final String orco_DireccionEntrega;
  final String deva_NumeroContrato;


  DevaData({
    required this.deva_Id,
    required this.adua_IngresoNombre,
    required this.deva_DeclaracionMercancia,
    required this.deva_FechaAceptacion,
    required this.regi_Codigo,
    required this.regi_Descripcion,
    required this.impo_NumRegistro,
    required this.nico_Descripcion,
    required this.impo_NivelComercial_Otro,
    required this.impo_Nombre_Raso,
    required this.impo_Direccion_Exacta,
    required this.impo_Correo_Electronico,
    required this.impo_Telefono,
    required this.prov_Nombre_Raso,
    required this.prov_Direccion_Exacta,
    required this.prov_Correo_Electronico,
    required this.prov_Telefono,
    required this.orco_DireccionEntrega,
    required this.deva_NumeroContrato,

  });

  Map<String, dynamic> toJson() {
    return {
      'deva_Id': deva_Id,
      'adua_IngresoNombre': adua_IngresoNombre,
      'deva_DeclaracionMercancia': deva_DeclaracionMercancia,
      'deva_FechaAceptacion': deva_FechaAceptacion,
      'regi_Codigo': regi_Codigo,
      'regi_Descripcion': regi_Descripcion,
      'impo_NumRegistro': impo_NumRegistro,
      'nico_Descripcion': nico_Descripcion,
      'impo_NivelComercial_Otro': impo_NivelComercial_Otro,
      'impo_Nombre_Raso': impo_Nombre_Raso,
      'impo_Direccion_Exacta': impo_Direccion_Exacta,
      'impo_Correo_Electronico': impo_Correo_Electronico,
      'impo_Telefono': impo_Telefono,
      'prov_Nombre_Raso': prov_Nombre_Raso,
      'prov_Direccion_Exacta': prov_Direccion_Exacta,
      'prov_Correo_Electronico': prov_Correo_Electronico,
      'prov_Telefono': prov_Telefono,
      'deva_NumeroContrato': deva_NumeroContrato,

    };
  }
}

class PanelDucaWidget extends StatefulWidget {
  @override
  _PanelDucaWidgetState createState() => _PanelDucaWidgetState();
}

class _PanelDucaWidgetState extends State<PanelDucaWidget> {
  List<DevaData> devas = [];
  List<DevaData> filteredDevas = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData().then((result) {
      setState(() {
        devas = result;
        filteredDevas = devas;
      });
    });
  }    

  Future<List<DevaData>> fetchData() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var duca_Id = prefs.getInt('duca_Id');

    final response = await http.get(
      Uri.parse('${apiUrl}Declaracion_Valor/Listar_ByDucaId?id=${duca_Id}'),
      headers: {
        'XApiKey': apiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      final dataList = decodedJson["data"] as List<dynamic>;

      final devas = dataList
          .map((data) {
        String deva_FechaAceptacion = data['deva_FechaAceptacion'];

        int indexOfT1 = deva_FechaAceptacion.indexOf('T');

        if (indexOfT1 >= 0) {
          deva_FechaAceptacion = deva_FechaAceptacion.substring(0, indexOfT1);
        }

        return DevaData(
          deva_Id: data['deva_Id'],
          adua_IngresoNombre: data['adua_IngresoNombre'],
          deva_FechaAceptacion: deva_FechaAceptacion,
          deva_DeclaracionMercancia: data['deva_DeclaracionMercancia'],
          regi_Codigo: data['regi_Codigo'],
          regi_Descripcion: data['regi_Descripcion'],
          impo_NumRegistro: data['impo_NumRegistro'],
          nico_Descripcion: data['nico_Descripcion'],
          impo_NivelComercial_Otro: data['impo_NivelComercial_Otro'],
          impo_Nombre_Raso: data['impo_Nombre_Raso'],
          impo_Direccion_Exacta: data['impo_Direccion_Exacta'],
          impo_Correo_Electronico: data['impo_Correo_Electronico'],
          orco_DireccionEntrega: data['orco_DireccionEntrega'],
          impo_Telefono: data['impo_Telefono'],
          prov_Nombre_Raso: data['prov_Nombre_Raso'],
          prov_Direccion_Exacta: data['prov_Direccion_Exacta'],
          prov_Correo_Electronico: data['prov_Correo_Electronico'],
          prov_Telefono: data['prov_Telefono'],
          deva_NumeroContrato: data['deva_NumeroContrato'],

        );
      }).toList();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userData',
          jsonEncode(devas.map((order) => order.toJson()).toList()));

      return devas;
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
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: TextField(
              controller: searchController,
              onChanged: onSearchTextChanged,
              decoration: InputDecoration(
                hintText: 'Buscar',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            itemCount: filteredDevas.isNotEmpty ? filteredDevas.length : 1,
            itemBuilder: (context, index) {
              if (filteredDevas.isNotEmpty) {
                return buildCard(filteredDevas[index]);
              } else {
                return Text(
                  'No se encontraron Devas',
                  style: TextStyle(
                    color: Colors.black54,
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
      filteredDevas = devas
          .where((order) =>
              order.deva_NumeroContrato
                  .toLowerCase().contains(searchText.toLowerCase()) ||
              order.deva_Id.toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    });
  }

  Widget buildCard(DevaData deva) {
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
                  "DEVA #${deva.deva_Id}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(deva.deva_NumeroContrato),
                
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
                        deva.deva_NumeroContrato,
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
                        deva.deva_NumeroContrato,
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
