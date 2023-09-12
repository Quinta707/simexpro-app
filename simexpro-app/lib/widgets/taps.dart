import 'package:cherry_toast/resources/arrays.dart';
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
import 'package:fl_chart/fl_chart.dart';

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
  num Conteo = 0;
  var ConteoMesPendiente = 0;
  var ConteoMesFinalizado = 0;

  List<BarChartData> data = [];
  List<Clientes> ClientesData = [];

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
              .map((item) => Clientes(
                  item['clie_Nombre_O_Razon_Social'], item['cantidadIngresos']))
              .toList();
        });
      }
    } catch (error) {
      throw Exception('Error: ${error}');
    }
  }

  //PETICION PARA OPTENER LA CABTIDAD DE  ORDENES EN EL AÑO
  Future<void> OrdenesAnio() async {
    try {
      final response = await http.get(
        Uri.parse('${apiUrl}Graficas/OrdenenesEntregadasPendientes_Anual'),
        headers: {
          'XApiKey': apiKey,
        },
      );
      final jsonBody = json.decode(response.body);
      final data = jsonBody['data'];

      for (var item in data) {
        String avance = item['orco_Avance'];
        int conteo = item['orco_Conteo'];

        setState(() {
          if (avance == "Terminado") {
            Conteo += conteo;
          } else {
            Conteo += 0;
          }
        });
      }
    } catch (error) {
      print(error);
    }
  }

  //PETICION PARA OPTENER LA CABTIDAD DE  ORDENES EN EL MES
  Future<void> OrdenesMes() async {
    try {
      final response = await http.get(
        Uri.parse('${apiUrl}Graficas/OrdenenesEntregadasPendientes_Mensual'),
        headers: {
          'XApiKey': apiKey,
        },
      );
      final jsonBody = json.decode(response.body);
      final dataMes = jsonBody['data'];

      for (var item in dataMes) {
        String avance = item['orco_Avance'];
        int conteo = item['orco_Conteo'];

        setState(() {
          if (avance == "Terminado") {
            ConteoMesFinalizado += conteo;
          } else if (avance == "Pendiente") {
            ConteoMesPendiente += conteo;
          }
        });
      }
    } catch (error) {
      print(error);
    }
  }

  //LLMMAR  A LAS FUNCIONES QUE HACEN LAS PETICIONES A LA API
  void initState() {
    super.initState();
    fetchDataFromAPI();
    clientesProdivos();
    OrdenesAnio();
    OrdenesMes();
    //Imagen();
  }

  @override
  Widget build(BuildContext context) {
    // Genera una lista de colores aleatorios para el grafico pie
    final List<charts.Color> randomColors = List.generate(
      data.length,
      (_) => getRandomColor(),
    );

    //ASIGNACION DEL GRAFICO DE BARRAS (MODULOS MAS PRODUCTIVOS)
    final List<charts.Series<BarChartData, String>> seriesList = [
      charts.Series<BarChartData, String>(
        id: 'Barras',
        domainFn: (BarChartData data, _) => data.modu_Nombre,
        measureFn: (BarChartData data, _) => data.totalProduccionDia,
        labelAccessorFn: (BarChartData data, _) => '${data.porcentaje}%',
        colorFn: (BarChartData data, int? index) => randomColors[
            index ?? 0], // Asigna el color desde la lista de colores aleatorios
        data: data, // Utiliza los datos de la API
      )
    ];

    //ASIGNACION DEL GRAFICO DE BARRAS (MODULOS MAS PRODUCTIVOS)
    final List<charts.Series<Clientes, String>> ClientesGrafica = [
      charts.Series<Clientes, String>(
        id: 'Barras',
        domainFn: (Clientes data, _) => data.cliente_Nombre,
        measureFn: (Clientes data, _) => data.Cantidad_Ingresos,
        labelAccessorFn: (Clientes data, _) {
          final porcentaje = (data.Cantidad_Ingresos /
                  ClientesData.map((cliente) => cliente.Cantidad_Ingresos)
                      .reduce((a, b) => a + b) *
                  100)
              .toStringAsFixed(2);
          return '${porcentaje}%';
        },
        colorFn: (Clientes data, int? index) => randomColors[
            index ?? 0], // Asigna el color desde la lista de colores aleatorios
        data: ClientesData, // Utiliza los datos de la API
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
      ClientesGrafica,
      animate: true,
      behaviors: [
        charts.DatumLegend(
          outsideJustification: charts.OutsideJustification.endDrawArea,
          horizontalFirst: false,
          desiredMaxRows: 2,
          cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
          entryTextStyle: charts.TextStyleSpec(
            color: charts.MaterialPalette.black,
            fontSize: 15,
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
                  5, // Ajusta la longitud de la línea líder según sea necesario
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

    final LineChart lineChart = LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: Colors.blue, // Cambia el color de la línea
            width: 1,
          ),
        ),
        minX: 0,
        maxX: 1, // Aquí solo necesitas dos puntos (0 y 1) para un solo dato
        minY: 0,
        maxY: 1000, // Ajusta el rango según tus datos de ganancias
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 0),   // Punto inicial (mes 0, ganancia 0)
              FlSpot(1, 600), // Punto final (mes 1, ganancia 500)
            ],
            isCurved: true, // Hacer que la línea sea curva
            color:Colors.blue, // Cambia el color de la línea
            dotData: FlDotData(show: true), // Mostrar el punto
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 4,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 15),
                    Container(
                      width: 385,
                      height: 110,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(208, 255, 213, 1),
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
                                    color: Color.fromARGB(255, 11, 174, 60)),
                              ),
                            ),
                            const Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
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
                                        color: Color.fromARGB(255, 11, 174, 60),
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
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: 165,
                            height: 110,
                            margin: EdgeInsets.only(left: 10),
                            padding: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 175, 175, 1),
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
                                      "ÓRDENES PENDIENTES DEL MES",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color:
                                              Color.fromARGB(255, 255, 22, 22)),
                                    ),
                                  ),
                                  const Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Divider(
                                      color: Colors.white,
                                      thickness: 2,
                                      height: 20,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            ConteoMesPendiente == 1
                                                ? ' ${ConteoMesPendiente} Órden Pendiente'
                                                : '${ConteoMesPendiente} Órdenes Pendientes',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Color.fromARGB(
                                                  255, 255, 22, 22),
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
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            width: 165,
                            height: 110,
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(208, 255, 213, 1),
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
                                      "ÓRDENES FINALIZADAS DEL MES",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color:
                                              Color.fromARGB(255, 11, 174, 60)),
                                    ),
                                  ),
                                  const Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Divider(
                                      color: Colors.white,
                                      thickness: 2,
                                      height: 20,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            ConteoMesFinalizado == 1
                                                ? ' ${ConteoMesFinalizado} Órden Completada'
                                                : '${ConteoMesFinalizado} Órdenes Completadas',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 11, 174, 60),
                                              fontSize: 13,
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
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Ganancias Mensuales'),
                          SizedBox(
                            width: 300,
                            height: 200,
                            child: lineChart,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Center(
                  
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    Text('Ganancias Mensuales'),
                    SizedBox(
                      width: 150,
                      height: 100,
                      child: lineChart,
                    ),
                  ]))
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

class Clientes {
  final String cliente_Nombre;
  final int Cantidad_Ingresos;

  Clientes(this.cliente_Nombre, this.Cantidad_Ingresos);
}
