import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simexpro/screens/home_screen.dart';
import 'package:simexpro/screens/historial_screen.dart';
import 'package:simexpro/screens/login_screen.dart';
import 'package:simexpro/screens/profile_screen.dart';
import 'package:simexpro/screens/settings_screen.dart';
import 'package:simexpro/widgets/OrdenesProduccion.dart';
import 'package:simexpro/screens/timeline_screen.dart';

import 'package:http/http.dart' as http;
import 'package:simexpro/api.dart';

import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';

enum MenuItem { item1, item2 }

class Graficas extends StatefulWidget {
  @override
  State<Graficas> createState() => TabBarDemo();
}

Future<void> Imagen() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //imagen = prefs.getString('image');
}

// Función para generar un color aleatorio
charts.Color getRandomColor() {
  final random = Random();
  final r = random.nextInt(256);
  final g = random.nextInt(256);
  final b = random.nextInt(256);
  return charts.Color(r: r, g: g, b: b, a: 255);
}

class TabBarDemo extends State<Graficas> {
  List<BarChartData> data = [];

  //TRAER DATOS DE LA GRAFICA DE BARRAS
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

  //LLMMAR  A LAS FUNCIONES QUE HACEN LAS PETICIONES A LA API
  void initState() {
    super.initState();
    fetchDataFromAPI();
    Imagen();
  }

  @override
  Widget build(BuildContext context) {
    
    //ASIGNACION DEL GRAFICO DE BARRAS (MODULOS MAS PRODUCTIVOS)
    final List<charts.Series<BarChartData, String>> seriesList = [
      charts.Series<BarChartData, String>(
        id: 'Barras',
        domainFn: (BarChartData data, _) => data.modu_Nombre,
        measureFn: (BarChartData data, _) => data.totalProduccionDia,
        labelAccessorFn: (BarChartData data, _) => '${data.porcentaje}%',
        colorFn: (_, __) => getRandomColor(),
        data: data, // Utiliza los datos de la API
      )
    ];

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
        charts.DatumLegend(
          outsideJustification: charts.OutsideJustification.endDrawArea,
          horizontalFirst: false,
          desiredMaxRows: 2,
          cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
          entryTextStyle: charts.TextStyleSpec(
            color: charts.MaterialPalette.black,
            fontSize: 12,
          ),
        ),
      ],
      defaultRenderer: charts.ArcRendererConfig(
        arcWidth: 100, // Ancho de los segmentos del gráfico de pastel
        arcRendererDecorators: [
          charts.ArcLabelDecorator(
            labelPosition: charts.ArcLabelPosition
                .auto, // Mostrar etiquetas automáticamente fuera cuando sea necesario
            leaderLineStyleSpec: charts.ArcLabelLeaderLineStyleSpec(
              color: charts.MaterialPalette
                  .black, // Color transparente para la línea líder
              length:
                  10, // Ajusta la longitud de la línea líder según sea necesario
              thickness:
                  1.0, // Ajusta el grosor de la línea líder según sea necesario
            ),
            insideLabelStyleSpec: const charts.TextStyleSpec(
              fontSize: 12, // Tamaño de letra de la etiqueta de porcentaje
              color: charts.Color
                  .white, // Color de la letra de la etiqueta de porcentaje
            ),
            outsideLabelStyleSpec: charts.TextStyleSpec(
              fontSize: 12, // Tamaño de letra de la etiqueta de porcentaje
              color: charts.Color
                  .black, // Color de la letra de la etiqueta de porcentaje
            ),
          ),
        ],
      ),
    );

    return MaterialApp(
      theme: ThemeData(
        tabBarTheme: TabBarTheme(
          indicatorColor: Colors.black,
        ),
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
      body: DefaultTabController(
        length: 3,
            child: Column(
              children: [
                TabBar(
                  dividerColor: Colors.black,
                  indicatorColor: Colors.black,
                  tabs: [
                    Tab(icon: Icon(Icons.directions_car)),
                    Tab(icon: Icon(Icons.directions_transit)),
                    Tab(icon: Icon(Icons.directions_bike)),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Container(
                          height: 500,
                          child: chart,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Container(
                          height: 500,
                          child: pieChart,
                        ),
                      ),
                      Center(
                        child: Text('Contenido de la pestaña 3'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
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
