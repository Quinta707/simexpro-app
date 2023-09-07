import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:simexpro/api.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class Cartas extends StatefulWidget {
  const Cartas({Key? key}) : super(key: key);
  @override
  //CardExamplesApp createState() => CardExamplesApp();
  Grafica createState() => Grafica();
}

class BarChartData {
  final String modu_Nombre;
  final int totalProduccionDia;
  final String porcentaje;

  BarChartData(this.modu_Nombre, this.totalProduccionDia, this.porcentaje);
}

class Grafica extends State<Cartas> {
  List<BarChartData> data = []; // Lista para almacenar los datos de la API

  Future<void> fetchDataFromAPI() async {
    try {
      final response = await http.get(
        Uri.parse('${apiUrl}Graficas/ProductividadModulos'),
        headers: {
          'XApiKey': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> jsonData = responseData['data'];

        setState(() {
          data = jsonData
              .map((item) => BarChartData(item['modu_Nombre'],
                  item['totalProduccionDia'], item['porcentajeProduccion']))
              .toList();
        });
        print(data);
      } else {
        throw Exception('Error al cargar los datos desde la API');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI(); // Llama a la función para cargar los datos desde la API
  }

  @override
  Widget build(BuildContext context) {
    final List<charts.Series<BarChartData, String>> seriesList = [
      charts.Series<BarChartData, String>(
          id: 'Barras',
          domainFn: (BarChartData data, _) => data.modu_Nombre,
          measureFn: (BarChartData data, _) => data.totalProduccionDia,
          data: data, // Utiliza los datos de la API
          labelAccessorFn: (BarChartData data, _) =>
            '${data.porcentaje}%', )
    ];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Gráfico de Barras desde API en Flutter'),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: charts.BarChart(
              seriesList,
              animate: true,
              vertical: true,
              domainAxis: charts.OrdinalAxisSpec(
                renderSpec: charts.SmallTickRendererSpec(
                    labelRotation: 45), // Rota las etiquetas del eje X
              ),
              
            ),
          ),
        ),
      ),
    );
  }
}

class CardExamplesApp extends State<Cartas> {
  var Conteo = 0;
  var ConteoMes = 0;
  var Mes = "";

  List<dynamic> data = [];
  List<dynamic> dataMes = [];

  Future<void> OrdenesAnio() async {
    try {
      final response = await http.get(
        Uri.parse('${apiUrl}Graficas/TotalOrdenesCompraAnual'),
        headers: {
          'XApiKey': apiKey,
        },
      );
      final jsonBody = json.decode(response.body);
      final data = jsonBody['data'];

      setState(() {
        Conteo = data[0]['orco_Conteo'];
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> OrdenesMes() async {
    try {
      final response = await http.get(
        Uri.parse('${apiUrl}Graficas/TotalOrdenesCompraMensual'),
        headers: {
          'XApiKey': apiKey,
        },
      );
      final jsonBody = json.decode(response.body);
      final dataMes = jsonBody['data'];

      setState(() {
        ConteoMes = dataMes[0]['orco_Conteo'];
        Mes = dataMes[0]['mesLabel'];
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    OrdenesAnio();
    OrdenesMes();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Container(
            width: 300,
            height: 100,
            padding: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: Color.fromRGBO(86, 101, 115, 1.0),
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
                  const ListTile(
                    title: Text(
                      "ÓRDENES COMPLETADAS EN EL AÑO",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.white),
                    ),
                    // trailing: CircleAvatar(
                    //   radius: 25,
                    //   backgroundImage: NetworkImage(
                    //       "https://i.ibb.co/BnHMGJn/TERMINADO.png"),
                    // ),
                  ),
                  const Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                      height: 20,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            alignment: Alignment.bottomRight,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            Conteo == 1
                                ? ' ${Conteo} Órden Completada en ${DateTime.now().year}'
                                : '${Conteo} Órdenes Completadas en ${DateTime.now().year}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15),
          Container(
            width: 300,
            height: 100,
            padding: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: Color.fromRGBO(86, 101, 115, 1.0),
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
                  const ListTile(
                    title: Text(
                      "ÓRDENES COMPLETADAS EN EL MES",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.white),
                    ),
                    // trailing: CircleAvatar(
                    //   radius: 25,
                    //   backgroundImage: NetworkImage(
                    //       "https://i.ibb.co/BnHMGJn/TERMINADO.png"),
                    // ),
                  ),
                  const Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                      height: 20,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            alignment: Alignment.bottomRight,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            ConteoMes == 1
                                ? ' ${ConteoMes} Órden Completada en ${Mes}'
                                : '${ConteoMes} Órdenes Completadas en ${Mes}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
