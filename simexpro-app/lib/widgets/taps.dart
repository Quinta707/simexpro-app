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
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Image(
                height: 35,
                image: NetworkImage('https://i.ibb.co/HgdBM0r/slogan.png')),
            centerTitle: true,
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(''),
                  child: PopupMenuButton<MenuItem>(
                    //padding: EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        '',
                        width: 50,
                      ),
                    ),
                    onSelected: (value) {
                      if (value == MenuItem.item1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(),
                            ));
                      }
                      if (value == MenuItem.item2) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => loginScreen(),
                            ));
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem<MenuItem>(
                        value: MenuItem.item1,
                        child: Row(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.person_2_outlined,
                                  color: Color.fromRGBO(87, 69, 223, 1),
                                )),
                            const Text(
                              'Mi Perfil',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<MenuItem>(
                        value: MenuItem.item2,
                        child: Row(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.logout,
                                  color: Color.fromRGBO(87, 69, 223, 1),
                                )),
                            const Text(
                              'Cerrar Sesión',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
            backgroundColor: Color.fromRGBO(17, 24, 39, 1),
            //elevation: 50.0,
            leading: IconButton(
              icon: const Icon(Icons.menu),
              tooltip: 'Menú',
              onPressed: () {},
            ),

            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            //systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Container(
                  height:
                      500, // Establece una altura específica para la gráfica
                  child: chart,
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
              Center(
                child: Text(
                    'Contenido de la pestaña 3'), // Contenido de la pestaña 3
              ),
            ],
          ),
        ),
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
