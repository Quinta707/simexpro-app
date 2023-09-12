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

class Grafica extends State<Cartas> {
  List<BarChartData> data = []; // Lista para almacenar los datos de la API
  List<Clietes> ClientesData=[];


  //PETICION PARA OPTENER LOS DATOS DE LA GRAFICA (MODULOS MAS EFICIENTES)
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
      }
    } catch (error) {
      throw Exception('Error: ${error}');
    }
  }

  //PETICION PARA OPTENER LOS DATOS DE LA GRAFICA (CLIENTES PRODUCIVOS)
  Future<void> clientesProdivos() async {
    try {
      final response = await http.get(
        Uri.parse('${apiUrl}Graficas/ClientesProductivos'),
        headers: {
          'XApiKey': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> jsonData = responseData['data'];

        setState(() {
          ClientesData = jsonData
              .map((item) => Clietes(item['clie_Nombre_O_Razon_Social'],item['cantidadIngresos']))
              .toList();
        });
      }
    } catch (error) {
      throw Exception('Error: ${error}');
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
        labelAccessorFn: (BarChartData data, _) => '${data.porcentaje}%',
        colorFn: (_, __) => charts.MaterialPalette.black,
        data: data, // Utiliza los datos de la API
      )
    ];

    // final List<charts.Series<Clietes, String>> listDataClientes = [
    //   charts.Series<Clietes, String>(
    //     id: 'pie',
    //     domainFn: (Clietes ClientesData, _) => ClientesData.cliente_Nombre,
    //     measureFn: ( BarChartDatadata, _) => data.totalProduccionDia,
    //     labelAccessorFn: (BarChartData data, _) => '${data.porcentaje}%',
    //     colorFn: (_, __) => charts.MaterialPalette.black,
    //     data: data, // Utiliza los datos de la API
    //   )
    // ];

    //GRAFICA DE BARRAS (MODULOS MAS PRODUCTIVOS)
    final chart = new charts.BarChart(
      seriesList,
      animate: true,
      vertical: true,
      domainAxis: new charts.OrdinalAxisSpec(
        renderSpec: new charts.SmallTickRendererSpec(
          labelStyle: new charts.TextStyleSpec(
            color: charts.MaterialPalette.black,
          ),
          labelRotation: 45,
        ),
      ),
      barRendererDecorator: charts.BarLabelDecorator<String>(
        labelAnchor: charts.BarLabelAnchor.end,
        insideLabelStyleSpec: const charts.TextStyleSpec(
          fontSize: 12, // Tamaño de letra de la etiqueta de porcentaje
          color: charts
              .Color.white, // Color de la letra de la etiqueta de porcentaje
        ),
        outsideLabelStyleSpec: charts.TextStyleSpec(
          fontSize: 12, // Tamaño de letra de la etiqueta de porcentaje
          color: charts
              .Color.black, // Color de la letra de la etiqueta de porcentaje
        ),
      ),
    );

    //GRAFICA PIE (CLIENTES MAS PRODUCTIVOS)
    final pieChart = charts.PieChart(
      seriesList,
      animate: true,
      behaviors: [
        new charts.DatumLegend(
          outsideJustification: charts.OutsideJustification.endDrawArea,
          horizontalFirst: false,
          desiredMaxRows: 2,
          cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
          entryTextStyle: charts.TextStyleSpec(
            color: charts.MaterialPalette.black,
            fontSize: 12,
          ),
        ),
      ],
      defaultRenderer: new charts.ArcRendererConfig(
        arcWidth: 100, // Ancho de los segmentos del gráfico de pastel
        arcRendererDecorators: [
          new charts.ArcLabelDecorator(
            labelPosition: charts.ArcLabelPosition.inside,
            insideLabelStyleSpec: charts.TextStyleSpec(
              color: charts.Color.white,
              fontSize: 12,
            ),
            outsideLabelStyleSpec: charts.TextStyleSpec(
              color: charts.Color.black,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfico de Barras desde API en Flutter'),
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    height:
                        500, // Establece una altura específica para la gráfica
                    child: chart,
                  ),
                ),
                const Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(
                      color: Colors.black,
                      thickness: 2,
                      height: 20,
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    height:
                        500, // Establece una altura específica para la gráfica
                    child: pieChart,
                  ),
                ),
                Text(
                  'Texto debajo del gráfico',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Puedes seguir agregando más widgets o filas según sea necesario
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BarChartData {
  final String modu_Nombre;
  final int totalProduccionDia;
  final String porcentaje;

  BarChartData(this.modu_Nombre, this.totalProduccionDia, this.porcentaje);
}

class Clietes {
  final String cliente_Nombre;
  final int Cantidad_Ingresos;

  Clietes(this.cliente_Nombre, this.Cantidad_Ingresos);
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
