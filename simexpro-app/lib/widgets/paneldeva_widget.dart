// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, dead_code

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:simexpro/api.dart';
import 'package:simexpro/screens/DEVA/devas_screen.dart';
import 'package:simexpro/screens/historial_detalles_screen.dart';
import 'package:simexpro/widgets/upcoming_historial.dart';

class DevaData {
  final int deva_Id;
  final String adua_IngresoNombre;
  final String adua_IngresoCodigo;
  


  DevaData({
    required this.deva_Id,
    required this.adua_IngresoNombre,
    required this.adua_IngresoCodigo,
   
  });

  Map<String, dynamic> toJson() {
    return {
      'deva_Id': deva_Id,
      'adua_IngresoNombre': adua_IngresoNombre,
      'adua_IngresoCodigo': adua_IngresoCodigo,
      

    };
  }
}

class AduaData {
  final int deva_Id;
  final String adua_DespachoNombre;
  final String adua_DespachoCodigo;
  


  AduaData({
    required this.deva_Id,
    required this.adua_DespachoNombre,
    required this.adua_DespachoCodigo,
   
  });

  Map<String, dynamic> toJson() {
    return {
      'deva_Id': deva_Id,
      'adua_DespachoNombre': adua_DespachoNombre,
      'adua_DespachoCodigo': adua_DespachoCodigo,      

    };
  }
}

class PanelDevaWidget extends StatefulWidget {
  @override
  _PanelDevaWidgetState createState() => _PanelDevaWidgetState();
}

class _PanelDevaWidgetState extends State<PanelDevaWidget> {
  List<DevaData> aduas = [];
  List<DevaData> filtrerAduas = [];

  List<AduaData> aduas2 = [];
  List<AduaData> filtrerAduas2 = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData().then((result) {
      setState(() {
        aduas = result;
        filtrerAduas = aduas;
      });
    });
  }    

  @override
  void initState2() {
    super.initState();
    fetchData2().then((result2) {
      setState(() {
        aduas2 = result2;
        filtrerAduas2 = aduas2;
      });
    });
  } 


  Future<List<DevaData>> fetchData() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var deva_Id = prefs.getInt('deva_Id');

    final response = await http.get(
      Uri.parse('${apiUrl}Declaracion_Valor/Listar_ByDevaId?id=${deva_Id}'),
      headers: {
        'XApiKey': apiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      final dataList = decodedJson["data"] as List<dynamic>;

      final aduas = dataList
          .map((data) {
 

        return DevaData(
          deva_Id: data['deva_Id'],
          adua_IngresoNombre: data['adua_IngresoNombre'],
          adua_IngresoCodigo: data['adua_IngresoCodigo'], );
      }).toList();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userData',
          jsonEncode(aduas.map((order) => order.toJson()).toList()));

      return aduas;
    } else {
      throw Exception('Failed to load data');
    }
  }


 Future<List<AduaData>> fetchData2() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var deva_Id = prefs.getInt('deva_Id');

    final response = await http.get(
      Uri.parse('${apiUrl}Declaracion_Valor/Listar_ByDevaId?id=${deva_Id}'),
      headers: {
        'XApiKey': apiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      final dataList = decodedJson["data"] as List<dynamic>;

      final aduas2 = dataList
          .map((data) {
 

        return AduaData(
          deva_Id: data['deva_Id'],
          adua_DespachoNombre: data['adua_DespachoNombre'],
          adua_DespachoCodigo: data['adua_DespachoCodigo'], );
      }).toList();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userData',
          jsonEncode(aduas2.map((order) => order.toJson()).toList()));
      print(aduas2);
      return aduas2;
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
            itemCount: filtrerAduas.isNotEmpty ? filtrerAduas.length : 1,
            itemBuilder: (context, index) {
             if (filtrerAduas.isNotEmpty ) {
                return buildCard(filtrerAduas[index]);
              } else {
                return Text(
                  'No se encontraron Aduanas',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                );
              }
            },       
          ),

            ListView.builder(
            shrinkWrap: true,
            itemCount: filtrerAduas2.isNotEmpty ? filtrerAduas2.length : 1,
            itemBuilder: (context, index) {
             if (filtrerAduas2.isNotEmpty ) {
                return buildCard2(filtrerAduas2[index]);
              } else {
                return Text(
                  'No se encontraron Aduanas de salida',
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
      filtrerAduas = aduas
          .where((order) =>
              order.deva_Id.toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
      filtrerAduas2 = aduas2
          .where((adu) =>
              adu.deva_Id.toString()
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
                  "Aduana-código #${deva.adua_IngresoCodigo}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(deva.adua_IngresoNombre.toString()),
                
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
                        deva.adua_IngresoCodigo,
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
                          color: Color.fromARGB(255, 14, 137, 25),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Aduana de Ingreso",
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
        )
        );
  }


   Widget buildCard2( AduaData adua) {
    return 
        Container(
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
                  "Aduana-código #${adua.adua_DespachoCodigo}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(adua.adua_DespachoNombre.toString()),
                
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
                        adua.adua_DespachoCodigo,
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
                        adua.adua_DespachoCodigo,
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
                          color: Color.fromARGB(255, 26, 87, 178),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Aduana de Salida",
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
        )
        );
  }
}
