import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simexpro/screens/login_screen.dart';
import 'package:simexpro/screens/profile_screen.dart';

import 'package:http/http.dart' as http;
import 'package:simexpro/api.dart';

import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;

import 'dart:math';

enum MenuItem { item1, item2 }

class GraficasAduanas extends StatefulWidget {
  @override
  State<GraficasAduanas> createState() => Graficas();
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

class Graficas extends State<GraficasAduanas> {
  //DECLARACION DE VARIABLES UTILIZADAS EN LAS GRAFICAS
  List<RegimenesAduaneros> RegimenesData = [];

  Future<void> GetRegimenesAduaneros() async {
    try {
      final response = await http.get(
        Uri.parse(
            '${apiUrl}AduanasGraficas/RegimenesAduaneros_CantidadPorcentaje'),
        headers: {
          'XApiKey': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> jsonData = responseData['data'];

        setState(() {
          RegimenesData = jsonData.map((item) {
            // Divide la cadena 'label' en dos partes usando "|"
            List<String> partes = item['label'].split("|");

            // Verifica si hay al menos dos partes (si hay "|")
            if (partes.length > 1) {
              return RegimenesAduaneros(partes[0], item['cantidad']);
            } else {
              // Si no hay "|", simplemente usa la cadena original
              return RegimenesAduaneros(item['label'], item['cantidad']);
            }
          }).toList();
        });
      }
    } catch (error) {
      throw Exception('Error: ${error}');
    }
  }

  //LLMMAR  A LAS FUNCIONES QUE HACEN LAS PETICIONES A LA API
  void initState() {
    super.initState();
    GetRegimenesAduaneros();
    //Imagen();
  }

  @override
  Widget build(BuildContext context) {
    // Genera una lista de colores aleatorios para el grafico pie
    final List<charts.Color> randomColors = List.generate(
      RegimenesData.length,
      (_) => getRandomColor(),
    );

    //ASIGNACION DEL GRAFICO DE BARRAS (MODULOS MAS PRODUCTIVOS)
    final List<charts.Series<RegimenesAduaneros, String>> DatosGraficaRegimenes = [
      charts.Series<RegimenesAduaneros, String>(
        id: 'Barras',
        domainFn: (RegimenesAduaneros data, _) => data.label,
        measureFn: (RegimenesAduaneros data, _) => data.cantidad,
        labelAccessorFn: (RegimenesAduaneros data, _) {
          final Porcentaje = (data.cantidad /
                  RegimenesData.map((item) => item.cantidad)
                      .reduce((a, b) => a + b) *
                  100)
              .toStringAsFixed(1);
          return '${Porcentaje}%';
        },
        colorFn: (RegimenesAduaneros data, int? index) => randomColors[
            index ?? 0], // Asigna el color desde la lista de colores aleatorios
        data: RegimenesData, // Utiliza los datos de la API
      )
    ];

    //GRAFICA DE BARRAS (MODULOS MAS PRODUCTIVOS)
    final GraficaRegimenes = new charts.BarChart(
      DatosGraficaRegimenes,
      animate: true,
      vertical: true,
      domainAxis: new charts.OrdinalAxisSpec(
        renderSpec: new charts.SmallTickRendererSpec(
          labelStyle: new charts.TextStyleSpec(
            color: charts.MaterialPalette.black,
          ),
          labelRotation: 60,
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
                Tab(icon: Icon(Icons.auto_graph_sharp)),
                Tab(icon: Icon(Icons.pie_chart)),
                Tab(icon: Icon(Icons.add_task)),
                Tab(icon: Icon(Icons.attach_money_rounded)),
              ],
            ),
            //systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          body: TabBarView(
            children: [
              Card(
                margin: EdgeInsets.all(10.0), // Margen de la tarjeta
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          'Regimenes Aduaneros más Usados',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0), // Centra el título
                      ),
                      Container(
                        height:
                            500, // Establece una altura específica para el contenido
                        padding: EdgeInsets.all(
                            16.0), // Padding dentro de la tarjeta
                        child:
                            GraficaRegimenes, // El contenido de la tarjeta, en este caso, el gráfico
                      ),
                    ],
                  ),
                ),
              ),
              Card(),
              Card(),
              Card()
            ],
          ),
        ),
      ),
    );
  }
}

class RegimenesAduaneros {
  final String label;
  final int cantidad;

  RegimenesAduaneros(this.label, this.cantidad);
}
